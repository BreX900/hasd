// import 'package:fast_immutable_collections/fast_immutable_collections.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:mek_data_class/mek_data_class.dart';
// import 'package:mekart/mekart.dart';
//
// part '../generated/dto/config_dto.g.dart';
//
// extension YoutrackConfigBin on BinSession {
//   BinStore<ConfigDto> get config => BinStore(
//         session: this,
//         name: 'config.json',
//         codec: const JsonCodecWithIndent('  '),
//         deserializer: (data) => ConfigDto.fromJson(data as Map<String, dynamic>),
//         fallbackData: ConfigDto(),
//       );
// }
//
// @DataClass(changeable: true)
// @JsonSerializable(createFactory: true, createToJson: true)
// class ConfigDto with _$ConfigDto {
//   final IMap<String, String> youtrackIssueByProject;
//
//   const ConfigDto({this.youtrackIssueByProject = const IMap.empty()});
//
//   factory ConfigDto.fromJson(Map<String, dynamic> map) => _$ConfigDtoFromJson(map);
//   Map<String, dynamic> toJson() => _$ConfigDtoToJson(this);
// }
