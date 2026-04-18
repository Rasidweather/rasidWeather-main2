import 'package:flutter/material.dart';

import '../utils/responsive.dart';

class ResponsiveWidget extends StatelessWidget {

  const ResponsiveWidget({
    super.key,
    this.drawer,
    this.endDrawerWidget,
    this.centerWidget,
    this.drawerFlex = 3,
    this.centerFlex = 8,
    this.endDrawerFlex = 4,
  });
  final Widget? drawer;
  final Widget? endDrawerWidget;
  final Widget? centerWidget;

  /// Flex values for the drawer, center widget, and end drawer respectively
  final int drawerFlex;
  final int centerFlex;
  final int endDrawerFlex;

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile;
    final bool isDesktop = Responsive.isDesktop;
    final Size size = MediaQuery.of(context).size;

    if (drawer == null && endDrawerWidget == null && centerWidget == null) {
      return Scaffold(
        body: Center(
          child: Text(
            'No content available',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
      );
    }

    return Scaffold(
      drawer: (drawer != null && !isDesktop) ? SizedBox(width: 250, child: drawer) : null,
      endDrawer: (endDrawerWidget != null && isMobile) ? SizedBox(width: size.width * 0.8, child: endDrawerWidget) : null,
      body: !isMobile
          ? SafeArea(
              child: Row(
                children: <Widget>[
                  // Left-side permanent drawer on desktop
                  if (isDesktop && drawer != null)
                    Expanded(
                      flex: drawerFlex,
                      child: SizedBox(
                        height: size.height,
                        child: drawer,
                      ),
                    ),

                  // Main area: center widget
                  if (centerWidget != null) Expanded(flex: centerFlex, child: centerWidget!),

                  // Right-side panel on desktop/tablet
                  if (!isMobile && endDrawerWidget != null) Expanded(flex: endDrawerFlex, child: endDrawerWidget!),
                ],
              ),
            )
          : SafeArea(
              child: Column(
              children: <Widget>[
                if (isMobile && drawer != null) Expanded(flex: drawerFlex, child: drawer!),
                if (centerWidget != null)
                  // Add constraints here:
                  Expanded(flex: centerFlex, child: centerWidget!),
                if (isMobile && endDrawerWidget != null) Expanded(flex: endDrawerFlex, child: endDrawerWidget!),
              ],
            )),
    );
  }
}
