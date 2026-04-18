// import 'package:dio/dio.dart';
//
// import '../../../../core/constants/app_strings.dart';
// import '../../../../core/data_sources/base_data_source.dart';
// import '../../../../data/model/base/api_response.dart';
//
// class ProjectsDataSource extends BaseDataSource {
//   ProjectsDataSource(super.dio);
//
//   Future<ApiResponse> getProjects(Map<String, dynamic> params) async {
//     return handleResponse(() async {
//       final Response<dynamic> response = await dio.get(
//         AppStrings.getProjectsEndpoint,
//         queryParameters: params,
//       );
//       return ApiResponse.withSuccess(response);
//     });
//   }
//
//   Future<ApiResponse> createProject(Map<String, dynamic> data) async {
//     return handleResponse(() async {
//       final Response response = await dio.post(AppStrings.addProjectsEndpoint, data: data);
//       return ApiResponse.withSuccess(response);
//     });
//   }
//
//   Future<ApiResponse> updateProject(String id, Map<String, dynamic> data) async {
//     return handleResponse(() async {
//       final Response response = await dio.put(AppStrings.updateProjectEndpoint(id), data: data);
//       return ApiResponse.withSuccess(response);
//     });
//   }
//
//   Future<ApiResponse> deleteProject(String id) async {
//     return handleResponse(() async {
//       final Response response = await dio.delete(AppStrings.deleteProjectEndpoint(id));
//       return ApiResponse.withSuccess(response);
//     });
//   }
// }
