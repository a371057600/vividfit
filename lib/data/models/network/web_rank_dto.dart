import 'package:freezed_annotation/freezed_annotation.dart';

part 'web_rank_dto.freezed.dart';
part 'web_rank_dto.g.dart';

@freezed
abstract class WebRankDto with _$WebRankDto {
  const factory WebRankDto({
    Map<String, dynamic>? userRank,
    List<dynamic>? webRank,
  }) = _WebRankDto;

  factory WebRankDto.fromJson(Map<String, dynamic> json) =>
      _$WebRankDtoFromJson(json);
}
