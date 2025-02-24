import 'package:flutter/material.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget child;

  SlideRightRoute({required this.child})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(1.0, 0.0), // Slide from right to left
          end: Offset.zero,
        ).animate(animation),
        child: child,
      );
    },
  );
}

class FadeTransitionRoute extends PageRouteBuilder {
  final Widget child;

  FadeTransitionRoute({required this.child})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}