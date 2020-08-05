import 'package:flutter/material.dart';

class SlideFromBottomRoute extends PageRouteBuilder {
  SlideFromBottomRoute(
    this.screen,
  ) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              screen,
          transitionDuration: const Duration(milliseconds: 400),
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: Offset(
                0,
                1,
              ),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );

  final Widget screen;
}
