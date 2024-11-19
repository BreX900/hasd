import 'package:json_annotation/json_annotation.dart';
import 'package:mek_data_class/mek_data_class.dart';
import 'package:mekart/mekart.dart';

part '../generated/dto/youtrack_config_dto.g.dart';

extension YoutrackConfigBin on BinSession {
  BinStore<YoutrackConfigDto?> get youtrackConfig => BinStore(
        session: this,
        name: 'youtrack_config.json',
        codec: const JsonCodecWithIndent('  '),
        deserializer: (data) => YoutrackConfigDto.fromJson(data as Map<String, dynamic>),
        fallbackData: null,
      );
}

@DataClass(changeable: true)
@JsonSerializable(createFactory: true, createToJson: true)
class YoutrackConfigDto with _$YoutrackConfigDto {
  final String baseUrl;
  final String apiToken;
  final String ticketId;

  const YoutrackConfigDto({
    required this.baseUrl,
    required this.apiToken,
    required this.ticketId,
  });

  factory YoutrackConfigDto.fromJson(Map<String, dynamic> map) => _$YoutrackConfigDtoFromJson(map);
  Map<String, dynamic> toJson() => _$YoutrackConfigDtoToJson(this);
}
