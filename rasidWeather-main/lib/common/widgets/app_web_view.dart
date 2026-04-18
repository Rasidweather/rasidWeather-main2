import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppWebView extends StatefulWidget {
  const AppWebView({
    super.key,
    required this.url,
    this.title,
  });

  final String url;

  final String? title;

  @override
  State<AppWebView> createState() => _AppWebViewState();
}

class _AppWebViewState extends State<AppWebView> {
  bool _isLoading = true;
  double _progress = 0;
  late final InAppWebViewController _webViewController;
  String? _errorMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title ?? 'common.web_view'.tr(),
          style: Theme.of(context).textTheme.titleLarge!.copyWith(fontSize: 18),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
                _errorMessage = null;
              });
              _webViewController.reload();
            },
          ),
        ],
      ),
      body: Stack(
        children: <Widget>[
          if (_errorMessage == null)
            InAppWebView(
              initialUrlRequest: URLRequest(url: WebUri(widget.url)),
              initialOptions: InAppWebViewGroupOptions(
                crossPlatform: InAppWebViewOptions(
                  useShouldOverrideUrlLoading: true,
                  mediaPlaybackRequiresUserGesture: false,
                ),
                android: AndroidInAppWebViewOptions(
                  supportMultipleWindows: true,
                ),
                ios: IOSInAppWebViewOptions(
                  allowsInlineMediaPlayback: true,
                ),
              ),
              shouldOverrideUrlLoading: (InAppWebViewController controller, NavigationAction navigationAction) async {
                final WebUri? uri = navigationAction.request.url;
                if (uri != null) {
                  debugPrint('Navigating to: $uri');
                  return NavigationActionPolicy.ALLOW;
                }
                return NavigationActionPolicy.CANCEL;
              },
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;

                _webViewController.addJavaScriptHandler(
                    handlerName: 'consoleLog',
                    callback: (List<dynamic> args) {
                      debugPrint('WebView Console: ${args.join(', ')}');
                      return null;
                    });

                _webViewController.evaluateJavascript(source: '''
                  console.log = function(message) {
                    window.flutter_inappwebview.callHandler('consoleLog', message);
                  };
                ''');

                // Inject JavaScript to ensure proper content sizing
                _webViewController.evaluateJavascript(source: '''
                  (function() {
                    var meta = document.createElement('meta');
                    meta.name = 'viewport';
                    meta.content = 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no';
                    document.getElementsByTagName('head')[0].appendChild(meta);
                  })();
                ''');
              },
              onLoadStart: (InAppWebViewController controller, WebUri? url) {
                setState(() {
                  _isLoading = true;
                  _errorMessage = null;
                });
                debugPrint('WebView Loading: $url');
              },
              onProgressChanged:
                  (InAppWebViewController controller, int progress) {
                setState(() {
                  _progress = progress / 100;
                });
                debugPrint('WebView Progress: $progress%');
              },
              onLoadStop: (InAppWebViewController controller, WebUri? url) {
                setState(() {
                  _isLoading = false;
                });
                debugPrint('WebView Loaded: $url');

                _webViewController.evaluateJavascript(source: '''
                  (function() {
                    document.body.style.overflow = 'auto';
                    document.documentElement.style.overflow = 'auto';
                    document.body.style.height = 'auto';
                    document.documentElement.style.height = 'auto';
                    
                    document.body.style.width = '100%';
                    document.body.style.minHeight = '100%';
                    
                    document.addEventListener('touchstart', function() {}, {passive: true});
                    document.addEventListener('touchmove', function() {}, {passive: true});
                    
                    function hideElement(el) {
                      if (el) {
                        el.style.display = 'none';
                        el.style.visibility = 'hidden';
                        el.style.height = '0';
                        el.style.overflow = 'hidden';
                      }
                    }
                    
                    const elementsToHide = [
                      'header', '.header', '#header', 
                      'footer', '.footer', '#footer',
                      '.site-header', '.site-footer',
                      '.main-header', '.main-footer',
                      'nav', '.nav', '#nav', '.navbar', '#navbar',
                      '.bottom-bar', '#bottom-bar',
                      '.topbar', '#topbar', '.top-bar', '#top-bar',
                      '.menu-bar', '#menu-bar',
                      '.copyright', '#copyright',
                      '.social-icons', '#social-icons',
                      '.site-navigation', '#site-navigation',
                      '.site-info', '#site-info',
                      '.widget-area', '#widget-area',
                      '.main-header', '#main-header',"
                      '.header-container', '#header-container',
                      '.header-wrapper', '#header-wrapper',
                      '.header-inner', '#header-inner',
                      '.header-top', '#header-top',
                      '.header-bottom', '#header-bottom',
                      '.header-main', '#header-main',
                      '.header-nav', '#header-nav',
                      '.logo-wrapper', '#logo-wrapper',
                      '.menu-wrapper', '#menu-wrapper',
                      '.menu-container', '#menu-container',
                      '.primary-menu', '#primary-menu',
                      '.main-menu', '#main-menu',
                      '.menu-primary', '#menu-primary',
                      '.site-branding', '#site-branding'
                    ];
                    
                    // Hide elements by selector
                    elementsToHide.forEach(selector => {
                      const elements = document.querySelectorAll(selector);
                      elements.forEach(hideElement);
                    });
                    
                    function hideHeaderAndFooter() {
                      const headerCandidates = [
                        document.body.firstElementChild,
                        ...document.querySelectorAll('div[class*="header"]'),
                        ...document.querySelectorAll('div[id*="header"]'),
                        ...document.querySelectorAll('div[class*="nav"]'),
                        ...document.querySelectorAll('div[id*="nav"]'),
                        ...document.querySelectorAll('div[class*="menu"]'),
                        ...document.querySelectorAll('div[id*="menu"]')
                      ];
                      
                      headerCandidates.forEach(el => {
                        if (el && (
                            el.tagName === 'HEADER' || 
                            (el.className && el.className.toLowerCase().includes('header')) ||
                            (el.id && el.id.toLowerCase().includes('header')) ||
                            el.querySelector('nav') ||
                            el.querySelector('.logo') ||
                            el.querySelector('.menu') ||
                            el.querySelector('.nav') ||
                            el.offsetTop < 100 // Likely a header if at the top of page
                        )) {
                          hideElement(el);
                        }
                      });
                      
                      const footerCandidates = [
                        document.body.lastElementChild,
                        ...document.querySelectorAll('div[class*="footer"]'),
                        ...document.querySelectorAll('div[id*="footer"]')
                      ];
                      
                      footerCandidates.forEach(el => {
                        if (el && (
                            el.tagName === 'FOOTER' || 
                            (el.className && el.className.toLowerCase().includes('footer')) ||
                            (el.id && el.id.toLowerCase().includes('footer')) ||
                            el.querySelector('.copyright') ||
                            el.querySelector('.social')
                        )) {
                          hideElement(el);
                        }
                      });
                    }
                    
                    hideHeaderAndFooter();
                    setTimeout(hideHeaderAndFooter, 1000);
                    setTimeout(hideHeaderAndFooter, 2000);
                    
                    const allFixedElements = document.querySelectorAll('*');
                    allFixedElements.forEach(el => {
                      const style = window.getComputedStyle(el);
                      if (style.position === 'fixed' && parseInt(style.top) === 0) {
                        hideElement(el);
                      }
                    });
                  })();
                ''');

                _webViewController.evaluateJavascript(source: '''
                  (function() {
                    var body = document.body;
                    var html = document.documentElement;
                    return {
                      bodyContent: body ? body.innerHTML.length : 0,
                      title: document.title,
                      height: Math.max(body ? body.scrollHeight : 0, html ? html.scrollHeight : 0)
                    };
                  })();
                ''').then((result) {
                  debugPrint('WebView Content Info: $result');
                });
              },
              onLoadError: (InAppWebViewController controller, Uri? url,
                  int code, String message) {
                setState(() {
                  _isLoading = false;
                  _errorMessage = 'Error $code: $message';
                });
                debugPrint(
                    'WebView Error: Code $code, Message: $message, URL: $url');
                _showErrorSnackBar(message);
              },
              onReceivedHttpError: (InAppWebViewController controller, WebResourceRequest request, WebResourceResponse errorResponse) {
                debugPrint(
                    'WebView HTTP Error: Status ${errorResponse.statusCode}, URL: ${request.url}');
                if (errorResponse.statusCode != null &&
                    errorResponse.statusCode! >= 400) {
                  setState(() {
                    _errorMessage = 'HTTP Error ${errorResponse.statusCode}';
                  });
                }
              },
            ),
          if (_errorMessage != null)
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    _errorMessage!,
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _isLoading = true;
                        _errorMessage = null;
                      });
                      _webViewController.reload();
                    },
                    child: Text('common.retry'.tr()),
                  ),
                ],
              ),
            ),
          if (_isLoading && _errorMessage == null)
            Column(
              children: <Widget>[
                LinearProgressIndicator(
                  value: _progress,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(
                      Theme.of(context).primaryColor),
                ),
                if (_progress < 1.0)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Theme.of(context).primaryColor),
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            'common.loading'.tr(),
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Error: $message'),
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'common.retry'.tr(),
          onPressed: () {
            setState(() {
              _isLoading = true;
              _errorMessage = null;
            });
            _webViewController.reload();
          },
        ),
      ),
    );
  }
}
