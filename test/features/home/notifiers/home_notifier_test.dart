import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vividfit_v2/core/services/api_service.dart';
import 'package:vividfit_v2/core/services/home_repository_provider.dart';
import 'package:vividfit_v2/core/services/storage_service.dart';
import 'package:vividfit_v2/core/services/storage_service_provider.dart';
import 'package:vividfit_v2/data/models/new_main_data.dart';
import 'package:vividfit_v2/data/models/statistics_data.dart';
import 'package:vividfit_v2/features/home/notifiers/home_notifier.dart';
import 'package:vividfit_v2/features/home/repositories/home_repository.dart';

class _MockHomeRepository extends Mock implements HomeRepository {}

HomeNotifier _createNotifier(_MockHomeRepository repo, StorageService storage) {
  final container = ProviderContainer(
    overrides: [
      homeRepositoryProvider.overrideWithValue(repo),
      storageServiceProvider.overrideWithValue(storage),
    ],
  );
  addTearDown(container.dispose);
  return container.read(homeNotifierProvider.notifier);
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late _MockHomeRepository repo;
  late StorageService storage;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    storage = await StorageService.create();
    repo = _MockHomeRepository();
    registerFallbackValue(const FitMainData());
    registerFallbackValue(const FitStatsData());
    when(() => repo.integrateStatistics(any(), any()))
        .thenAnswer((inv) => inv.positionalArguments[1] as FitMainData);
  });

  group('HomeNotifier', () {
    test('初始状态:currentIndex=0,isLoading=false', () {
      when(() => repo.getSportStatistics())
          .thenAnswer((_) async => const FitStatsData(code: '200'));
      when(() => repo.getStatisticsCalendar())
          .thenAnswer((_) async => false);
      final notifier = _createNotifier(repo, storage);
      expect(notifier.state.currentIndex, 0);
    });

    test('changePage 切换 tab', () {
      when(() => repo.getSportStatistics())
          .thenAnswer((_) async => const FitStatsData(code: '200'));
      when(() => repo.getStatisticsCalendar())
          .thenAnswer((_) async => false);
      final notifier = _createNotifier(repo, storage);
      notifier.changePage(2);
      expect(notifier.state.currentIndex, 2);
    });

    test('bmiIndex 返回正确档位', () {
      when(() => repo.getSportStatistics())
          .thenAnswer((_) async => const FitStatsData(code: '200'));
      when(() => repo.getStatisticsCalendar())
          .thenAnswer((_) async => false);
      final notifier = _createNotifier(repo, storage);
      expect(notifier.bmiIndex(), 1);
    });

    test('mainDataShow 时长格式化', () {
      when(() => repo.getSportStatistics())
          .thenAnswer((_) async => const FitStatsData(code: '200'));
      when(() => repo.getStatisticsCalendar())
          .thenAnswer((_) async => false);
      final notifier = _createNotifier(repo, storage);
      expect(notifier.mainDataShow(0), '00:00:00');
    });

    test('integrateStatistics 累加卡路里/时长/次数', () {
      final realRepo = HomeRepository(ApiService(storage), storage);
      final base = const FitMainData(bodyWeight: 70);
      final stats = const FitStatsData(
        code: '200',
        data: [
          StatisticsItem(calorie: 100, duringTime: 600, sportCount: 2),
          StatisticsItem(calorie: 50, duringTime: 300, sportCount: 1),
        ],
      );
      final result = realRepo.integrateStatistics(stats, base);
      expect(result.triCycleCalorie, 150);
      expect(result.triCycleDuration, 900);
      expect(result.todayCount, 3);
      expect(result.triCycleStrength, greaterThan(0));
    });
  });
}
