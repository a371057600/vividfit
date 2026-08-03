import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vividfit_v2/data/api/api_providers.dart';

class ApiTestPage extends ConsumerStatefulWidget {
  const ApiTestPage({super.key});

  @override
  ConsumerState<ApiTestPage> createState() => _ApiTestPageState();
}

class _ApiTestPageState extends ConsumerState<ApiTestPage> {
  final _resultController = TextEditingController();
  final _userIdController = TextEditingController(text: '1');
  final _accountController = TextEditingController();
  final _passwordController = TextEditingController();
  final _tokenController = TextEditingController();
  final _mailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _codeController = TextEditingController();
  final _equipmentTypeController = TextEditingController(text: '0');
  final _langController = TextEditingController(text: 'zh');
  final _timeTypeController = TextEditingController(text: 'all');

  String _currentResult = '';

  void _log(String text) {
    debugPrint('═══════════════════════════════════════════');
    debugPrint(text);
    debugPrint('═══════════════════════════════════════════');
    setState(() {
      _currentResult = '$_currentResult\n$text\n';
    });
    _resultController.text = _currentResult;
  }

  Future<void> _runTest(String name, Future<dynamic> Function() test) async {
    _log('▶️ 开始测试: $name');
    try {
      final result = await test().timeout(const Duration(seconds: 10));
      _log('✅ $name 成功: ${result.toString()}');
    } catch (e) {
      _log('❌ $name 失败: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API 测试'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInputSection(),
            const SizedBox(height: 16),
            _buildPublicSection(),
            const SizedBox(height: 16),
            _buildUserSection(),
            const SizedBox(height: 16),
            _buildSportHistorySection(),
            const SizedBox(height: 16),
            _buildSportStatisticsSection(),
            const SizedBox(height: 16),
            _buildWebSection(),
            const SizedBox(height: 16),
            _buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildInputSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('输入参数', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            _buildTextField('UserId', _userIdController),
            _buildTextField('账号', _accountController),
            _buildTextField('密码', _passwordController, obscure: true),
            _buildTextField('Token', _tokenController),
            _buildTextField('邮箱', _mailController),
            _buildTextField('手机', _phoneController),
            _buildTextField('验证码', _codeController),
            _buildTextField('设备类型', _equipmentTypeController),
            _buildTextField('语言', _langController),
            _buildTextField('时间类型', _timeTypeController),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 80, child: Text(label)),
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscure,
              decoration: const InputDecoration(
                isDense: true,
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPublicSection() {
    final publicApi = ref.watch(publicApiProvider);
    return _buildSection('Public Controller', [
      _buildTestButton('密码登录', () => publicApi.loginByPassword(
        bindingAccount: _accountController.text,
        password: _passwordController.text,
      )),
      _buildTestButton('邮箱验证码登录', () => publicApi.loginByMailVerificationCode(
        mailAddress: _mailController.text,
        code: _codeController.text,
        businessType: 'login',
      )),
      _buildTestButton('手机验证码登录', () => publicApi.loginByPhoneVerificationCode(
        phoneNumber: _phoneController.text,
        areaCode: '86',
        code: _codeController.text,
        businessType: 'login',
      )),
      _buildTestButton('检查邮箱绑定', () => publicApi.checkBindMail(
        mailAddress: _mailController.text,
      )),
      _buildTestButton('检查手机绑定', () => publicApi.checkBindPhone(
        phoneNumber: _phoneController.text,
      )),
      _buildTestButton('修改密码', () => publicApi.updatePassword(
        userId: int.parse(_userIdController.text),
        newPassword: _passwordController.text,
      )),
      _buildTestButton('刷新Token', () => publicApi.refreshToken()),
      _buildTestButton('验证码校验', () => publicApi.checkVerCode(
        target: _mailController.text,
        code: _codeController.text,
        businessType: 'login',
      )),
      _buildTestButton('发送邮箱验证码', () => publicApi.sendMailVerCode(
        mailAddress: _mailController.text,
        businessType: 'login',
      )),
      _buildTestButton('发送手机验证码', () => publicApi.sendPhoneVerCode(
        phoneNumber: _phoneController.text,
        areaCode: '86',
        businessType: 'login',
      )),
    ]);
  }

  Widget _buildUserSection() {
    final userApi = ref.watch(userApiProvider);
    return _buildSection('User Controller', [
      _buildTestButton('获取用户信息', () => userApi.getUserInfo(
        userId: int.parse(_userIdController.text),
      )),
      _buildTestButton('退出登录', () => userApi.signOut()),
      _buildTestButton('注销账号', () => userApi.deleteAccount()),
      _buildTestButton('修改邮箱', () => userApi.updateMail(
        userId: int.parse(_userIdController.text),
        newMail: _mailController.text,
        code: _codeController.text,
        businessType: 'bind',
      )),
      _buildTestButton('修改手机', () => userApi.updatePhone(
        userId: int.parse(_userIdController.text),
        phoneNumber: _phoneController.text,
        areaCode: '86',
        code: _codeController.text,
        businessType: 'bind',
      )),
    ]);
  }

  Widget _buildSportHistorySection() {
    final historyApi = ref.watch(sportHistoryApiProvider);
    return _buildSection('Sport History Controller', [
      _buildTestButton('查询运动数据', () => historyApi.getSportHistory(
        userId: int.parse(_userIdController.text),
        equipmentType: int.parse(_equipmentTypeController.text),
        page: 0,
      )),
      _buildTestButton('获取运动详情', () => historyApi.getSportHistoryDetail(
        id: int.parse(_userIdController.text),
      )),
      _buildTestButton('多设备查询', () => historyApi.getSportHistoryMultiTypes(
        userId: int.parse(_userIdController.text),
        equipmentTypes: [int.parse(_equipmentTypeController.text)],
        page: 0,
      )),
    ]);
  }

  Widget _buildSportStatisticsSection() {
    final statsApi = ref.watch(sportStatisticsApiProvider);
    return _buildSection('Sport Statistics Controller', [
      _buildTestButton('运动统计', () => statsApi.getSportStatistics(
        userId: int.parse(_userIdController.text),
        equipmentType: int.parse(_equipmentTypeController.text),
        timeArea: 1,
      )),
      _buildTestButton('运动日历', () => statsApi.getSportCalendar(
        userId: int.parse(_userIdController.text),
        duringTime: 1,
        startTime: '2024-01-01 00:00:00',
        endTime: '2024-12-31 23:59:59',
      )),
      _buildTestButton('卡路里榜', () => statsApi.getCaloriesLeaderboard(
        equipmentType: int.parse(_equipmentTypeController.text),
        timeType: _timeTypeController.text,
      )),
      _buildTestButton('新勋章', () => statsApi.getNewMedal(
        userId: int.parse(_userIdController.text),
        lang: _langController.text,
      )),
      _buildTestButton('勋章面板', () => statsApi.getMedalPanel(
        userId: int.parse(_userIdController.text),
        lang: _langController.text,
      )),
      _buildTestButton('勋章总数', () => statsApi.getMedalTotalCount(
        userId: int.parse(_userIdController.text),
      )),
      _buildTestButton('排行榜信息', () => statsApi.getUserLeaderboardInfo(
        userId: int.parse(_userIdController.text),
        equipmentType: int.parse(_equipmentTypeController.text),
        timeType: _timeTypeController.text,
      )),
    ]);
  }

  Widget _buildWebSection() {
    final webApi = ref.watch(webApiProvider);
    return _buildSection('Web Controller', [
      _buildTestButton('Web排行榜', () => webApi.getWebRank()),
    ]);
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: children,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTestButton(String label, Future<dynamic> Function() test) {
    return ElevatedButton(
      onPressed: () => _runTest(label, test),
      child: Text(label),
    );
  }

  Widget _buildResultSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('测试结果', style: TextStyle(fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _currentResult = '';
                      _resultController.text = '';
                    });
                  },
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: TextField(
                controller: _resultController,
                maxLines: null,
                expands: true,
                readOnly: true,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.all(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}