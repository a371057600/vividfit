// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$AuthState {
  // ---- 通用 ----
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isAuthenticated => throw _privateConstructorUsedError;
  bool get agreedToPrivacy => throw _privateConstructorUsedError;
  String? get accessToken => throw _privateConstructorUsedError;
  int? get userId => throw _privateConstructorUsedError;
  UserInfo? get userInfo => throw _privateConstructorUsedError;
  String? get errorMessage =>
      throw _privateConstructorUsedError; // ---- 表单字段(对应旧 .obs 变量)----
  String get emailAccount =>
      throw _privateConstructorUsedError; // 邮箱/账号(bindingAccount)
  String get password => throw _privateConstructorUsedError; // 密码
  String get changepassword => throw _privateConstructorUsedError; // 新密码(找回密码用)
  String get countryCode => throw _privateConstructorUsedError; // 国家码 "86"
  int get phoneNumber => throw _privateConstructorUsedError; // 手机号
  String get captcha => throw _privateConstructorUsedError; // 验证码
  String get wechatCode => throw _privateConstructorUsedError; // 微信 code(预留)
  // ---- 倒计时 ----
  int get countdown => throw _privateConstructorUsedError; // 倒计时秒数
  bool get reGetCode => throw _privateConstructorUsedError; // 可重新获取验证码
  bool get reGetCode2 => throw _privateConstructorUsedError; // 可重新获取验证码(备用标志)
  // ---- UI 状态 ----
  bool get showPassword =>
      throw _privateConstructorUsedError; // 是否隐藏密码(true=隐藏)
  int get loginType => throw _privateConstructorUsedError; // 登录类型:1=手机 2=邮箱
  bool get ishasInternet => throw _privateConstructorUsedError; // 是否有网络
  int get languageNum => throw _privateConstructorUsedError;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AuthStateCopyWith<AuthState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AuthStateCopyWith<$Res> {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) then) =
      _$AuthStateCopyWithImpl<$Res, AuthState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isAuthenticated,
    bool agreedToPrivacy,
    String? accessToken,
    int? userId,
    UserInfo? userInfo,
    String? errorMessage,
    String emailAccount,
    String password,
    String changepassword,
    String countryCode,
    int phoneNumber,
    String captcha,
    String wechatCode,
    int countdown,
    bool reGetCode,
    bool reGetCode2,
    bool showPassword,
    int loginType,
    bool ishasInternet,
    int languageNum,
  });

  $UserInfoCopyWith<$Res>? get userInfo;
}

/// @nodoc
class _$AuthStateCopyWithImpl<$Res, $Val extends AuthState>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isAuthenticated = null,
    Object? agreedToPrivacy = null,
    Object? accessToken = freezed,
    Object? userId = freezed,
    Object? userInfo = freezed,
    Object? errorMessage = freezed,
    Object? emailAccount = null,
    Object? password = null,
    Object? changepassword = null,
    Object? countryCode = null,
    Object? phoneNumber = null,
    Object? captcha = null,
    Object? wechatCode = null,
    Object? countdown = null,
    Object? reGetCode = null,
    Object? reGetCode2 = null,
    Object? showPassword = null,
    Object? loginType = null,
    Object? ishasInternet = null,
    Object? languageNum = null,
  }) {
    return _then(
      _value.copyWith(
            isLoading:
                null == isLoading
                    ? _value.isLoading
                    : isLoading // ignore: cast_nullable_to_non_nullable
                        as bool,
            isAuthenticated:
                null == isAuthenticated
                    ? _value.isAuthenticated
                    : isAuthenticated // ignore: cast_nullable_to_non_nullable
                        as bool,
            agreedToPrivacy:
                null == agreedToPrivacy
                    ? _value.agreedToPrivacy
                    : agreedToPrivacy // ignore: cast_nullable_to_non_nullable
                        as bool,
            accessToken:
                freezed == accessToken
                    ? _value.accessToken
                    : accessToken // ignore: cast_nullable_to_non_nullable
                        as String?,
            userId:
                freezed == userId
                    ? _value.userId
                    : userId // ignore: cast_nullable_to_non_nullable
                        as int?,
            userInfo:
                freezed == userInfo
                    ? _value.userInfo
                    : userInfo // ignore: cast_nullable_to_non_nullable
                        as UserInfo?,
            errorMessage:
                freezed == errorMessage
                    ? _value.errorMessage
                    : errorMessage // ignore: cast_nullable_to_non_nullable
                        as String?,
            emailAccount:
                null == emailAccount
                    ? _value.emailAccount
                    : emailAccount // ignore: cast_nullable_to_non_nullable
                        as String,
            password:
                null == password
                    ? _value.password
                    : password // ignore: cast_nullable_to_non_nullable
                        as String,
            changepassword:
                null == changepassword
                    ? _value.changepassword
                    : changepassword // ignore: cast_nullable_to_non_nullable
                        as String,
            countryCode:
                null == countryCode
                    ? _value.countryCode
                    : countryCode // ignore: cast_nullable_to_non_nullable
                        as String,
            phoneNumber:
                null == phoneNumber
                    ? _value.phoneNumber
                    : phoneNumber // ignore: cast_nullable_to_non_nullable
                        as int,
            captcha:
                null == captcha
                    ? _value.captcha
                    : captcha // ignore: cast_nullable_to_non_nullable
                        as String,
            wechatCode:
                null == wechatCode
                    ? _value.wechatCode
                    : wechatCode // ignore: cast_nullable_to_non_nullable
                        as String,
            countdown:
                null == countdown
                    ? _value.countdown
                    : countdown // ignore: cast_nullable_to_non_nullable
                        as int,
            reGetCode:
                null == reGetCode
                    ? _value.reGetCode
                    : reGetCode // ignore: cast_nullable_to_non_nullable
                        as bool,
            reGetCode2:
                null == reGetCode2
                    ? _value.reGetCode2
                    : reGetCode2 // ignore: cast_nullable_to_non_nullable
                        as bool,
            showPassword:
                null == showPassword
                    ? _value.showPassword
                    : showPassword // ignore: cast_nullable_to_non_nullable
                        as bool,
            loginType:
                null == loginType
                    ? _value.loginType
                    : loginType // ignore: cast_nullable_to_non_nullable
                        as int,
            ishasInternet:
                null == ishasInternet
                    ? _value.ishasInternet
                    : ishasInternet // ignore: cast_nullable_to_non_nullable
                        as bool,
            languageNum:
                null == languageNum
                    ? _value.languageNum
                    : languageNum // ignore: cast_nullable_to_non_nullable
                        as int,
          )
          as $Val,
    );
  }

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserInfoCopyWith<$Res>? get userInfo {
    if (_value.userInfo == null) {
      return null;
    }

    return $UserInfoCopyWith<$Res>(_value.userInfo!, (value) {
      return _then(_value.copyWith(userInfo: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$AuthStateImplCopyWith<$Res>
    implements $AuthStateCopyWith<$Res> {
  factory _$$AuthStateImplCopyWith(
    _$AuthStateImpl value,
    $Res Function(_$AuthStateImpl) then,
  ) = __$$AuthStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isAuthenticated,
    bool agreedToPrivacy,
    String? accessToken,
    int? userId,
    UserInfo? userInfo,
    String? errorMessage,
    String emailAccount,
    String password,
    String changepassword,
    String countryCode,
    int phoneNumber,
    String captcha,
    String wechatCode,
    int countdown,
    bool reGetCode,
    bool reGetCode2,
    bool showPassword,
    int loginType,
    bool ishasInternet,
    int languageNum,
  });

  @override
  $UserInfoCopyWith<$Res>? get userInfo;
}

/// @nodoc
class __$$AuthStateImplCopyWithImpl<$Res>
    extends _$AuthStateCopyWithImpl<$Res, _$AuthStateImpl>
    implements _$$AuthStateImplCopyWith<$Res> {
  __$$AuthStateImplCopyWithImpl(
    _$AuthStateImpl _value,
    $Res Function(_$AuthStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isAuthenticated = null,
    Object? agreedToPrivacy = null,
    Object? accessToken = freezed,
    Object? userId = freezed,
    Object? userInfo = freezed,
    Object? errorMessage = freezed,
    Object? emailAccount = null,
    Object? password = null,
    Object? changepassword = null,
    Object? countryCode = null,
    Object? phoneNumber = null,
    Object? captcha = null,
    Object? wechatCode = null,
    Object? countdown = null,
    Object? reGetCode = null,
    Object? reGetCode2 = null,
    Object? showPassword = null,
    Object? loginType = null,
    Object? ishasInternet = null,
    Object? languageNum = null,
  }) {
    return _then(
      _$AuthStateImpl(
        isLoading:
            null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                    as bool,
        isAuthenticated:
            null == isAuthenticated
                ? _value.isAuthenticated
                : isAuthenticated // ignore: cast_nullable_to_non_nullable
                    as bool,
        agreedToPrivacy:
            null == agreedToPrivacy
                ? _value.agreedToPrivacy
                : agreedToPrivacy // ignore: cast_nullable_to_non_nullable
                    as bool,
        accessToken:
            freezed == accessToken
                ? _value.accessToken
                : accessToken // ignore: cast_nullable_to_non_nullable
                    as String?,
        userId:
            freezed == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                    as int?,
        userInfo:
            freezed == userInfo
                ? _value.userInfo
                : userInfo // ignore: cast_nullable_to_non_nullable
                    as UserInfo?,
        errorMessage:
            freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                    as String?,
        emailAccount:
            null == emailAccount
                ? _value.emailAccount
                : emailAccount // ignore: cast_nullable_to_non_nullable
                    as String,
        password:
            null == password
                ? _value.password
                : password // ignore: cast_nullable_to_non_nullable
                    as String,
        changepassword:
            null == changepassword
                ? _value.changepassword
                : changepassword // ignore: cast_nullable_to_non_nullable
                    as String,
        countryCode:
            null == countryCode
                ? _value.countryCode
                : countryCode // ignore: cast_nullable_to_non_nullable
                    as String,
        phoneNumber:
            null == phoneNumber
                ? _value.phoneNumber
                : phoneNumber // ignore: cast_nullable_to_non_nullable
                    as int,
        captcha:
            null == captcha
                ? _value.captcha
                : captcha // ignore: cast_nullable_to_non_nullable
                    as String,
        wechatCode:
            null == wechatCode
                ? _value.wechatCode
                : wechatCode // ignore: cast_nullable_to_non_nullable
                    as String,
        countdown:
            null == countdown
                ? _value.countdown
                : countdown // ignore: cast_nullable_to_non_nullable
                    as int,
        reGetCode:
            null == reGetCode
                ? _value.reGetCode
                : reGetCode // ignore: cast_nullable_to_non_nullable
                    as bool,
        reGetCode2:
            null == reGetCode2
                ? _value.reGetCode2
                : reGetCode2 // ignore: cast_nullable_to_non_nullable
                    as bool,
        showPassword:
            null == showPassword
                ? _value.showPassword
                : showPassword // ignore: cast_nullable_to_non_nullable
                    as bool,
        loginType:
            null == loginType
                ? _value.loginType
                : loginType // ignore: cast_nullable_to_non_nullable
                    as int,
        ishasInternet:
            null == ishasInternet
                ? _value.ishasInternet
                : ishasInternet // ignore: cast_nullable_to_non_nullable
                    as bool,
        languageNum:
            null == languageNum
                ? _value.languageNum
                : languageNum // ignore: cast_nullable_to_non_nullable
                    as int,
      ),
    );
  }
}

/// @nodoc

class _$AuthStateImpl implements _AuthState {
  const _$AuthStateImpl({
    this.isLoading = false,
    this.isAuthenticated = false,
    this.agreedToPrivacy = false,
    this.accessToken,
    this.userId,
    this.userInfo,
    this.errorMessage,
    this.emailAccount = '',
    this.password = '',
    this.changepassword = '',
    this.countryCode = '',
    this.phoneNumber = 0,
    this.captcha = '',
    this.wechatCode = '',
    this.countdown = 60,
    this.reGetCode = true,
    this.reGetCode2 = true,
    this.showPassword = true,
    this.loginType = 0,
    this.ishasInternet = false,
    this.languageNum = 1,
  });

  // ---- 通用 ----
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isAuthenticated;
  @override
  @JsonKey()
  final bool agreedToPrivacy;
  @override
  final String? accessToken;
  @override
  final int? userId;
  @override
  final UserInfo? userInfo;
  @override
  final String? errorMessage;
  // ---- 表单字段(对应旧 .obs 变量)----
  @override
  @JsonKey()
  final String emailAccount;
  // 邮箱/账号(bindingAccount)
  @override
  @JsonKey()
  final String password;
  // 密码
  @override
  @JsonKey()
  final String changepassword;
  // 新密码(找回密码用)
  @override
  @JsonKey()
  final String countryCode;
  // 国家码 "86"
  @override
  @JsonKey()
  final int phoneNumber;
  // 手机号
  @override
  @JsonKey()
  final String captcha;
  // 验证码
  @override
  @JsonKey()
  final String wechatCode;
  // 微信 code(预留)
  // ---- 倒计时 ----
  @override
  @JsonKey()
  final int countdown;
  // 倒计时秒数
  @override
  @JsonKey()
  final bool reGetCode;
  // 可重新获取验证码
  @override
  @JsonKey()
  final bool reGetCode2;
  // 可重新获取验证码(备用标志)
  // ---- UI 状态 ----
  @override
  @JsonKey()
  final bool showPassword;
  // 是否隐藏密码(true=隐藏)
  @override
  @JsonKey()
  final int loginType;
  // 登录类型:1=手机 2=邮箱
  @override
  @JsonKey()
  final bool ishasInternet;
  // 是否有网络
  @override
  @JsonKey()
  final int languageNum;

  @override
  String toString() {
    return 'AuthState(isLoading: $isLoading, isAuthenticated: $isAuthenticated, agreedToPrivacy: $agreedToPrivacy, accessToken: $accessToken, userId: $userId, userInfo: $userInfo, errorMessage: $errorMessage, emailAccount: $emailAccount, password: $password, changepassword: $changepassword, countryCode: $countryCode, phoneNumber: $phoneNumber, captcha: $captcha, wechatCode: $wechatCode, countdown: $countdown, reGetCode: $reGetCode, reGetCode2: $reGetCode2, showPassword: $showPassword, loginType: $loginType, ishasInternet: $ishasInternet, languageNum: $languageNum)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AuthStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isAuthenticated, isAuthenticated) ||
                other.isAuthenticated == isAuthenticated) &&
            (identical(other.agreedToPrivacy, agreedToPrivacy) ||
                other.agreedToPrivacy == agreedToPrivacy) &&
            (identical(other.accessToken, accessToken) ||
                other.accessToken == accessToken) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.userInfo, userInfo) ||
                other.userInfo == userInfo) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage) &&
            (identical(other.emailAccount, emailAccount) ||
                other.emailAccount == emailAccount) &&
            (identical(other.password, password) ||
                other.password == password) &&
            (identical(other.changepassword, changepassword) ||
                other.changepassword == changepassword) &&
            (identical(other.countryCode, countryCode) ||
                other.countryCode == countryCode) &&
            (identical(other.phoneNumber, phoneNumber) ||
                other.phoneNumber == phoneNumber) &&
            (identical(other.captcha, captcha) || other.captcha == captcha) &&
            (identical(other.wechatCode, wechatCode) ||
                other.wechatCode == wechatCode) &&
            (identical(other.countdown, countdown) ||
                other.countdown == countdown) &&
            (identical(other.reGetCode, reGetCode) ||
                other.reGetCode == reGetCode) &&
            (identical(other.reGetCode2, reGetCode2) ||
                other.reGetCode2 == reGetCode2) &&
            (identical(other.showPassword, showPassword) ||
                other.showPassword == showPassword) &&
            (identical(other.loginType, loginType) ||
                other.loginType == loginType) &&
            (identical(other.ishasInternet, ishasInternet) ||
                other.ishasInternet == ishasInternet) &&
            (identical(other.languageNum, languageNum) ||
                other.languageNum == languageNum));
  }

  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    isLoading,
    isAuthenticated,
    agreedToPrivacy,
    accessToken,
    userId,
    userInfo,
    errorMessage,
    emailAccount,
    password,
    changepassword,
    countryCode,
    phoneNumber,
    captcha,
    wechatCode,
    countdown,
    reGetCode,
    reGetCode2,
    showPassword,
    loginType,
    ishasInternet,
    languageNum,
  ]);

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      __$$AuthStateImplCopyWithImpl<_$AuthStateImpl>(this, _$identity);
}

abstract class _AuthState implements AuthState {
  const factory _AuthState({
    final bool isLoading,
    final bool isAuthenticated,
    final bool agreedToPrivacy,
    final String? accessToken,
    final int? userId,
    final UserInfo? userInfo,
    final String? errorMessage,
    final String emailAccount,
    final String password,
    final String changepassword,
    final String countryCode,
    final int phoneNumber,
    final String captcha,
    final String wechatCode,
    final int countdown,
    final bool reGetCode,
    final bool reGetCode2,
    final bool showPassword,
    final int loginType,
    final bool ishasInternet,
    final int languageNum,
  }) = _$AuthStateImpl;

  // ---- 通用 ----
  @override
  bool get isLoading;
  @override
  bool get isAuthenticated;
  @override
  bool get agreedToPrivacy;
  @override
  String? get accessToken;
  @override
  int? get userId;
  @override
  UserInfo? get userInfo;
  @override
  String? get errorMessage; // ---- 表单字段(对应旧 .obs 变量)----
  @override
  String get emailAccount; // 邮箱/账号(bindingAccount)
  @override
  String get password; // 密码
  @override
  String get changepassword; // 新密码(找回密码用)
  @override
  String get countryCode; // 国家码 "86"
  @override
  int get phoneNumber; // 手机号
  @override
  String get captcha; // 验证码
  @override
  String get wechatCode; // 微信 code(预留)
  // ---- 倒计时 ----
  @override
  int get countdown; // 倒计时秒数
  @override
  bool get reGetCode; // 可重新获取验证码
  @override
  bool get reGetCode2; // 可重新获取验证码(备用标志)
  // ---- UI 状态 ----
  @override
  bool get showPassword; // 是否隐藏密码(true=隐藏)
  @override
  int get loginType; // 登录类型:1=手机 2=邮箱
  @override
  bool get ishasInternet; // 是否有网络
  @override
  int get languageNum;

  /// Create a copy of AuthState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AuthStateImplCopyWith<_$AuthStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
