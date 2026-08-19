# VividFit v2 Code Wiki

> 本文档为 `vividfit_v2` 项目的结构化代码 Wiki,重点解读 **big_device(大设备)模块** 的页面作用与组成。核心业务逻辑仅作概要说明。

---

## 一、项目概览

| 项 | 说明 |
|---|---|
| 项目名 | `vividfit_v2` (VividFit - Fitness App) |
| 类型 | Flutter 跨平台 App(iOS / Android) |
| 版本 | `1.0.1+3` |
| Flutter | `3.44.8`(通过 FVM 锁定,见 `.fvmrc`) |
| 状态管理 | Riverpod 3.x + `riverpod_annotation` 代码生成 |
| 路由 | `go_router` |
| 网络 | `dio` + 拦截器 |
| 蓝牙 | `flutter_blue_plus`(FTMS 协议) |
| 数据建模 | `freezed` + `json_serializable` |
| WebView | `flutter_inappwebview`(游戏/实景) |
| 音频 | `just_audio` |
| 国际化 | `intl` + `flutter_localizations`(简中 / 繁中 / 英文) |

应用定位:面向家庭健身场景的 App,可连接大型健身器材(单车、跑步机、椭圆机、划船机、力量站),并提供课程训练、快速开始、实景跑、游戏化训练等多种运动模式。

---

## 二、整体架构

项目采用 **Feature-First(按功能划分)+ 分层(core / data / features)** 架构,并大量使用 Riverpod 代码生成(`@riverpod`)与 Freezed 不可变状态。

```
lib/
├── main.dart                 # 入口:ScreenUtil + Wakelock + Storage + 系统UI/Locale
├── app.dart                  # 根 Widget:MaterialApp.router + 主题 + i18n
├── core/                     # 核心能力层(与业务解耦)
│   ├── bluetooth/            # BLE 权限/特征/指令队列/防回声
│   ├── constants/            # API 端点 / 字体 / 存储键 / 主题
│   ├── devices/              # 设备白名单
│   ├── ftms/                 # FTMS 协议封装(设备类型/解析器/服务/指令/计时器)
│   ├── network/              # dio 客户端 + 拦截器 + 统一响应
│   ├── routing/              # go_router 配置(app_router.dart)
│   ├── services/             # API / 蓝牙连接 / 隐私 / 存储 Service + Provider
│   ├── utils/                # Loading / 隐私政策弹窗 / 协议 URL
│   └── widgets/              # 椭圆跑道 / 实时图表 / 协议 WebView
├── data/                     # 数据层
│   ├── api/                  # 各业务 API Provider(user/sport_history/...)
│   └── models/               # Freezed 数据模型(course/login/medal/user_info/...)
├── features/                # 功能模块
│   ├── about/               # 关于 / 账号安全 / 勋章 / 运动设置 / 头像
│   ├── auth/                # 登录注册(splash/login/email/phone/avatar/nickname)
│   ├── big_device/          # ★ 大设备模块(本文重点)
│   ├── course/              # 普通课程(列表/详情/播放)
│   ├── course_download/     # 课程下载(资源清单/进度/本地存储)
│   ├── dev/                 # 开发调试页(API 测试,上架隐藏)
│   ├── home/                # 主页外壳 + Tab + 体征数据 + 目标设置
│   ├── rank/                # 排行榜
│   └── record/              # 运动记录(主/列表/详情)
└── l10n/                    # 国际化资源(app_en.arb / app_zh.arb)
```

### 分层职责

- **core/**:基础设施,不依赖任何 feature。FTMS 协议、蓝牙连接、网络、路由、存储、主题均在此。
- **data/**:网络模型与 API Provider 定义,纯数据契约。
- **features/**:每个功能模块内部统一遵循 `pages / notifiers / states / repositories / widgets` 子结构,严格 MVVM-R(Pages → Notifiers(VM) → States(M) → Repositories(R))。

### 技术约定

- **状态管理**:所有跨页面状态使用 `@Riverpod(keepAlive: true)` 单例 Notifier;一次性页面使用 `@riverpod`(auto-dispose)。
- **不可变状态**:`@freezed` + `part '*.freezed.dart'`,配合 `copyWith`。
- **代码生成**:`.g.dart`(riverpod)、`.freezed.dart`(freezed)、`.g.dart`(json)由 `build_runner` 生成。
- **横屏约定**:big_device 全模块强制 `landscapeLeft` + `immersiveSticky`,退出时恢复竖屏。
- **国际化**:中文/英文走 `Locale('zh')` / `Locale('en')`,简繁由 arb 内容区分。

---

## 三、主要模块职责(非 big_device)

| 模块 | 职责概要 |
|---|---|
| `auth` | 启动页、账号/邮箱/手机登录、找回密码、验证码、昵称与头像设置;`authProvider` 维护登录态,驱动路由 redirect。 |
| `home` | 主页外壳(4 Tab:首页/课程/设备/我的)、体征数据录入、目标设置;提供大设备入口卡片(5 类设备)。 |
| `course` | 普通课程模块(列表/详情/播放),与 big_device 内课程独立。 |
| `course_download` | 课程资源下载、解压、本地清单管理,供课程播放使用。 |
| `about` | 个人资料、账号安全、勋章展示、运动设置、头像选择与裁剪。 |
| `rank` | 排行榜(按设备/日期筛选,Top3 + 列表)。 |
| `record` | 运动记录(日历主视图 + 列表 + 详情,含三环/图表)。 |
| `core/ftms` | FTMS 蓝牙协议封装:`FtmsDeviceType` 枚举(单车/跑步机/椭圆机/划船机/力量站)、各设备数据解析器、`FtmsServiceBase` 抽象、指令构建/调度、运动计时器、数据同步保护。 |
| `core/bluetooth` | `BluetoothConnectionService` 共享蓝牙连接(扫描/连接/断开/状态回调),`BluetoothPermission` 权限与适配器检查。 |
| `core/network` | `dioClientProvider` + auth/error/logging 拦截器 + `ApiResponse` 统一封装。 |

---

## 四、★ big_device 模块详解

> big_device 是项目最核心的功能模块,负责 **大型健身器材(单车/跑步机/椭圆机/划船机/力量站)** 的连接、训练、课程、游戏与实景模式。

### 4.1 模块结构

```
features/big_device/
├── bridge/                  # WebView ↔ 设备解耦桥接
│   └── realscene_bridge.dart
├── data/                    # 静态数据与 JSON 模型
│   ├── course_catalog.dart
│   ├── course_play_data.dart
│   ├── entry_card_data.dart
│   ├── exercise_song_library.dart
│   └── sport_metric_icons.dart
├── guards/                  # 准入守卫
│   └── quick_start_entry_guard.dart
├── mixins/                  # 设备控制方法签名 mixin
│   └── device_control_mixin.dart
├── models/                  # 设备控制/运动数据模型
│   ├── device_control_callbacks.dart
│   ├── device_control_data.dart
│   └── sport_data_model.dart
├── notifiers/               # Riverpod Notifier(业务逻辑)
├── pages/                   # 页面(Widget)
│   └── widgets/
├── repositories/            # 远程 JSON 仓库
├── states/                  # Freezed 状态
├── utils/                   # 字段可见性/单位转换
└── widgets/                 # 复用 UI 组件
```

### 4.2 设备类型

`FtmsDeviceType`([ftms_device_type.dart](file:///workspace/lib/core/ftms/ftms_device_type.dart)) 枚举定义 5 种大设备,数值与旧项目 `newMainSelectType` 一致:

| 枚举 | value | 中文 | 能力 |
|---|---|---|---|
| `indoorBike` | 0 | 动感单车 | 阻力 / 踏频 / 功率 |
| `treadmill` | 1 | 跑步机 | 速度 / 坡度 |
| `crossTrainer` | 2 | 椭圆机 | 阻力 / 坡度 / 踏频 / 功率 |
| `rower` | 3 | 划船机 | 阻力 / 桨频 / 桨数 / 功率(速度距离需单位转换) |
| `strengthStation` | 4 | 力量站(预留) | 复用单车解析器 |

### 4.3 入口与导航流

主页 `HomeTabScreen` 的设备入口卡片点击后跳转:

```
HomeTabScreen._deviceEntry(index)
  └─ context.push('/big-device-entry', extra: {'deviceCategoryIndex': index})
        └─ GymDeviceEntryScreen(deviceCategoryIndex)
```

big_device 内路由(见 [app_router.dart](file:///workspace/lib/core/routing/app_router.dart)):

| 路由 | 页面 | 作用 |
|---|---|---|
| `/big-device-entry` | `GymDeviceEntryScreen` | 大设备入口(5 卡片) |
| `/gym-course-list` | `CoursePageList` | 课程列表 |
| `/gym-course-detail` | `GymCourseDetailScreen` | 课程详情 |
| `/gym-device-play` | `GymDevicePlayScreen` | 课程训练播放 |
| `/gym-game-select` | `GymGameSelectScreen` | 游戏选择 |
| `/gym-quick-start` | `QuickStartTrainingPage` | 快速开始训练 |
| `/gym-bike-game[2]` | `GymBikeGame[2]Screen` | 单车游戏 1/2 |
| `/gym-bike-realscene` | `GymBikeRealsceneScreen` | 单车实景 |
| `/gym-treadmill-game[2]` | `GymTreadmillGame[2]Screen` | 跑步机游戏 1/2 |
| `/gym-treadmill-realscene` | `GymTreadmillRealsceneScreen` | 跑步机实景 |
| `/gym-elliptical-game[2]` | `GymEllipticalGame[2]Screen` | 椭圆机游戏 1/2 |
| `/gym-elliptical-realscene` | `GymEllipticalRealsceneScreen` | 椭圆机实景 |
| `/gym-rower-game[2]` | `GymRowerGame[2]Screen` | 划船机游戏 1/2 |
| `/gym-rower-realscene` | `GymRowerRealsceneScreen` | 划船机实景 |

> `gym-device-play` 与 `gym-course-detail` 在 `_testRoutes` 中,开发期可免登录进入。

### 4.4 页面作用一览

#### 1) GymDeviceEntryScreen — 大设备入口屏
文件:[gym_device_entry_screen.dart](file:///workspace/lib/features/big_device/pages/gym_device_entry_screen.dart)

- **作用**:大设备模块总入口,横屏沉浸式展示 5 张倾斜卡片(快速开始 / 课程训练 / 实景 / 城市冒险 / 娱乐健身)。
- **关键行为**:
  - `initState` 强制 `landscapeLeft` + `immersiveSticky`,首帧后 `bootstrap(deviceCategoryIndex)` 初始化卡片与设备类型。
  - AppBar 右侧"Device Connection"按钮(设备未连接时显示)→ 弹出 `DeviceSearchDialog` 扫描连接。
  - 卡片点击:未连接弹搜索框;已连接按索引进入对应子流程(快速开始 / 课程列表 / 游戏选择)。
  - `dispose` 恢复竖屏 + manual overlays;PopScope 拦截返回,先 `haltSport` 断开蓝牙再放行。
- **关联 Notifier**:`gymCourseHomeProvider`(卡片数据)、`gymDeviceConnectProvider`(连接状态)。

#### 2) DeviceSearchDialog — 设备搜索对话框
文件:[device_search_dialog.dart](file:///workspace/lib/features/big_device/pages/device_search_dialog.dart)

- **作用**:入口页内调起的蓝牙设备搜索弹窗,双态显示:
  - 搜索中且无设备 → 透明背景 + 居中 `CircularProgressIndicator`。
  - 发现设备 → `secondbackGround` 背景 + 标题"Device Selection" + 设备列表 `ListView`,点击列表项连接,长按删除。
- 监听 `gymDeviceConnectProvider` 的 `isSearching` / `foundDeviceNames`。

#### 3) DeviceSearchScreen — 主页 Tab 设备搜索页
文件:[device_search_screen.dart](file:///workspace/lib/features/big_device/pages/device_search_screen.dart)

- **作用**:嵌在主页"设备"Tab 内的设备搜索屏(竖屏),1:1 还原旧 `device_connect_screen._buildNewMainBody()`。
- 自带 40ms 间隔的搜索动画(0-47 帧循环),点击搜索按钮启动 `startDeviceScan`。

#### 4) CoursePageList — 课程列表页
文件:[course_page_list.dart](file:///workspace/lib/features/big_device/pages/course_page_list.dart)

- **作用**:按设备类型展示课程分类网格(3 列),横屏。对应旧 `big_device_sec_screen`。
- 数据源:远程 JSON(`courseTypeList*.json`,无需 Token)。
- 空数据态可点击重试;点击课程项进入 `/gym-course-detail`。
- **关联 Notifier**:`courseCatalogProvider`。

#### 5) GymCourseDetailScreen — 课程详情页
文件:[gym_course_detail_screen.dart](file:///workspace/lib/features/big_device/pages/gym_course_detail_screen.dart)

- **作用**:展示单课程详情(课程图 / 描述 / 建议 / 注意事项 / 动作列表 / 底部按钮),横屏。
- 含测试用模拟下载进度弹窗(`DownloadProgressDialog`),下载/解压后跳转 `/gym-device-play`。
- **关联 Notifier**:`gymCourseDetailProvider`(auto-dispose)。

#### 6) GymDevicePlayScreen — 大设备运动播放页
文件:[gym_device_play_screen.dart](file:///workspace/lib/features/big_device/pages/gym_device_play_screen.dart)

- **作用**:课程训练核心播放页,横屏,支持 4 种设备类型。
- **三态**:`loading` / `playing` / `finished`,所有尺寸基于屏幕宽高占比(不使用 ScreenUtil)。
- 顶部数据栏 + `TripleRingProgress` 三环 + `SportControlPanel` 控制面板 + `CourseProgressRail` 17 段进度条 + 结束页评分。
- **关联 Notifier**:`gymCoursePlayProvider`。

#### 7) GymGameSelectScreen — 游戏选择页
文件:[gym_game_select_screen.dart](file:///workspace/lib/features/big_device/pages/gym_game_select_screen.dart)

- **作用**:游戏与音乐选择页,横屏。左侧游戏卡片轮播 + 右侧运动数据/START-STOP。
- 返回按钮 → 停止运动 + 停止音乐 + 释放资源后 pop。
- **关联 Notifier**:`gymGameSelectProvider`(音乐/游戏路由)、`quickStartProvider`(运动数据,复用)。

#### 8) QuickStartTrainingPage — 快速开始训练页
文件:[quick_start_training_page.dart](file:///workspace/lib/features/big_device/pages/quick_start_training_page.dart)

- **作用**:跳过课程、直接开始训练的页面,横屏。
- 含椭圆跑道动画(`OvalTrackWidget`)、实时图表(`RealtimeChartWidget`)、目标达成弹窗(`GoalBannerAnimator`)、运动控制面板、运动数据展示、BGM。
- 进入时执行四级启动验证(`validateDeviceReady`),未就绪 Toast 提示。
- **关联 Notifier**:`quickStartProvider`。

#### 9) Gym*Game/Realscene 系列(12 个轻封装页)
文件:[gym_device_games.dart](file:///workspace/lib/features/big_device/pages/gym_device_games.dart)

- **作用**:4 设备 × 3(游戏1/游戏2/实景) = 12 个 `ConsumerWidget`,均为薄封装,委托给 `GameWebViewScaffold` 或 `RealsceneWebViewScaffold`。
- 例:`GymBikeGameScreen` → `GameWebViewScaffold(deviceType, gameIndex: 1)`。

#### 10) GameWebViewScaffold — 通用游戏 WebView 脚手架
文件:[game_webview_scaffold.dart](file:///workspace/lib/features/big_device/pages/game_webview_scaffold.dart)

- **作用**:8 个游戏页共用的 WebView 容器,按 `deviceType + gameIndex` 自动切换 URL(中英文域名)。
- 通过 `RealsceneBridge` 抽象与设备解耦,订阅 `sportDataStream` / `pauseEventStream`,500ms(划船机 1000ms)周期向 Web 注入运动数据 JSON。
- 处理 Web 下行指令(07 开始 / 08 停止 / 300 加载 / 010 Loading / gradient 坡度 / 000 重置)。

#### 11) RealsceneWebViewScaffold — 通用实景 WebView 脚手架
文件:[realscene_webview_scaffold.dart](file:///workspace/lib/features/big_device/pages/realscene_webview_scaffold.dart)

- **作用**:4 设备共用的实景模式 WebView 容器,按 `FtmsDeviceType` 切换 Unity WebGL 路径(`BicyclePlayerWebGL` / `RunnerPlayerWebGL` / `CanoeingPlayerWebGL` 等)。
- 与蓝牙完全解耦,仅依赖 `RealsceneBridge`;划船机上报时 speed/cadence 置 "0" 并追加 stroke 字段。

#### 12) DownloadProgressDialog — 下载进度弹窗
文件:[pages/widgets/download_progress_dialog.dart](file:///workspace/lib/features/big_device/pages/widgets/download_progress_dialog.dart)

- **作用**:课程详情页内的下载/解压进度弹窗组件。

### 4.5 Notifier(业务逻辑)一览

| Notifier | 文件 | 职责 |
|---|---|---|
| `GymCourseHomeNotifier` | [gym_course_home_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_course_home_notifier.dart) | 入口页 5 张卡片元数据(`EntryCardData.defaultCards`),按设备类型解析卡片背景图与标题。 |
| `GymDeviceConnectNotifier` | [gym_device_connect_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_device_connect_notifier.dart) | **设备连接核心**。实现双保险判定:Layer1(蓝牙链路)→ 初始化 FTMS 服务 → Layer2(收到首个数据包)→ `markEquipmentReady()`。负责扫描/连接/断开/状态持久化/`haltSport`。 |
| `CourseCatalogNotifier` | [course_catalog_notifier.dart](file:///workspace/lib/features/big_device/notifiers/course_catalog_notifier.dart) | 课程目录加载,按设备类型映射分类 index(单车=8/跑步机=9/椭圆机=10/划船机=11/力量站=12)。 |
| `GymCourseDetailNotifier` | [gym_course_detail_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_course_detail_notifier.dart) | 课程详情加载(auto-dispose),解析 `coursePlayData*.json`,方言匹配(恒 Chinese)。 |
| `GymCoursePlayNotifier` | [gym_course_play_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_course_play_notifier.dart) | 课程播放核心:三态(loading/playing/finished)、定时器驱动 playIndex/帧动画/运动数据累加、BGM/Voice 播放、设备控制按钮交互、FTMS 数据订阅。 |
| `GymGameSelectNotifier` | [gym_game_select_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_game_select_notifier.dart) | 游戏选择页:音乐播放控制、专辑封面轮播、按设备类型初始化游戏图片/路由列表。运动数据复用 `QuickStartNotifier`。 |
| `QuickStartNotifier` | [quick_start_notifier.dart](file:///workspace/lib/features/big_device/notifiers/quick_start_notifier.dart) | **快速开始核心**。接入 FTMS 数据监听(0x2AD1)/状态回调(0x2ADA)/控制指令(0x2AD9),目标达成弹窗三态管理(时间/距离/卡路里档位)。混入 `DeviceControlMixin`。 |

### 4.6 状态(State)一览

| State | 关键字段 |
|---|---|
| `GymDeviceConnectState` | `isSearching` / `isBluetoothConnected`(L1)/ `isEquipmentConnected`(L2)/ `foundDeviceNames` / `hasConnectedOnce` / `isConnecting` |
| `GymCourseHomeState` | `selectedDeviceCategory` / `entryCards` |
| `CourseCatalogState` | `catalog` / `selectedCategoryIndex` / `selectedCourseIndex` / `isLoading` / `isEmpty` |
| `GymCourseDetailState` | `courseTitle` / `courseProperties` / `courseImage` / `courseActionList` / `notFound` |
| `GymCoursePlayState` | `screenStatus`(枚举)/ `playIndex` / `imagePlayIndex` / `segments` / 顶部数据项 / 结束页数据 / 评分 |
| `GymGameSelectState` | `selectedMusicIndex` / `isMusicPlaying` / `albumImageIndex` / `gamePictureList` / `gameRouteList` / `gameWebViewReadyMap` |
| `QuickStartState` | `showPlayButton` / `isPaused` / `isPlaying` / `realSportTime` / `sportDistance` / `sportEnergy` / `sportSpeed` / `sportCadence` / `sportHeartRate` / `sportStrokeRate` / `sportStrokeCount` |
| `GoalBannerDisplayState` | 目标达成弹窗三态(时间/距离/卡路里) |

### 4.7 桥接(Bridge)

文件:[realscene_bridge.dart](file:///workspace/lib/features/big_device/bridge/realscene_bridge.dart)

- `RealsceneBridge` 抽象接口:定义 Web↔设备 上下行协议(开始/停止/坡度/数据流/暂停事件/dispose)。
- `MockRealsceneBridge`:无蓝牙阶段的默认实现,500ms 自增假数据驱动 Web 场景。
- `realsceneBridgeProvider` / `gameRealsceneBridgeProvider`:按设备类型提供 Bridge 实例,蓝牙接入阶段只需新增 `FtmsRealsceneBridge` 一个实现类即可替换 Mock,WebView 页面零修改。
- `RealsceneSportData`:500ms 周期上报给 WebView 的运动数据,按设备类型序列化为 Unity WebGL JSON(划船机追加 strokeRate/totalStrokes)。

### 4.8 数据(Data)与模型(Models)

| 文件 | 作用 |
|---|---|
| [entry_card_data.dart](file:///workspace/lib/features/big_device/data/entry_card_data.dart) | 入口 5 张卡片元数据(quickStart/courseTraining/realScene/cityAdventure/recreationalFitness)+ 设备→图片/标题映射。 |
| [course_catalog.dart](file:///workspace/lib/features/big_device/data/course_catalog.dart) | 课程目录 JSON 模型(`CourseCatalog` / `CourseCategory` / `CourseEntry`),对应 `courseTypeList*.json`。 |
| [course_play_data.dart](file:///workspace/lib/features/big_device/data/course_play_data.dart) | 单课程播放数据模型(`CourseItem` / `BarLineData` / `TitleProperties` 等),对应 `coursePlayData*.json`。 |
| [exercise_song_library.dart](file:///workspace/lib/features/big_device/data/exercise_song_library.dart) | 各设备运动歌曲 URL 列表(`forType(type)`)。 |
| [sport_metric_icons.dart](file:///workspace/lib/features/big_device/data/sport_metric_icons.dart) | 运动指标图标映射。 |
| [sport_data_model.dart](file:///workspace/lib/features/big_device/models/sport_data_model.dart) | 运动数据统一模型(speed/cadence/distance/energy/heartRate/power/resistanceLevel/inclination/strokeRate/strokeCount/elapsed/remaining)。 |
| [device_control_callbacks.dart](file:///workspace/lib/features/big_device/models/device_control_callbacks.dart) | 设备控制回调(速度/坡度/阻力的加减/长按/预设)。 |
| [device_control_data.dart](file:///workspace/lib/features/big_device/models/device_control_data.dart) | 控制按钮数据(当前档位/范围)。 |

### 4.9 Repository

| Repository | 作用 |
|---|---|
| [course_catalog_repository.dart](file:///workspace/lib/features/big_device/repositories/course_catalog_repository.dart) | 复用 `dioClientProvider` GET 公开课程目录 JSON,按设备类型切换 URL(跑步机葡语特殊处理)。 |
| [course_detail_repository.dart](file:///workspace/lib/features/big_device/repositories/course_detail_repository.dart) | 获取课程播放数据 JSON。 |

### 4.10 守卫 / Mixin / Utils

| 文件 | 作用 |
|---|---|
| [quick_start_entry_guard.dart](file:///workspace/lib/features/big_device/guards/quick_start_entry_guard.dart) | 快速开始准入 5 项校验(C1 设备已连接 L2 → C2 蓝牙权限 → C3 适配器开启 → C4 登录 → C5 设备类型),任一失败返回错误文案。 |
| [device_control_mixin.dart](file:///workspace/lib/features/big_device/mixins/device_control_mixin.dart) | 速度/坡度/阻力三大维度控制方法签名,供 `QuickStartNotifier` 与 `GymCoursePlayNotifier` 混入,保证控制接口一致。 |
| [device_field_visibility.dart](file:///workspace/lib/features/big_device/utils/device_field_visibility.dart) | 按设备类型判定字段可见性(踏频/阻力/坡度/桨频/桨数/功率),并提供划船机 m/s→km/h、m→km 单位转换。 |

### 4.11 复用 Widgets

| Widget | 作用 |
|---|---|
| [sport_data_display.dart](file:///workspace/lib/features/big_device/widgets/sport_data_display.dart) | 运动数据展示,按 `DeviceFieldVisibility` 决定字段,"图标+数值+单位"形式,支持 horizontal/compact 布局。 |
| [sport_control_panel.dart](file:///workspace/lib/features/big_device/widgets/sport_control_panel.dart) | 运动控制面板,按设备类型组合按钮组(单车=阻力;跑步机=坡度+速度;椭圆机=阻力+坡度;划船机=阻力),支持 full/compact 风格。 |
| [level_control_button.dart](file:///workspace/lib/features/big_device/widgets/level_control_button.dart) | 5 档控制按钮(快速开始页 full 风格)。 |
| [pill_control_button.dart](file:///workspace/lib/features/big_device/widgets/pill_control_button.dart) | 药丸形加减按钮(课程播放页 compact 风格)。 |
| [simple_control_button.dart](file:///workspace/lib/features/big_device/widgets/simple_control_button.dart) | 简单控制按钮。 |
| [triple_ring_progress.dart](file:///workspace/lib/features/big_device/widgets/triple_ring_progress.dart) | 结束页三环进度(外圈时间-橙/中圈距离-蓝/内圈卡路里-红)。 |
| [course_progress_rail.dart](file:///workspace/lib/features/big_device/widgets/course_progress_rail.dart) | 课程播放页 17 段固定进度条 + 自绘倒三角箭头定位。 |
| [goal_banner_animator.dart](file:///workspace/lib/features/big_device/widgets/goal_banner_animator.dart) | 目标达成弹窗动画(5 秒自动关闭)。 |

### 4.12 关键流程图

#### 设备连接(双保险)
```
用户点击"Device Connection"
  └─ GymDeviceConnectNotifier.startDeviceScan()
       ├─ BluetoothPermission.ensureInformedAndRequest()  # 权限弹窗
       ├─ BluetoothPermission.isAdapterOn()                # 适配器检查
       └─ BluetoothConnectionService.startScan(whitelist)  # 6s 兜底
            └─ 发现设备 → foundDeviceNames 更新 → DeviceSearchDialog 列表
用户点击设备项
  └─ connectSelectedDevice(name)
       ├─ 持久化设备名到 Storage(按设备类型)
       └─ BluetoothConnectionService.connect(name)
            └─ BluetoothConnectionEvent.bluetoothConnected  # Layer 1
                 └─ _initializeFtmsService()
                      ├─ ref.invalidate(ftmsServiceProvider)  # 强制销毁旧实例
                      ├─ ftmsService = ref.read(ftmsServiceProvider(type))
                      ├─ ftmsService.onDataReady = markEquipmentReady
                      └─ 收到首个 0x2ADA 数据包
                           └─ markEquipmentReady()  # Layer 2 ✅ 设备完全就绪
```

#### 入口卡片分流
```
GymDeviceEntryScreen(5 卡片)
  ├─ index 0 quickStart      → /gym-quick-start (QuickStartTrainingPage)
  ├─ index 1 courseTraining  → /gym-course-list → /gym-course-detail → /gym-device-play
  ├─ index 2 realScene       → /gym-game-select → /gym-{device}-realscene
  ├─ index 3 cityAdventure   → /gym-game-select → /gym-{device}-game[2]
  └─ index 4 recreationalFitness → /gym-game-select → /gym-{device}-game[2]
```

#### 课程训练
```
CoursePageList(JSON 列表)
  └─ 选中课程 → /gym-course-detail (GymCourseDetailScreen)
       └─ 加载 coursePlayData*.json → 解析动作序列
       └─ 下载/解压(DownloadProgressDialog)
       └─ /gym-device-play (GymDevicePlayScreen)
            └─ GymCoursePlayNotifier: 三态 loading→playing→finished
                 ├─ 订阅 FTMS dataStream/statusStream
                 ├─ SportTimer + DeviceTimeNormalizer 计时
                 ├─ BGM + Voice 音频(带 _audioTerminated 守卫)
                 └─ 结束页:三环 + 评分 + 数据项
```

#### 游戏/实景 WebView
```
GymGameSelectScreen 选择游戏
  └─ /gym-{device}-game[2] 或 /gym-{device}-realscene
       └─ GameWebViewScaffold / RealsceneWebViewScaffold
            ├─ bootstrap: 横屏 + 沉浸式 + Bridge 实例
            ├─ 订阅 bridge.sportDataStream → 500ms 注入 JS
            ├─ Web 下行指令(07/08/300/010/gradient/000)→ Bridge → FTMS
            └─ dispose: loadUrl('about:blank') + 取消订阅
```

---

## 五、依赖关系

### 5.1 big_device 对 core 的依赖

| 依赖项 | 用途 |
|---|---|
| `core/ftms/ftms_device_type.dart` | 设备类型枚举与能力判定 |
| `core/ftms/ftms_service_base.dart` / `ftms_service_provider.dart` | FTMS 服务实例(数据/状态/控制流) |
| `core/ftms/ftms_command_dispatcher.dart` / `ftms_param_sync_engine.dart` | 指令调度与参数同步 |
| `core/ftms/sport_timer.dart` / `device_time_normalizer.dart` | 运动计时与设备时间归一化 |
| `core/services/bluetooth_connection_service.dart` | 共享蓝牙连接 |
| `core/services/storage_service.dart` | 设备名/语言/国家持久化 |
| `core/bluetooth/bluetooth_permission.dart` | 权限与适配器检查 |
| `core/devices/device_whitelist.dart` | 设备白名单过滤 |
| `core/network/network_providers.dart` | `dioClientProvider`(Repository 用) |
| `core/constants/them_change.dart` / `app_fonts.dart` | 主题色与字体 |
| `core/widgets/oval_track_widget.dart` / `realtime_chart_widget.dart` | 快速开始页跑道与图表 |

### 5.2 big_device 对其他 feature 的依赖

| 依赖项 | 用途 |
|---|---|
| `features/auth/notifiers/auth_notifier.dart` | 用户信息(WebView 注入 userId) |
| `features/course_download/` | 课程资源下载/解压/本地清单 |
| `data/models/user_info.dart` | 用户数据模型 |

### 5.3 核心第三方包(见 [pubspec.yaml](file:///workspace/pubspec.yaml))

| 包 | 版本 | 用途 |
|---|---|---|
| `flutter_riverpod` / `riverpod_annotation` | ^3.4.1 / ^4.0.5 | 状态管理 + 代码生成 |
| `go_router` | ^17.3.0 | 声明式路由 |
| `dio` | ^5.11.0 | 网络请求 |
| `flutter_blue_plus` | ^2.3.11 | 蓝牙 BLE + FTMS |
| `flutter_inappwebview` | ^6.1.0 | 游戏/实景 WebView |
| `just_audio` | ^0.9.39 | BGM/Voice 播放 |
| `fl_chart` | ^0.69.0 | 实时图表 |
| `freezed_annotation` / `json_annotation` | ^3.1.0 / ^4.12.0 | 不可变模型 |
| `flutter_screenutil` | ^5.9.3 | 屏幕适配(竖屏模块) |
| `shared_preferences` | ^2.5.5 | 本地存储 |
| `video_player` | ^2.13.0 | 登录页背景视频 |
| `archive` | ^3.4.1 | 课程包 ZIP 解压 |
| `path_provider` | ^2.1.5 | 本地路径 |
| `wakelock_plus` | ^1.7.0 | 运动时保持唤醒 |
| `permission_handler` / `connectivity_plus` | ^12.0.3 / ^7.3.1 | 权限与网络检测 |

### 5.4 关键 Provider 依赖链

```
bluetoothConnectionServiceProvider (单例)
  └─ ftmsServiceProvider(deviceType) (按设备类型族)
       └─ GymDeviceConnectNotifier (读取 ftmsService, 双保险判定)
            └─ QuickStartNotifier / GymCoursePlayNotifier (订阅 dataStream/statusStream)
                   └─ GameWebViewScaffold / RealsceneWebViewScaffold (通过 Bridge 间接消费)
```

---

## 六、项目运行方式

### 6.1 环境准备

- Flutter SDK `3.44.8`(项目通过 `.fvmrc` 锁定,推荐使用 [FVM](https://fvm.app)):
  ```bash
  fvm install 3.44.8
  fvm use 3.44.8
  ```
- iOS:Xcode + CocoaPods(`ios/Podfile`);Android:Android Studio / Gradle(`android/`)。

### 6.2 安装依赖

```bash
fvm flutter pub get
```

### 6.3 代码生成(重要)

项目大量使用 riverpod_generator / freezed / json_serializable,**修改注解后必须重新生成**:

```bash
fvm dart run build_runner build --delete-conflicting-outputs
# 或监听模式
fvm dart run build_runner watch --delete-conflicting-outputs
```

生成的文件:`*.g.dart`(riverpod/json)、`*.freezed.dart`(freezed)。**请勿手改生成文件**。

### 6.4 运行

```bash
fvm flutter run                    # 默认设备
fvm flutter run -d <deviceId>      # 指定设备
fvm flutter run --release          # Release 模式
```

iOS 首次需安装 Pods:
```bash
cd ios && pod install && cd ..
```

### 6.5 国际化

- 配置见 [l10n.yaml](file:///workspace/l10n.yaml),arb 文件:`lib/l10n/app_zh.arb` / `app_en.arb`。
- `flutter gen-l10n` 由 `pubspec.yaml` 的 `generate: true` 自动触发。
- 运行时由 [app.dart](file:///workspace/lib/app.dart) 的 `localeListResolutionCallback` 决定 zh/en。

### 6.6 资源

- 图片:`images/`(含 `newUIScreen/`、`sportSettingPIC/`、`bigScreenAnimation/` 等)
- 字体:`fonts/`(BEBAS、HarmonyOS Sans SC Medium/Regular)
- 视频:`assets/lidong.mp4`(登录页背景)
- 资源清单在 [pubspec.yaml](file:///workspace/pubspec.yaml) 的 `flutter.assets` 声明。

### 6.7 测试与调试

- 测试框架:`mocktail` ^1.0.4(dev_dependencies)。
- 开发期 API 测试页:`/api-test`([api_test_page.dart](file:///workspace/lib/features/dev/api_test_page.dart),**上架前注释**)。
- big_device 调试:`/gym-device-play`、`/gym-course-detail` 在 `_testRoutes` 中,可免登录进入。
- `GymDeviceConnectNotifier.markConnectedForTest()` 可直接标记设备就绪,跳过双保险判定。

### 6.8 上架注意

- `/api-test` 路由与 `dev/api_test_page.dart` 在上架前需注释(已在 [app_router.dart](file:///workspace/lib/core/routing/app_router.dart) 标注 `【上架隐藏】`)。
- iOS 证书信息见 `android/android-certificate-info.md` 与 `ios/Runner.xcodeproj`。

---

## 七、附:关键类速查表

| 类 / 文件 | 路径 | 一句话说明 |
|---|---|---|
| `VividFitApp` | [app.dart](file:///workspace/lib/app.dart) | 应用根 Widget,MaterialApp.router + 主题 + i18n |
| `appRouter` | [app_router.dart](file:///workspace/lib/core/routing/app_router.dart) | go_router 全局配置 + 登录 redirect |
| `FtmsDeviceType` | [ftms_device_type.dart](file:///workspace/lib/core/ftms/ftms_device_type.dart) | 5 种大设备枚举 + 能力扩展 |
| `FtmsServiceBase` | [ftms_service_base.dart](file:///workspace/lib/core/ftms/ftms_service_base.dart) | FTMS 服务抽象(数据/状态/控制流) |
| `ftmsServiceProvider` | [ftms_service_provider.dart](file:///workspace/lib/core/ftms/ftms_service_provider.dart) | 按设备类型创建 FTMS 服务 |
| `BluetoothConnectionService` | [bluetooth_connection_service.dart](file:///workspace/lib/core/services/bluetooth_connection_service.dart) | 共享蓝牙连接(扫描/连接/断开) |
| `StorageService` | [storage_service.dart](file:///workspace/lib/core/services/storage_service.dart) | SharedPreferences 封装 |
| `ApiConstants` | [api_constants.dart](file:///workspace/lib/core/constants/api_constants.dart) | API 端点与请求头常量 |
| `GymDeviceEntryScreen` | [gym_device_entry_screen.dart](file:///workspace/lib/features/big_device/pages/gym_device_entry_screen.dart) | 大设备入口屏(5 卡片) |
| `GymDeviceConnectNotifier` | [gym_device_connect_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_device_connect_notifier.dart) | 设备连接核心(双保险 L1/L2) |
| `RealsceneBridge` | [realscene_bridge.dart](file:///workspace/lib/features/big_device/bridge/realscene_bridge.dart) | WebView↔设备解耦桥接抽象 |
| `QuickStartNotifier` | [quick_start_notifier.dart](file:///workspace/lib/features/big_device/notifiers/quick_start_notifier.dart) | 快速开始核心(FTMS 监听+控制+目标弹窗) |
| `GymCoursePlayNotifier` | [gym_course_play_notifier.dart](file:///workspace/lib/features/big_device/notifiers/gym_course_play_notifier.dart) | 课程播放核心(三态+音频+FTMS) |
| `DeviceFieldVisibility` | [device_field_visibility.dart](file:///workspace/lib/features/big_device/utils/device_field_visibility.dart) | 设备字段可见性与单位转换 |
| `EntryCardData` | [entry_card_data.dart](file:///workspace/lib/features/big_device/data/entry_card_data.dart) | 入口卡片元数据与设备→图片映射 |
| `QuickStartEntryGuard` | [quick_start_entry_guard.dart](file:///workspace/lib/features/big_device/guards/quick_start_entry_guard.dart) | 快速开始 5 项准入校验 |

---

> 本 Wiki 基于当前代码快照生成。若模块新增页面或 Notifier,请同步更新本文档的"页面作用一览"与"Notifier 一览"。
