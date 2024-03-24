// import 'package:dio/dio.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hasd/common/env.dart';
// import 'package:hasd/you_track/you_track_api.dart';
// import 'package:hasd/you_track/you_track_http_client.dart';
//
// class YouTrackFields {
//   static const String project = 'id,name'; // ,customFields(name,\$type,value(name,login))
//   static const String issue = 'id,summary,customFields';
//   static const String time = 'id,author(fullName),date,duration(minutes)';
//   static const String timeType = r'id,name,$type';
// }
//
// abstract class YouTrackProviders {
//   static final client = YouTrackApi(
//     client: DioApiClient(Dio(BaseOptions(
//       baseUrl: 'https://k1.youtrack.cloud/api',
//       headers: {'Authorization': 'Bearer ${Env.youTrackToken}'},
//     ))
//       ..interceptors.add(LogInterceptor(
//         request: false,
//         responseBody: true,
//         responseHeader: false,
//       ))),
//   );
//
//   // final _workSpacesBin = Bin(name: 'work_spaces', deserializer: (data) => (data as List).cast<String>(),);
//   //
//   // static final workSpaces = FutureProvider((ref) async {
//   //   final box = await Hive.openBox<String>('work_spaces');
//   //   return Map.fromIterables(box.keys, box.values);
//   // });
//
//   static final invalidator = Provider((ref) => DateTime.now());
//
//   static final projects = FutureProvider((ref) async {
//     ref.watch(invalidator);
//
//     await client.getAdminCustomFieldSettingsBundlesEnum(
//       query: const GetAdminCustomFieldSettingsBundlesEnumQueryYt(
//         fields: r'id,$type,values(id,name,localizedName)',
//       ),
//     );
//
//     return await client.getAdminProjects(
//       query: const GetAdminProjectsQueryYt(
//         fields: YouTrackFields.project,
//       ),
//     );
//   });
//   // instances: [
//   //   {project: {
//   //     name: Scraper Windows Client, id: 0-8, $type: Project},
//   //   id: 120-48,
//   //   $type: StateProjectCustomField}
//   //  localizedName: Stato, fieldType: {id: state[1], $type: FieldType}, name: State, id: 96-2, $type: CustomField}
//   static final fields = FutureProvider.family((ref, String projectId) async {
//     final fields = await client.getAdminCustomFieldSettingsCustomFields(
//       query: const GetAdminCustomFieldSettingsCustomFieldsQueryYt(
//         fields: r'id,name,localizedName,fieldType(id,$type),instances(id,project(id,name)),$type',
//       ),
//     );
//     // client.getAdminCustomFieldSettingsBundlesStateIdValues(id)
//
//     return fields.where((element) {
//       return element.instances!.any((element) => element.project!.id == projectId);
//     }).toList();
//   });
//
//   static final issues = FutureProvider.family((ref, String projectName) async {
//     ref.watch(invalidator);
//
//     return await client.getIssues(
//       query: GetIssuesQueryYt(
//         query: '#{$projectName} state: {Unresolved}',
//         fields: YouTrackFields.issue,
//       ),
//     );
//   });
//
//   // StateIssueCustomField
//   static final issueTypes = FutureProvider.family((ref, String projectId) async {
//     return await client.getAdminProjectsIdCustomFields(
//       projectId,
//       query: const GetAdminProjectsIdCustomFieldsQueryYt(
//         fields:
//             r'$type,bundle($type,id),canBeEmpty,defaultValues($type,id,name),emptyFieldText,field($type,fieldType($type,id),id,localizedName,name),id,isPublic,ordinal',
//       ),
//     );
//   });
//
//   static final times = FutureProvider.family((ref, String issueId) async {
//     ref.watch(invalidator);
//
//     return await client.getIssuesIdTimeTrackingWorkItems(
//       issueId,
//       query: const GetIssuesIdTimeTrackingWorkItemsQueryYt(
//         fields: YouTrackFields.time,
//       ),
//     );
//   });
//
//   static final timeTypes = FutureProvider((ref) async {
//     return await client.getAdminTimeTrackingSettingsWorkItemTypes(
//       query: const GetAdminTimeTrackingSettingsWorkItemTypesQueryYt(
//         fields: YouTrackFields.timeType,
//       ),
//     );
//   });
// }
