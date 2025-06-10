import 'package:flutter/material.dart';

class PageTransitionManager {
  PageTransitionManager._();

  //? default transition
  static materialPageRoute(Widget screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }

  static PageRouteBuilder slideTransition(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);
        var fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder bottomToTopTransition(Widget screen) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0); // Start from bottom
        const end = Offset.zero; // End at top (default position)
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);
        var fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder scaleTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder rotationTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return RotationTransition(
          turns: Tween<double>(
            begin: 0.0,
            end: 1.0,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder fadeTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  static PageRouteBuilder defaultTextStyleTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return DefaultTextStyleTransition(
          style: animation.drive(
            TextStyleTween(
              begin: const TextStyle(color: Colors.transparent),
              end: const TextStyle(color: Colors.black),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // DecoratedBoxTransition
  static PageRouteBuilder decoratedBoxTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return DecoratedBoxTransition(
          decoration: animation.drive(
            DecorationTween(
              begin: const BoxDecoration(color: Colors.transparent),
              end: const BoxDecoration(color: Colors.blue),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // PositionedTransition
  static PageRouteBuilder positionedTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return PositionedTransition(
          rect: animation.drive(
            RelativeRectTween(
              begin: RelativeRect.fill,
              end: const RelativeRect.fromLTRB(10, 10, 10, 10),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // RelativeRectTween
  static PageRouteBuilder relativeRectTween(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return PositionedTransition(
          rect: animation.drive(
            RelativeRectTween(
              begin: RelativeRect.fill,
              end: const RelativeRect.fromLTRB(10, 10, 10, 10),
            ),
          ),
          child: child,
        );
      },
    );
  }

  // SizeTransition
  static PageRouteBuilder sizeTransition(Widget screen,
      [int milliseconds = 300]) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => screen,
      transitionDuration: Duration(milliseconds: milliseconds),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SizeTransition(
          sizeFactor: animation,
          child: child,
        );
      },
    );
  }

  static CustomMaterialPageRoute materialSlideTransition(Widget screen) {
    return CustomMaterialPageRoute(builder: (context) => screen);
  }

  static CustomMaterialPageRouteBottomUp materialBottomToTopTransition(
      Widget screen) {
    return CustomMaterialPageRouteBottomUp(builder: (context) => screen);
  }
}

class CustomMaterialPageRoute<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRoute(
      {required WidgetBuilder builder, RouteSettings? settings})
      : super(builder: builder, settings: settings);

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(tween);
        var fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animation);
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class CustomMaterialPageRouteBottomUp<T> extends MaterialPageRoute<T> {
  CustomMaterialPageRouteBottomUp({
    required super.builder,
    super.settings,
  });

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        const beginOffset = Offset(0.0, 1.0); // Start from bottom
        const endOffset = Offset.zero; // End at top
        const curve = Curves.easeInOut; // Smoother curve
        var slideTween = Tween(begin: beginOffset, end: endOffset)
            .chain(CurveTween(curve: curve));
        var slideAnimation = animation.drive(slideTween);

        var fadeAnimation = Tween<double>(begin: 0.0, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve));

        var scaleAnimation = Tween<double>(begin: 0.95, end: 1.0)
            .animate(CurvedAnimation(parent: animation, curve: curve));

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(
              scale: scaleAnimation,
              child: child,
            ),
          ),
        );
      },
      child: child,
    );
  }
}