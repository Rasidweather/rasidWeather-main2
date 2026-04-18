import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:crypto/crypto.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';


class LottieCacheManager {
  factory LottieCacheManager() => _instance;
  LottieCacheManager._internal() {
    // Initialize automatic cleanup
    _setupAutomaticCleanup();
  }
  static final LottieCacheManager _instance = LottieCacheManager._internal();

  static const String _cacheDirectoryName = 'lottie_cache';

  // Use expiring cache entries as a simple way to automatically clear old entries
  final Map<String, ExpirableCacheEntry> _memoryCache = <String, ExpirableCacheEntry>{};

  // Maximum memory cache size
  static const int _maxCacheEntries = 30; // Reduced from 50 to conserve memory

  // Queue to track LRU items
  final Queue<String> _cacheQueue = Queue<String>();

  // Cache that tracks which files are currently being downloaded to prevent duplicated downloads
  final Map<String, Completer<String>> _downloadCompleters = <String, Completer<String>>{};

  // Timer for periodic cleanup
  Timer? _cleanupTimer;

  // Track if the manager has been disposed
  bool _isDisposed = false;

  /// Initializes the automatic cleanup timer for cache management
  void _setupAutomaticCleanup() {
    // Avoid setting up cleanup if already disposed
    if (_isDisposed) return;

    // Cancel any existing timer
    _cleanupTimer?.cancel();

    // Setup timer to run every 5 minutes
    _cleanupTimer = Timer.periodic(const Duration(minutes: 5), (_) {
      if (!_isDisposed) {
        _cleanMemoryCache();
        _cleanDiskCache();
      }
    });
  }

  /// Cleans up the memory cache by removing least recently used items
  void _cleanMemoryCache() {
    // Remove any expired entries
    _memoryCache.removeWhere((_, ExpirableCacheEntry entry) => entry.isExpired);

    // If still over the limit, remove oldest entries
    while (_cacheQueue.length > _maxCacheEntries) {
      final String oldestUrl = _cacheQueue.removeFirst();
      _memoryCache.remove(oldestUrl);
    }

    // Suggest garbage collection
    PlatformDispatcher.instance.scheduleFrame();
  }

  /// Cleans up the disk cache by removing files over a certain age
  Future<void> _cleanDiskCache() async {
    try {
      final Directory cacheDir = await _getCacheDirectory();
      final List<FileSystemEntity> files = await cacheDir.list().toList();

      // Don't delete too many files at once to avoid UI jank
      int filesDeleted = 0;

      for (final FileSystemEntity file in files) {
        if (file is File) {
          try {
            final FileStat stat = await file.stat();
            final Duration age = DateTime.now().difference(stat.modified);

            // Delete files older than 7 days
            if (age.inDays > 7) {
              await file.delete();
              filesDeleted++;

              // Only delete up to 10 files per cleanup cycle
              if (filesDeleted >= 10) break;
            }
          } catch (e) {
            debugPrint('Error cleaning cache file: $e');
          }
        }
      }
    } catch (e) {
      debugPrint('Error cleaning disk cache: $e');
    }
  }

  /// Returns the cached file path, or downloads the file if it's not cached
  /// Uses a safe downloading mechanism that prevents multiple concurrent downloads
  /// of the same file and handles errors gracefully
  /// Now uses isolates for downloading to avoid blocking the main thread
  Future<String> getCachedFilePath(String url) async {
    // Early exit for empty or invalid URLs
    if (url.isEmpty) {
      throw ArgumentError('URL cannot be empty');
    }

    try {
      // Check memory cache first for immediate hit
      if (_memoryCache.containsKey(url)) {
        final ExpirableCacheEntry entry = _memoryCache[url]!;
        if (!entry.isExpired && await File(entry.value).exists()) {
          // Update LRU queue - move this URL to the end (most recently used)
          _cacheQueue.remove(url);
          _cacheQueue.add(url);
          return entry.value;
        }
        // Remove stale cache entry if file doesn't exist or entry expired
        _memoryCache.remove(url);
        _cacheQueue.remove(url);
      }

      final String fileName = _generateFileName(url);
      final Directory cacheDir = await _getCacheDirectory();
      final String filePath = '${cacheDir.path}/$fileName';

      // Check if file exists in cache on disk
      if (await File(filePath).exists()) {
        // Add to cache with an expiring entry
        _memoryCache[url] = ExpirableCacheEntry(filePath);

        // Update LRU queue
        _cacheQueue.remove(url); // Remove if already exists
        _cacheQueue.add(url);   // Add to end (most recently used)

        return filePath;
      }

      // Check if this URL is already being downloaded
      if (_downloadCompleters.containsKey(url)) {
        // Wait for the existing download to complete instead of starting a new one
        debugPrint('Waiting for existing download of $url');
        return _downloadCompleters[url]!.future;
      }

      // Create a completer for this download
      final Completer<String> completer = Completer<String>();
      _downloadCompleters[url] = completer;

      // Download and cache the file using isolate
      try {
        // Create a ReceivePort for communication
        final ReceivePort receivePort = ReceivePort();

        // Prepare data for isolate
        final _IsolateData isolateData = _IsolateData(
          url,
          filePath,
          receivePort.sendPort,
        );

        // Spawn isolate
        final Isolate isolate = await Isolate.spawn(
          _downloadFileInIsolate,
          isolateData,
          debugName: 'LottieDownloader',
        );

        // Listen for result from isolate
        receivePort.listen((dynamic message) {
          if (message is _IsolateResult) {
            // Clean up isolate
            receivePort.close();
            isolate.kill(priority: Isolate.immediate);

            if (message.success) {
              // Update memory cache with expiring entry (30 minute expiry)
              _memoryCache[url] = ExpirableCacheEntry(filePath);

              // Update LRU queue
              _cacheQueue.remove(url); // In case it was already in the queue
              _cacheQueue.add(url);

              // Clean the cache if we went over the limit
              if (_cacheQueue.length > _maxCacheEntries) {
                final String oldestUrl = _cacheQueue.removeFirst();
                _memoryCache.remove(oldestUrl);
              }

              // Complete the future with the file path
              completer.complete(filePath);
            } else {
              // Complete with error
              final String error = message.error ?? 'Unknown error in download isolate';
              completer.completeError(Exception(error));
            }

            // Remove from active downloads
            _downloadCompleters.remove(url);
          }
        }, onError: (Object error) {
          // Handle errors in communication
          receivePort.close();
          isolate.kill(priority: Isolate.immediate);

          if (!completer.isCompleted) {
            completer.completeError(error);
          }

          _downloadCompleters.remove(url);
        }, onDone: () {
          // Ensure isolate is killed if port closes unexpectedly
          isolate.kill(priority: Isolate.immediate);
        });

      } catch (e) {
        debugPrint('Error spawning isolate for Lottie file download: $e');
        _downloadCompleters.remove(url);
        // Let the error propagate, but ensure the completer doesn't stay hanging
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
        rethrow; // Re-throw to be caught by the caller
      }

      return completer.future;
    } catch (e) {
      debugPrint('Fatal error in caching Lottie file: $e');
      rethrow; // Rethrow so caller knows something went wrong
    }
  }

  String _generateFileName(String url) {
    final Uint8List bytes = utf8.encode(url);
    final Digest digest = sha256.convert(bytes);
    return 'lottie_$digest.json';
  }

  Future<Directory> _getCacheDirectory() async {
    final Directory appCache = await getTemporaryDirectory();
    final Directory cacheDir = Directory('${appCache.path}/$_cacheDirectoryName');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }

    return cacheDir;
  }

  /// Clears all cached data and recreates the cache directory
  /// This is useful when experiencing memory issues or when you want to force
  /// reloading of all animations
  Future<void> clearCache() async {
    if (_isDisposed) return;

    try {
      // Clean up all downloads
      for (final Completer<String> completer in _downloadCompleters.values) {
        if (!completer.isCompleted) {
          completer.completeError('Cache cleared');
        }
      }
      _downloadCompleters.clear();

      // Clear memory cache
      _memoryCache.clear();
      _cacheQueue.clear();

      // Delete and recreate cache directory
      final Directory cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        await cacheDir.create(recursive: true);
      }

      // Run garbage collection on next frame
      PlatformDispatcher.instance.scheduleFrame();

      debugPrint('Lottie cache cleared successfully');
    } catch (e) {
      debugPrint('Error clearing Lottie cache: $e');
    }
  }

  /// Dispose of the cache manager and free resources
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;

    // Cancel cleanup timer
    _cleanupTimer?.cancel();
    _cleanupTimer = null;

    // Clear memory caches
    _memoryCache.clear();
    _cacheQueue.clear();

    // Cancel any pending downloads
    for (final Completer<String> completer in _downloadCompleters.values) {
      if (!completer.isCompleted) {
        completer.completeError('Cache manager disposed');
      }
    }
    _downloadCompleters.clear();

    debugPrint('Lottie cache manager disposed');
  }
}
/// Simple expiring cache entry to simulate weak references
class ExpirableCacheEntry {
  ExpirableCacheEntry(this.value, {Duration? expiry}) : 
    expiryTime = DateTime.now().add(expiry ?? const Duration(minutes: 30));
  
  final String value;
  final DateTime expiryTime;
  
  bool get isExpired => DateTime.now().isAfter(expiryTime);
}

/// Data class for isolate communication
class _IsolateData {
  _IsolateData(this.url, this.filePath, this.sendPort);
  final String url;
  final String filePath;
  final SendPort sendPort;
}

/// Result class for isolate communication
class _IsolateResult {
  _IsolateResult({required this.success, this.error, this.filePath});
  final bool success;
  final String? error;
  final String? filePath;
}

/// Static method to download file in isolate
Future<void> _downloadFileInIsolate(_IsolateData data) async {
  final SendPort sendPort = data.sendPort;
  final String url = data.url;
  final String filePath = data.filePath;

  try {
    // Create HTTP client
    final http.Client client = http.Client();
    try {
      // Download the file
      final http.Response response = await client.get(Uri.parse(url))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Save file to disk
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        // Send success result back
        sendPort.send(_IsolateResult(
          success: true,
          filePath: filePath,
        ));
      } else {
        // Send error result back
        sendPort.send(_IsolateResult(
          success: false,
          error: 'Failed to download file: HTTP ${response.statusCode}',
        ));
      }
    } catch (e) {
      // Send error result back
      sendPort.send(_IsolateResult(
        success: false,
        error: 'Error downloading file: $e',
      ));
    } finally {
      client.close();
    }
  } catch (e) {
    // Send error result for any uncaught exceptions
    sendPort.send(_IsolateResult(
      success: false,
      error: 'Uncaught error in isolate: $e',
    ));
  }
}

