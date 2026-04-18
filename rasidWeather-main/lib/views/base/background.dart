import 'package:cached_video_player_plus/cached_video_player_plus.dart';
import 'package:flutter/material.dart';

class BackgroundVideo extends StatefulWidget {
  const BackgroundVideo({super.key, required this.video, this.isAsset = false});

  final String video;
  final bool isAsset;

  @override
  BackgroundVideoState createState() => BackgroundVideoState();
}

class BackgroundVideoState extends State<BackgroundVideo> with WidgetsBindingObserver {
  CachedVideoPlayerPlusController? _controller;
  CachedVideoPlayerPlusController? _nextController;
  bool _isChangingVideo = false;
  double _currentOpacity = 1.0;
  bool _isPaused = false;
  static const Duration _fadeOutDuration = Duration(milliseconds: 500);
  
  // Track if widget is active to prevent unnecessary operations
  bool _isActive = true;

  // Cache configuration with stronger caching directives
  static const Map<String, String> _cacheHeaders = <String, String>{
    'Cache-Control': 'max-age=31536000, immutable', // Cache for 1 year, mark as immutable
    'Pragma': 'cache',
  };

  // Cache for video URLs to prevent duplicate downloads
  static final Map<String, bool> _cachedVideos = <String, bool>{};

  @override
  void initState() {
    super.initState();
    // Register observer for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
    
    // Delay initialization to ensure widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && _isActive) {
        _initializeController();
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // Handle app lifecycle changes
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      // App is in background or inactive, pause video to save resources
      _pauseVideo();
    } else if (state == AppLifecycleState.resumed) {
      // App is in foreground again, resume video if it was playing before
      _resumeVideo();
    }
  }
  
  void _pauseVideo() {
    if (_controller != null && _controller!.value.isPlaying) {
      _isPaused = true;
      _controller!.pause();
    }
  }
  
  void _resumeVideo() {
    if (_isPaused && _controller != null && _controller!.value.isInitialized) {
      _isPaused = false;
      _controller!.play();
    }
  }

  Future<void> _initializeController() async {
    if (!mounted || !_isActive) return;
    
    // Check if video is already cached
    if (_cachedVideos[widget.video] ?? false) {
      debugPrint('Using previously cached video [${widget.video}]');
    }
    
    _controller = _createController(widget.video);

    // Initialize and play directly
    await _initializeAndPlay(_controller!);
    
    // Mark video as cached
    _cachedVideos[widget.video] = true;

    if (mounted && _isActive) {
      setState(() {});
    }
  }

  CachedVideoPlayerPlusController _createController(String videoPath) {
    if (widget.isAsset) {
      return CachedVideoPlayerPlusController.asset(
        videoPath, 
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true)
      );
    } else {
      return CachedVideoPlayerPlusController.networkUrl(
        Uri.parse(videoPath),
        videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),
        httpHeaders: _cacheHeaders,
      );
    }
  }

  Future<void> _initializeAndPlay(CachedVideoPlayerPlusController controller) async {
    if (!mounted || !_isActive) return;
    
    try {
      await controller.initialize();
      await controller.setLooping(true);
      await controller.setVolume(0);

      // Always play video if it's initialized and widget is active
      if (controller.value.isInitialized && mounted && _isActive && !_isPaused) {
        await controller.play();
      }
      
      debugPrint('Cached video [${widget.video}] successfully.');
    } catch (e) {
      debugPrint('Error initializing video: $e');
      // Don't try to recover automatically to avoid potential infinite loops
    }
  }

  Future<void> _changeVideo(String newVideo) async {
    if (_isChangingVideo || !mounted || !_isActive) {
      return;
    }

    setState(() {
      _isChangingVideo = true;
      _currentOpacity = 1.0;
    });

    // Prepare the next video
    _nextController = _createController(newVideo);

    // Initialize the controller directly
    await _initializeAndPlay(_nextController!);

    // Fade out current video
    if (mounted && _isActive) {
      setState(() => _currentOpacity = 0.0);
    }

    await Future<void>.delayed(_fadeOutDuration);

    if (!mounted || !_isActive) {
      // Clean up if widget was disposed during animation
      _nextController?.dispose();
      _nextController = null;
      return;
    }

    // Cleanup old controller and switch to new one
    final CachedVideoPlayerPlusController? oldController = _controller;
    _controller = _nextController;
    _nextController = null;
    
    // Dispose old controller after switching to prevent UI glitches
    await oldController?.dispose();

    if (mounted && _isActive) {
      setState(() {
        _currentOpacity = 1.0;
        _isChangingVideo = false;
      });
    }
  }

  @override
  void didUpdateWidget(BackgroundVideo oldWidget) {
    super.didUpdateWidget(oldWidget);
    
    if (!_isActive) return;
    
    if (widget.video != oldWidget.video) {
      _changeVideo(widget.video);
    } else if (_controller != null && !_controller!.value.isPlaying && 
              _controller!.value.isInitialized && !_isPaused) {
      // Ensure video is playing if it's initialized but not playing
      _controller!.play();
    }
  }
  
  @override
  void deactivate() {
    // Widget is being removed from the tree temporarily
    _isActive = false;
    _pauseVideo();
    super.deactivate();
  }
  
  @override
  void activate() {
    // Widget is being inserted back into the tree
    _isActive = true;
    _resumeVideo();
    super.activate();
  }

  @override
  void dispose() {
    // Unregister observer
    WidgetsBinding.instance.removeObserver(this);
    
    // Dispose controllers
    _controller?.dispose();
    _controller = null;
    
    if (_isChangingVideo && _nextController != null) {
      _nextController!.dispose();
      _nextController = null;
    }
    
    _isActive = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isActive || _controller == null) {
      return const ColoredBox(color: Colors.black);
    }
    
    return ColoredBox(
      color: Colors.black,
      child: _controller!.value.isInitialized
          ? RepaintBoundary(
              child: AnimatedOpacity(
                duration: _fadeOutDuration,
                opacity: _currentOpacity,
                child: SizedBox.expand(
                  child: FittedBox(
                    fit: BoxFit.cover,
                    child: SizedBox(
                      width: _controller!.value.size.width,
                      height: _controller!.value.size.height,
                      child: CachedVideoPlayerPlus(_controller!),
                    ),
                  ),
                ),
              ),
            )
          : const ColoredBox(color: Colors.black),
    );
  }
}
