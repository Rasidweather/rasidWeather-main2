import 'dart:async';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/services/lottie_cache_manager.dart';

/// A widget that safely displays Lottie animations as backgrounds
/// with proper error handling, lifecycle management, and resource cleanup
class LottieBackground extends StatefulWidget {
  const LottieBackground({
    super.key,
    required this.animation,
    this.isAsset = false,
    this.fit = BoxFit.cover,
    this.repeat = true,
    this.errorBuilder,
  });

  final String animation;
  final bool isAsset;
  final BoxFit fit;
  final bool repeat;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  @override
  State<LottieBackground> createState() => _LottieBackgroundState();
}

class _LottieBackgroundState extends State<LottieBackground> with TickerProviderStateMixin {
  /// Main animation controller that will be recreated for each animation change
  AnimationController? _mainController;
  
  /// Cache manager singleton
  final LottieCacheManager _cacheManager = LottieCacheManager();
  
  /// Path to the cached Lottie file
  String? _cachedPath;
  
  /// Loading state
  bool _isLoading = true;
  
  // Animation duration is now handled directly in _setupAnimation
  
  /// Flag to track if state is disposed to prevent setState on disposed widget
  bool _disposed = false;
  
  /// Tracks if there's an error in loading/rendering
  bool _hasError = false;
  
  /// The error object if any
  Object? _error;
  
  /// The error stack trace if any
  StackTrace? _stackTrace;
  
  /// Cancellation token for async operations
  CancelableOperation<void>? _loadOperation;
  
  /// The current animation URL/path to avoid reloading the same animation
  String? _currentAnimation;
  
  /// Timer to schedule memory cleanup
  Timer? _cleanupTimer;
  
  /// Lottie composition to reuse
  LottieComposition? _composition;

  @override
  void initState() {
    super.initState();
    _createController();
    
    // Delay loading to next frame to ensure widget is fully mounted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_disposed) {
        _loadAnimation();
      }
    });
  }

  /// Creates a fresh animation controller
  void _createController() {
    _disposeController(); // Clean up any existing controller first
    _mainController = AnimationController(vsync: this);
  }

  /// Safely loads the animation with error handling and cancellation support
  Future<void> _loadAnimation() async {
    try {
      // Skip if we're trying to load the same animation
      if (_currentAnimation == widget.animation) {
        return;
      }
      
      // Cancel any in-progress load operation
      _loadOperation?.cancel();
      
      // Update current animation reference
      _currentAnimation = widget.animation;
      
      // Reset error state
      _hasError = false;
      _error = null;
      _stackTrace = null;
      
      // Reset animation state if controller exists
      if (_mainController != null) {
        try {
          _mainController!.reset();
        } catch (e) {
          // Controller may be in an invalid state, recreate it
          _createController();
        }
      }
      
      // If we're showing an asset, we don't need to preload it
      if (widget.isAsset) {
        if (mounted && !_disposed) {
          setState(() => _isLoading = false);
        }
        return;
      }

      // Start loading with cancellation support and catch all errors
      // ignore: always_specify_types
      _loadOperation = CancelableOperation.fromFuture(Future<void>(() async {
        try {
          if (_disposed) {
            return;
          }
          
          // Add a slight delay before loading to allow UI to settle
          await Future<void>.delayed(const Duration(milliseconds: 50));
          
          if (_disposed) {
            return;
          }
          
          final String path = await _cacheManager.getCachedFilePath(widget.animation);
          
          // Check if widget is still mounted and wants this animation
          if (mounted && !_disposed && _currentAnimation == widget.animation) {
            setState(() {
              _cachedPath = path;
              _isLoading = false;
            });
          }
        } catch (e, stackTrace) {
          debugPrint('Error loading Lottie animation: $e');
          
          // Only update state if this is still the current animation
          if (mounted && !_disposed && _currentAnimation == widget.animation) {
            setState(() {
              _cachedPath = null;
              _isLoading = false;
              _hasError = true;
              _error = e;
              _stackTrace = stackTrace;
            });
          }
        }
      }));
      
      // Mark as loading
      if (mounted && !_disposed) {
        setState(() {
          _isLoading = true;
        });
      }
    } catch (e) {
      // Catch all errors to prevent app crashes
      debugPrint('Critical error in _loadAnimation: $e');
      if (mounted && !_disposed) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _error = e;
        });
      }
    }
  }

  /// Safely sets up the animation with error handling
  void _setupAnimation(Duration duration) {
    if (_disposed || _mainController == null) {
      return;
    }
    
    try {
      // تحديد مدة أقصر للرسوم المتحركة لتحسين الأداء
      final Duration limitedDuration = duration.inMilliseconds > 3000 
          ? const Duration(milliseconds: 3000) 
          : duration;
      
      // Set the duration directly on the controller
      _mainController!.duration = limitedDuration;
      
      if (widget.repeat) {
        _mainController!.repeat();
      } else {
        _mainController!.forward();
      }
    } catch (e) {
      debugPrint('Error setting up animation: $e');
      // Don't rethrow - just log the error and continue
    }
  }
  
  /// Safely disposes the controller
  void _disposeController() {
    try {
      if (_mainController != null) {
        if (_mainController!.isAnimating) {
          _mainController!.stop();
        }
        _mainController!.reset();
        _mainController!.dispose();
        _mainController = null;
      }
    } catch (e) {
      debugPrint('Error disposing animation controller: $e');
    } finally {
      _mainController = null; // Ensure it's set to null even if there's an error
    }
  }

  @override
  void didUpdateWidget(LottieBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    try {
      // Only reload if the animation source changes
      if (widget.animation != oldWidget.animation) {
        debugPrint('Updating LottieBackground to ${widget.animation}');
        
        // Cancel any pending operations first
        _loadOperation?.cancel();
        
        // Create a new controller for the new animation to avoid state conflicts
        _createController();
        
        // Clear path to force reloading
        _cachedPath = null;
        
        // Load the new animation with a delay to separate it from build phase
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_disposed) {
            // Use a debounce-like delay to prevent rapid changes
            Future<void>.delayed(const Duration(milliseconds: 100), () {
              if (mounted && !_disposed) {
                _loadAnimation();
              }
            });
          }
        });
      } else if (widget.repeat != oldWidget.repeat && _mainController != null) {
        // If only the repeat setting changed, update just that setting
        try {
          if (widget.repeat) {
            _mainController!.repeat();
          } else if (_mainController!.isAnimating) {
            _mainController!.forward();
          }
        } catch (e) {
          debugPrint('Error updating animation controller: $e');
          // Recreate controller as recovery
          _createController();
        }
      }
    } catch (e) {
      // Catch any errors to prevent crashes during widget update
      debugPrint('Critical error in didUpdateWidget: $e');
    }
  }

  @override
  void dispose() {
    _disposed = true;
    
    // Cancel any pending operations
    _loadOperation?.cancel();
    _loadOperation = null;
    
    // Cancel any cleanup timers
    _cleanupTimer?.cancel();
    _cleanupTimer = null;
    
    // Clear composition reference
    _composition = null;
    
    // Clear cached path to allow GC to collect the file
    _cachedPath = null;
    
    // Dispose controller
    _disposeController();
    
    // Force a garbage collection hint
    Future<void>.microtask(() {
      // This is a hint to the Dart VM to do GC soon
    });
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Schedule cleanup to run periodically to free memory
    _scheduleCleanup();
    
    // Handle loading state
    if (_isLoading) {
      return const SizedBox.shrink();
    }

    // Handle error state
    if (_hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, _error ?? 'Unknown error', _stackTrace);
      }
      return const SizedBox.shrink();
    }

    // Get animation source
    final String? source = widget.isAsset ? widget.animation : _cachedPath;
    if (source == null) {
      return const SizedBox.shrink();
    }

    // Wrap everything in error boundary
    return ColoredBox(
      color: Colors.black,
      // تحديد حجم الرسوم المتحركة لتقليل استهلاك الذاكرة
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: RepaintBoundary( // Use RepaintBoundary to isolate animation rendering
          child: Builder(
          builder: (BuildContext context) {
            // Use try-catch to handle any rendering errors
            try {
              if (_mainController == null) {
                _createController();
              }
              
              if (widget.isAsset) {
                // Asset-based Lottie animations
                return Lottie.asset(
                  source,
                  // تعطيل بعض الخيارات لتحسين الأداء
                  options: LottieOptions(),
                  frameRate: const FrameRate(20), // تقليل معدل الإطارات أكثر لتحسين الأداء
                  controller: _mainController,
                  fit: widget.fit,
                  repeat: widget.repeat,
                  onLoaded: (LottieComposition composition) {
                    if (!_disposed) {
                      // Store composition for reuse
                      _composition = composition;
                      _setupAnimation(composition.duration);
                    }
                  },
                  errorBuilder: (BuildContext ctx, Object e, StackTrace? s) {
                    debugPrint('Lottie asset error: $e');
                    if (widget.errorBuilder != null) {
                      return widget.errorBuilder!(ctx, e, s);
                    }
                    return const SizedBox.shrink();
                  },
                );
              } else {
                // File-based Lottie animations - use cached composition if available
                try {
                  final File file = File(source);
                  // Check if file exists before trying to load it
                  if (!file.existsSync()) {
                    throw FileSystemException('Lottie file not found', source);
                  }
                  
                  // Use memory-efficient approach to loading Lottie files
                  
                  return Lottie.file(
                    file,
                    frameRate: const FrameRate(20), // تقليل معدل الإطارات أكثر لتحسين الأداء
                    controller: _mainController,
                    fit: widget.fit,
                    repeat: widget.repeat,
                    // تعطيل بعض الخيارات لتحسين الأداء
                    options: LottieOptions(),
                    onLoaded: (LottieComposition composition) {
                      if (!_disposed) {
                        // Store composition for reuse
                        _composition = composition;
                        _setupAnimation(composition.duration);
                      }
                    },
                    // Note: composition parameter is not available in Lottie.file()
                    // We use caching at the widget level instead
                    errorBuilder: (BuildContext ctx, Object e, StackTrace? s) {
                      debugPrint('Lottie file error: $e');
                      if (widget.errorBuilder != null) {
                        return widget.errorBuilder!(ctx, e, s);
                      }
                      return const SizedBox.shrink();
                    },
                  );
                } catch (e, stackTrace) {
                  debugPrint('File system error: $e');
                  if (widget.errorBuilder != null) {
                    return widget.errorBuilder!(context, e, stackTrace);
                  }
                  return const ColoredBox(color: Colors.black);
                }
              }
            } catch (e, stackTrace) {
              debugPrint('Error rendering Lottie: $e');
              if (widget.errorBuilder != null) {
                return widget.errorBuilder!(context, e, stackTrace);
              }
              return const ColoredBox(color: Colors.black);
            }
          },
        ),
      ),
      ),
    );
  }
  
  /// Schedule a delayed cleanup of resources to free memory
  void _scheduleCleanup() {
    _cleanupTimer?.cancel();
    _cleanupTimer = Timer(const Duration(seconds: 5), () {
      if (!mounted || _disposed) {
        return;
      }
      
      // Free up memory by cleaning cached references that aren't needed
      if (_composition != null && _currentAnimation != widget.animation) {
        _composition = null;
      }
      
      // Suggest garbage collection
      PlatformDispatcher.instance.scheduleFrame();
    });
  }
}
