import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

import '../../base/weather_container.dart';

class ViewMapWidget extends StatefulWidget {
  const ViewMapWidget({
    super.key,
    required this.map,
    this.isRadar = false,
    this.isFullScreen = false,
    this.openDrawer,
  });
  final String map;
  final bool isFullScreen;
  final bool isRadar;
  final void Function()? openDrawer;

  @override
  State<ViewMapWidget> createState() => _ViewMapWidgetState();
}

class _ViewMapWidgetState extends State<ViewMapWidget> {
  late InAppWebViewController _controller;
  bool _isWebViewReady = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  double _sliderValue = 0.0;
  bool _isPlaying = false;
  Timer? _timer;

  bool isRadar = true;

  Future<void> _playSlider() async {
    setState(() {
      _isPlaying = !_isPlaying;
    });

    if (_isPlaying) {
      _controller.evaluateJavascript(source: '''play();''');
      _timer = Timer.periodic(
        Duration(milliseconds: (1000 / 100).round()), // 100 steps in 1 second
        (Timer timer) {
          setState(() {
            _sliderValue += 0.001; // Increment by 0.01 for each step
          });

          if (_sliderValue >= 1.0) {
            _timer?.cancel();
            _isPlaying = false;
            _sliderValue = 0.0;
            _controller.evaluateJavascript(source: '''stop();''');
          }
        },
      );
      print('Playing slider $_sliderValue ...');
    } else {
      _controller.evaluateJavascript(source: '''stop();''');
      _timer?.cancel();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // endDrawer: const Drawer(child: RainViewerLegend()),
      body: Stack(
        children: <Widget>[
          // Show loading indicator until WebView is ready
          if (!_isWebViewReady)
            const Center(
              child: CircularProgressIndicator(),
            ),
            
          // Use AbsorbPointer to prevent touch events until WebView is ready
          AbsorbPointer(
            absorbing: !_isWebViewReady,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: InAppWebView(
                key: UniqueKey(),
                gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                  Factory<OneSequenceGestureRecognizer>(() => EagerGestureRecognizer()),
                },
                initialUrlRequest: widget.map.startsWith('http')
                    ? URLRequest(
                        url: WebUri(widget.map),
                      )
                    : null,
                initialData: !widget.map.startsWith('http') ? InAppWebViewInitialData(data: widget.map) : null,
                initialUserScripts: UnmodifiableListView(<UserScript>[
                  UserScript(
                    source: """
                            window.addEventListener('DOMContentLoaded', function(event) {
                              var header = document.querySelector('.elementor-location-header');
                                     header.remove();
                            });
                          
                            """,
                    injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
                  ),
                ]),
                onWebViewCreated: (InAppWebViewController controller) {
                  _controller = controller;
                },
                onLoadStop: (InAppWebViewController controller, Uri? url) {
                  // WebView is now ready to receive touch events
                  if (!_isWebViewReady && mounted) {
                    setState(() {
                      _isWebViewReady = true;
                    });
                  }
                },
                onReceivedError: (InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
                  // Handle WebView errors
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error loading map: ${error.description}'),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          if (widget.isFullScreen && widget.isRadar)
            Builder(builder: (BuildContext context) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 40.0),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: SizedBox(
                    height: 90,
                    width: MediaQuery.sizeOf(context).width * 0.8,
                    child: WeatherContainer(
                      color: Colors.black,
                      content: Row(
                        children: <Widget>[
                          buildIconButton(
                            onPressed: () => _playSlider(),
                            selected: _isPlaying,
                            withoutColor: true,
                            icon: !_isPlaying ? Icons.play_arrow : Icons.pause,
                          ),
                          const SizedBox(width: 10),
                          SfSlider(
                            showTicks: true,
                            showDividers: true,
                            stepSize: 10,
                            interval: 10,
                            value: _sliderValue,
                            onChanged: (value) => setState(() => _sliderValue = value as double),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          if (widget.isFullScreen && widget.isRadar)
            Builder(builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only(top: MediaQuery.sizeOf(context).height / 4, right: 15),
                child: Align(
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    width: 50,
                    height: 200,
                    child: WeatherContainer(
                      padding: const EdgeInsets.all(3),
                      color: Colors.black,
                      radius: 50,
                      content: Column(
                        children: <Widget>[
                          const SizedBox(height: 10),
                          buildIconButton(
                            onPressed: () {
                              setState(() => isRadar = true);
                              _controller.evaluateJavascript(source: """setKind('radar')""");
                            },
                            selected: isRadar,
                            icon: Icons.radar,
                          ),
                          const SizedBox(height: 10),
                          buildIconButton(
                            onPressed: () {
                              setState(() => isRadar = false);
                              _controller.evaluateJavascript(source: """setKind('satellite')""");
                            },
                            selected: !isRadar,
                            icon: Icons.cloud,
                          ),
                          const SizedBox(height: 10),
                          buildIconButton(
                              selected: true,
                              icon: Icons.info,
                              onPressed: () {
                                _scaffoldKey.currentState!.openEndDrawer();
                              }),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget buildIconButton({
    required bool selected,
    required IconData icon,
    required void Function() onPressed,
    bool withoutColor = false,
  }) {
    return IconButton(
      style: IconButton.styleFrom(
        maximumSize: const Size(35, 35),
        minimumSize: const Size(20, 20),
        backgroundColor: selected || withoutColor ? Colors.blue : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      onPressed: onPressed,
      icon: Icon(icon, size: 20, color: selected || withoutColor ? Colors.white : Colors.black),
    );
  }
}
