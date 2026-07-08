import 'package:flutter_test/flutter_test.dart';
import 'package:vividfit_v2/data/models/login_response.dart';

void main() {
  group('LoginResponse.fromJson', () {
    test('解析成功响应(code=200,含 token + userInfo)', () {
      final json = {
        'code': '200',
        'msg': 'success',
        'data': {
          'token': 'tk_123',
          'userInfo': {
            'id': 88,
            'nickName': 'Alice',
            'sex': true,
            'height': 170,
            'weight': 60,
            'mailAddress': 'a@b.com',
            'hasPsw': true,
          },
        },
      };
      final resp = LoginResponse.fromJson(json);
      expect(resp.code, '200');
      expect(resp.data?.token, 'tk_123');
      expect(resp.data?.userInfo?.id, 88);
      expect(resp.data?.userInfo?.nickName, 'Alice');
      expect(resp.data?.userInfo?.hasPsw, true);
    });

    test('解析错误响应(code=402,无 data)', () {
      final json = {'code': '402', 'msg': 'wrong password', 'data': null};
      final resp = LoginResponse.fromJson(json);
      expect(resp.code, '402');
      expect(resp.msg, 'wrong password');
      expect(resp.data, isNull);
    });

    test('toJson 能往返', () {
      final json = {
        'code': '200',
        'data': {'token': 't', 'userInfo': {'id': 1}},
      };
      final resp = LoginResponse.fromJson(json);
      final out = resp.toJson();
      expect(out['code'], '200');
      // freezed toJson 后 data 字段为 LoginData 实例(非 Map)
      expect((out['data'] as LoginData).token, 't');
      expect((out['data'] as LoginData).userInfo?.id, 1);
    });
  });
}
