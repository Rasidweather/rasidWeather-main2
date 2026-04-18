import '../network/dio_helper.dart';

abstract class BaseDataSource {

  BaseDataSource(this.dio);
  final DioClient dio;

  Future<T> handleResponse<T>(Future<T> Function() request) async {
    try {
      return await request();
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
