import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../core/services/lottie_cache_manager.dart';

/// A widget that displays a Lottie animation as an icon.
/// 
/// This widget is optimized for small animations that are used as icons or small UI elements.
/// It provides proper lifecycle management and memory optimization.
class LottieIcon extends StatefulWidget {
  /// Creates a LottieIcon widget.
  /// 
  /// The [source] parameter is required and specifies the path to the Lottie animation.
  /// If [isAsset] is true, [source] should be an asset path. Otherwise, it should be a URL.
  const LottieIcon({
    super.key,
    required this.source,
    this.size = 24.0,
    this.shouldAnimate = true,
    this.isAsset = true,
    this.fit = BoxFit.contain,
    this.color,
    this.onLoaded,
    this.useCache = true,
    this.repeat = true,
  });
  
  /// The source of the Lottie animation.
  /// 
  /// If [isAsset] is true, this should be an asset path.
  /// Otherwise, it should be a URL.
  final String source;
  
  /// The size of the icon.
  /// 
  /// This value is used for both width and height.
  final double size;
  
  /// Whether the animation should play.
  /// 
  /// If false, the animation will be paused at the first frame.
  final bool shouldAnimate;
  
  /// Whether the source is an asset.
  /// 
  /// If true, [source] should be an asset path.
  /// If false, [source] should be a URL.
  final bool isAsset;
  
  /// How the animation should be inscribed into the space allocated.
  final BoxFit fit;
  
  /// The color to apply to the animation.
  /// 
  /// This will tint the entire animation with this color.
  final Color? color;
  
  /// Callback when the animation is loaded.
  /// 
  /// This is useful for getting the duration of the animation.
  // ignore: inference_failure_on_function_return_type
  final Function(LottieComposition)? onLoaded;
  
  /// Whether to use the cache for network animations.
  /// 
  /// If true, network animations will be cached to disk.
  final bool useCache;
  
  /// Whether the animation should repeat.
  /// 
  /// If false, the animation will play once and stop.
  final bool repeat;

  @override
  State<LottieIcon> createState() => _LottieIconState();
}

class _LottieIconState extends State<LottieIcon> with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController _controller;
  bool _isPlaying = false;
  bool _isActive = true;
  String? _cachedPath;
  bool _isLoading = true;
  final LottieCacheManager _cacheManager = LottieCacheManager();
  
  // Static cache to prevent duplicate loading
  static final Map<String, String> _cachedSources = <String, String>{};

  @override
  void initState() {
    super.initState();
    // Register for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    
    // Initialize controller with a default duration to avoid errors
    // This will be replaced when the composition is loaded
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1)
    );
    
    // Load animation after first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (mounted && _isActive) {
       await _loadAnimation();
      }
    });
  }
  
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App is in background or inactive, pause animation to save resources
      _pauseAnimation();
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground again, resume animation if it was playing before
      _resumeAnimation();
    }
  }
  
  void _pauseAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    }
  }
  
  void _resumeAnimation() {
    if (widget.shouldAnimate && _isPlaying && mounted && _isActive) {
      if (widget.repeat) {
        _controller.repeat();
      } else if (_controller.status != AnimationStatus.completed) {
        _controller.forward();
      }
    }
  }

  // Cache key generator for better cache hits
  String _getCacheKey(String source) => 'lottie-${source.hashCode}';
  
  Future<void> _loadAnimation() async {
    if (!mounted || !_isActive) return;
    
    // Only set loading state once at the beginning
    if (!_isLoading) {
      setState(() => _isLoading = true);
    }
    
    try {
      if (widget.isAsset) {
        // Asset animations are loaded directly - nothing to cache
        if (mounted && _isActive && _isLoading) {
          setState(() => _isLoading = false);
        }
        return;
      }
      
      // For network animations, implement optimized caching
      if (widget.useCache) {
        final String cacheKey = _getCacheKey(widget.source);
        
        // Check memory cache first (fast path)
        if (_cachedSources.containsKey(cacheKey)) {
          final String cachedPath = _cachedSources[cacheKey]!;
          final File cachedFile = File(cachedPath);
          
          if (await cachedFile.exists()) {
            // Cache hit - use the cached file
            if (mounted && _isActive) {
              // Avoid unnecessary setState if path hasn't changed
              if (_cachedPath != cachedPath || _isLoading) {
                setState(() {
                  _cachedPath = cachedPath;
                  _isLoading = false;
                });
              }
              return;
            }
          } else {
            // File doesn't exist anymore, remove from memory cache
            _cachedSources.remove(cacheKey);
          }
        }
        
        // Not in memory cache, try disk cache
        final String path = await _cacheManager.getCachedFilePath(widget.source);
        
        if (mounted && _isActive) {
          // Add to memory cache for future use
          _cachedSources[cacheKey] = path;
          
          // Update state only if needed
          if (_cachedPath != path || _isLoading) {
            setState(() {
              _cachedPath = path;
              _isLoading = false;
            });
          }
        }
      } else {
        // No caching, just set loading to false
        if (mounted && _isActive && _isLoading) {
          setState(() => _isLoading = false);
        }
      }
    } catch (e) {
      debugPrint('Error loading Lottie icon: $e');
      if (mounted && _isActive) {
        setState(() {
          _cachedPath = null;
          _isLoading = false;
        });
      }
    }
    
    // Set playing state for when the composition is loaded
    _isPlaying = widget.shouldAnimate;
  }

  /// Plays the animation if it should be animated
  void _playAnimation() {
    if (!mounted || !_isActive) return;
    
    // Only play if we have a valid duration
    if (widget.shouldAnimate && _controller.duration != null) {
      if (widget.repeat) {
        _controller.repeat();
      } else {
        _controller.forward();
      }
      _isPlaying = true;
    }
  }

  /// Sets up the animation controller with the loaded composition
  void _setupAnimation(LottieComposition composition) {
    if (!mounted || !_isActive) return;
    
    _controller.duration = composition.duration;
    
    _playAnimation();
    
    // Call onLoaded callback if provided
    if (widget.onLoaded != null) {
      widget.onLoaded!(composition);
    }
  }

  @override
  void didUpdateWidget(covariant LottieIcon oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!_isActive) return;
    
    // Check if any important properties changed
    final bool sourceChanged = widget.source != oldWidget.source || 
                              widget.isAsset != oldWidget.isAsset;
    
    if (sourceChanged) {
      // Source changed, reload animation
      _loadAnimation();
    } else if (widget.shouldAnimate != oldWidget.shouldAnimate) {
      // Animation state changed
      if (widget.shouldAnimate && !_isPlaying) {
        _resumeAnimation();
      } else if (!widget.shouldAnimate && _isPlaying) {
        _pauseAnimation();
        _isPlaying = false;
      }
    }
  }
  
  @override
  void deactivate() {
    // Widget is being removed from the tree temporarily
    _isActive = false;
    _pauseAnimation();
    super.deactivate();
  }
  
  @override
  void activate() {
    // Widget is being inserted back into the tree
    _isActive = true;
    _resumeAnimation();
    super.activate();
  }

  @override
  void dispose() {
    // Unregister observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose controller
    _controller.dispose();
    
    _isActive = false;
    super.dispose();
  }

  // Memoize delegates to avoid recreating them on every build
  LottieDelegates? _buildDelegates() {
    if (widget.color == null) return null;
    
    return LottieDelegates(
      values: <ValueDelegate<dynamic>>[
        ValueDelegate.color(
          const <String>['**'],
          value: widget.color,
        ),
      ],
    );
  }
  
  // Create a placeholder with the correct size
  Widget _buildPlaceholder() {
    return SizedBox(
      width: widget.size,
      height: widget.size,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    // Return placeholder while loading
    if (_isLoading) {
      return _buildPlaceholder();
    }
    
    // Memoize common properties to avoid recreating them
    final double size = widget.size;
    final BoxFit fit = widget.fit;
    final String source = widget.source;
    final LottieDelegates? delegates = _buildDelegates();
    
    // Create the appropriate Lottie builder based on source type
    Widget lottieWidget;
    
    if (widget.isAsset) {
      // Asset animation
      lottieWidget = LottieBuilder.asset(
        key: ValueKey<String>('LottieBuilder-asset-$source'),
        source,
        controller: _controller,
        width: size,
        height: size,
        fit: fit,
        repeat: false, // We handle repeat with the controller
        animate: false, // We handle animation with the controller
        delegates: delegates,
        onLoaded: _setupAnimation,
        frameRate: FrameRate.max, // Optimize for performance
      );
    } else if (widget.useCache && _cachedPath != null) {
      // Cached file animation
      lottieWidget = LottieBuilder.file(
        key: ValueKey<String>('LottieBuilder-file-$source'),
        File(_cachedPath!),
        controller: _controller,
        width: size,
        height: size,
        fit: fit,
        repeat: false,
        animate: false,
        delegates: delegates,
        onLoaded: _setupAnimation,
        frameRate: FrameRate.max,
      );
    } else {
      // Network animation
      lottieWidget = LottieBuilder.network(
        key: ValueKey<String>('LottieBuilder-network-$source'),
        source,
        controller: _controller,
        width: size,
        height: size,
        fit: fit,
        repeat: false,
        animate: false,
        delegates: delegates,
        onLoaded: _setupAnimation,
        frameRate: FrameRate.max,
      );
    }
    
    // Use a key based on the source to ensure proper widget identity
    return RepaintBoundary(
      key: ValueKey<String>('lottie-${widget.isAsset ? 'asset' : 'network'}-$source-$size'),
      child: lottieWidget,
    );
  }
}
