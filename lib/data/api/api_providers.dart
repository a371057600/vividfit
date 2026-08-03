import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/network/network_providers.dart';
import 'public_api.dart';
import 'sport_history_api.dart';
import 'sport_statistics_api.dart';
import 'user_api.dart';
import 'web_api.dart';

part 'api_providers.g.dart';

@Riverpod(keepAlive: true)
PublicApi publicApi(Ref ref) {
  return PublicApi(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
UserApi userApi(Ref ref) {
  return UserApi(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
SportHistoryApi sportHistoryApi(Ref ref) {
  return SportHistoryApi(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
SportStatisticsApi sportStatisticsApi(Ref ref) {
  return SportStatisticsApi(ref.watch(apiClientProvider));
}

@Riverpod(keepAlive: true)
WebApi webApi(Ref ref) {
  return WebApi(ref.watch(apiClientProvider));
}