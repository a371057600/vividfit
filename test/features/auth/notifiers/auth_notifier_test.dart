import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vividfit_v2/core/services/storage_service.dart';
import 'package:vividfit_v2/data/models/login_response.dart';
import 'package:vividfit_v2/data/models/user_info.dart';
import 'package:vividfit_v2/features/auth/notifiers/auth_notifier.dart';
import 'package:vividfit_v2/features/auth/repositories/auth_repository.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  // connectivity_plus 的平台通道需要 binding 已初始化。
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockAuthRepository repository;
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.create();
    repository = _MockAuthRepository();
    registerFallbackValue(LoginResponse());
  });

  group('AuthNotifier', () {
    test('初始状态:未登录、未同意协议、无错误', () {
      final notifier = AuthNotifier(repository, storage);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.agreedToPrivacy, false);
      expect(notifier.state.errorMessage, isNull);
    });

    test('togglePrivacyAgreement 切换同意状态', () {
      final notifier = AuthNotifier(repository, storage);
      expect(notifier.state.agreedToPrivacy, false);
      notifier.togglePrivacyAgreement();
      expect(notifier.state.agreedToPrivacy, true);
      notifier.togglePrivacyAgreement();
      expect(notifier.state.agreedToPrivacy, false);
    });

    test('登录成功(code=200):状态变 authenticated,token/userId/userInfo 持久化', () async {
      final loginResp = LoginResponse(
        code: '200',
        msg: 'ok',
        data: LoginData(
          token: 'tok_success',
          userInfo: FitUserInfo(
            id: 99,
            nickName: 'Bob',
            hasPsw: true,
            headImage: 'img_hash',
          ),
        ),
      );
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResp);

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('bob');
      notifier.setPassword('pw');
      await notifier.login();

      expect(notifier.state.isLoading, false);
      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.accessToken, 'tok_success');
      expect(notifier.state.userId, 99);
      expect(notifier.state.userInfo?.nickName, 'Bob');
      expect(notifier.state.errorMessage, isNull);

      // 持久化校验
      expect(storage.accessToken, 'tok_success');
      expect(storage.userId, 99);
      expect(storage.hasPassword, true);
      expect(storage.headImageHash, 'img_hash');
      expect(storage.userInfoJson, isNotNull);
    });

    test('登录 code=402(旧项目空分支):保持未登录,不设 errorMessage', () async {
      final loginResp = LoginResponse(code: '402', msg: 'wrong password');
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResp);

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('x');
      notifier.setPassword('y');
      await notifier.login();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.isLoading, false);
      // 旧项目 402/403/412 分支为空(注释掉了),1:1 保留:不弹 toast、不设错误。
      expect(notifier.state.errorMessage, isNull);
      expect(storage.accessToken, isNull);
    });

    test('登录 code=412(旧项目空分支):保持未登录,不设 errorMessage', () async {
      final loginResp = LoginResponse(code: '412', msg: 'disabled');
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResp);

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('x');
      notifier.setPassword('y');
      await notifier.login();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.errorMessage, isNull);
    });

    test('登录 code=400:验证码错误,设 errorMessage', () async {
      final loginResp = LoginResponse(code: '400', msg: 'bad code');
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResp);

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('x');
      notifier.setPassword('y');
      await notifier.login();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.errorMessage, 'Incorrect verification code.');
    });

    test('新用户注册(code=201):同样视为登录成功并持久化', () async {
      final loginResp = LoginResponse(
        code: '201',
        data: LoginData(token: 'tok_new', userInfo: FitUserInfo(id: 7, nickName: 'New')),
      );
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenAnswer((_) async => loginResp);

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('n');
      notifier.setPassword('p');
      await notifier.login();

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.accessToken, 'tok_new');
      expect(notifier.state.userId, 7);
      expect(storage.accessToken, 'tok_new');
    });

    test('repository 抛异常:状态变 error,不崩溃', () async {
      when(() => repository.login(account: any(named: 'account'), password: any(named: 'password')))
          .thenThrow(Exception('boom'));

      final notifier = AuthNotifier(repository, storage);
      notifier.setEmailAccount('a');
      notifier.setPassword('b');
      await notifier.login();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.isLoading, false);
      expect(notifier.state.errorMessage, isNotNull);
    });

    test('logout:清空状态 + 清除本地存储(保留 languageNum)', () async {
      await storage.setAccessToken('t');
      await storage.setUserId(1);
      await storage.setFitUserInfoJson('{}');
      await storage.setLanguageNum(0);

      final notifier = AuthNotifier(repository, storage);
      await notifier.logout();

      expect(notifier.state.isAuthenticated, false);
      expect(notifier.state.accessToken, isNull);
      expect(storage.accessToken, isNull);
      expect(storage.userId, isNull);
      // 语言设置应保留。
      expect(notifier.state.languageNum, 0);
    });

    test('构造时从本地存储恢复已登录状态', () async {
      await storage.setAccessToken('persisted_tok');
      await storage.setUserId(55);
      await storage.setFitUserInfoJson('{"id":55,"nickName":"Restored"}');

      final notifier = AuthNotifier(repository, storage);

      expect(notifier.state.isAuthenticated, true);
      expect(notifier.state.accessToken, 'persisted_tok');
      expect(notifier.state.userId, 55);
      expect(notifier.state.userInfo?.nickName, 'Restored');
    });

    test('构造时从本地存储恢复 languageNum', () async {
      await storage.setLanguageNum(0);
      final notifier = AuthNotifier(repository, storage);
      expect(notifier.state.languageNum, 0);
    });
  });
}
