import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/strings.dart';
import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class ArticlesRepo {
  ArticlesRepo({required this.sharedPreferences, required this.dioClient});

  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  Future<ApiResponse> getArticles(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.articlesUrl + params);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getArticleHome(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.articlesHomeUrl + params);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getArticleDetails(String id) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.articleDetailsUrl + id);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getCategories() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.categoriesUrl);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> bookmarkArticle(String articleId, bool favorite) async {
    try {
      final Response<dynamic> response =
          await dioClient.post(AppStrings.bookmarkArticleUrl, data: <String, String>{'article_id': articleId, 'favorite': '$favorite'});
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> lovedArticle(String articleId, bool like) async {
    try {
      final Response<dynamic> response =
          await dioClient.post(AppStrings.lovedArticleUrl, data: <String, String>{'article_id': articleId, 'like': '$like'});
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> searchArticle(String query) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.searchArticleUrl + query);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> getBookmarks(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.getBookmarksUrl + params);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> addComment(String articleId, String comment) async {
    try {
      final Response<dynamic> response =
          await dioClient.post(AppStrings.commentUrl, data: <String, String>{'article_id': articleId, 'content': comment});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> getComments(String articleId) async {
    try {
      final Response<dynamic> response = await dioClient.get('${AppStrings.commentUrl}?article_id=$articleId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> deleteComment(String commentId) async {
    try {
      final Response<dynamic> response = await dioClient.delete('${AppStrings.commentUrl}/$commentId');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }

  Future<ApiResponse> updateComment(String commentId, String comment) async {
    try {
      final Response<dynamic> response = await dioClient.put('${AppStrings.commentUrl}/$commentId', data: <String, String>{'content': comment});
      return ApiResponse.withSuccess(response);
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }
}
