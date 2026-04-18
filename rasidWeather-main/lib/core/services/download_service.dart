import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  factory DownloadService() => _instance;
  DownloadService._internal();
  static final DownloadService _instance = DownloadService._internal();

  final Dio _dio = Dio();

  Future<String?> downloadFile({
    required String url,
    required String fileName,
    Map<String, dynamic>? headers,
    Map<String, dynamic>? queryParameters,
    ProgressCallback? onProgress,
  }) async {
    try {
      // Request storage permission
      if (!kIsWeb) {
        final PermissionStatus status = await Permission.storage.request();
        if (!status.isGranted) {
          throw Exception('Storage permission not granted');
        }
      }

      // Get the downloads directory
      final String? dir = await _getDownloadPath();
      if (dir == null) {
        throw Exception('Could not access downloads directory');
      }

      final String savePath = '$dir/$fileName';

      // Download the file
      final Response<dynamic> response = await _dio.download(
        url,
        savePath,
        options: Options(
          headers: headers,
          responseType: ResponseType.bytes,
          followRedirects: true,
          validateStatus: (int? status) => status != null && status < 500,
        ),
        queryParameters: queryParameters,
        onReceiveProgress: onProgress,
      );

      if (response.statusCode == 200) {
        print('File downloaded successfully to: $savePath');
        return savePath;
      } else {
        throw Exception('Failed to download file: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> _getDownloadPath() async {
    if (kIsWeb) {
      return null;
    }
    
    if (Platform.isAndroid) {
      final Directory? directory = await getExternalStorageDirectory();
      return directory?.path;
    } else if (Platform.isIOS) {
      final Directory directory = await getApplicationDocumentsDirectory();
      return directory.path;
    } else if (Platform.isMacOS) {
      final Directory? directory = await getDownloadsDirectory();
      return directory?.path;
    }
    
    return null;
  }
}
