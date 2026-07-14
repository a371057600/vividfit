# 应用证书信息 - IPC备案

## 应用信息

- **应用名称**: VividFit
- **Android 包名**: `cn.rido.vividfit`
- **iOS Bundle ID**: `cn.rido.vividfit`

## 签名证书信息

### 证书指纹

| 算法 | 指纹值 |
|------|--------|
| **MD5** | `4C:7E:FB:56:FA:60:57:25:0F:E0:B3:F1:5E:63:67:5E` |
| **SHA1** | `67:27:EA:2F:59:39:87:A5:9A:7D:7B:AD:8C:AC:71:FB:36:31:CE:42` |
| **SHA256** | `4D:33:FB:DB:8C:E5:12:AA:DE:67:17:04:24:3E:4F:91:B2:89:64:2E:DF:4D:DD:47:55:9B:99:79:19:7B:02:52` |

### 公钥

```
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA8oqN58qBMzamWJgQkCQh
uSEMqJxoqyWTe5yq2dNjx37JKpaskRLg7uWkyvEGwAA+FHTKo8gftXI5ScZ8iWsJ
MPLphiQP9N7rxTEQuPB4Gc8VVDYYyCsuHuQpamVlmAgMljiTclg4JEXShQGiDQwQ
XZnJZQQzQUyKhdzbcnCwpVmqw54TLct8/W4SQDCBe8uuBYYn2XAcyHcSYzmVIbEX
e+RwCcAfjjtALUrnHZ0OrIjngJ1riLKQz5JN2GRPmGlMcOfisg2CqKeq02O1EFUi
8tEkkBBEMFqeE21YkfU431f1w3vvbNO0DfYOWV9RMUC7Fi0bcG+pJT0OZkQKv7If
xQIDAQAB
-----END PUBLIC KEY-----
```

### 公钥哈希值（base64编码）

```
A50D4BBB41D0BB227E6D7821867F9BD36169465B
```

## 证书详情

- **证书别名**: vividfit
- **密钥库文件**: `app/vividfit-release.jks`
- **密钥算法**: RSA 2048位
- **签名算法**: SHA384withRSA
- **有效期**: 2026年7月14日 - 2053年11月29日
- **所有者**: CN=Rido, OU=Rido, O=Rido, L=Shenzhen, ST=Guangdong, C=CN

## 配置文件修改记录

### Android

| 文件 | 修改内容 |
|------|----------|
| `app/build.gradle.kts` | namespace 和 applicationId 修改为 `cn.rido.vividfit`，添加 release 签名配置 |
| `app/src/main/AndroidManifest.xml` | MainActivity 完整类名更新为 `cn.rido.vividfit.MainActivity` |
| `app/src/main/kotlin/cn/rido/vividfit/MainActivity.kt` | 包名修改为 `cn.rido.vividfit` |

### iOS

| 文件 | 修改内容 |
|------|----------|
| `Runner.xcodeproj/project.pbxproj` | Debug/Release/Profile 配置的 PRODUCT_BUNDLE_IDENTIFIER 修改为 `cn.rido.vividfit` |