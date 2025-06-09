import 'package:flutter/material.dart';

class CustomPageTransitions {
  const CustomPageTransitions._();

  static PageTransitionsTheme get theme =>
      PageTransitionsTheme(
        builders: Map<TargetPlatform, PageTransitionsBuilder>.fromIterable(
          TargetPlatform.values,
          value: (platform) {
            switch (platform) {
              case TargetPlatform.iOS:
                return const CupertinoPageTransitionsBuilder();
              case TargetPlatform.android:
                return const FadeForwardsPageTransitionsBuilder();
              default:
                return const FadeForwardsPageTransitionsBuilder();
            }
          },
        ),
      );

  static materialPageRoute(Widget screen) {
    return MaterialPageRoute(builder: (context) => screen);
  }

  static PageRouteBuilder fade(Widget screen, [int duration = 300]) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static PageRouteBuilder fadeUpwards(Widget screen, {int duration = 300}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
          null,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  static PageRouteBuilder openUpwards(Widget screen, {int duration = 300}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const OpenUpwardsPageTransitionsBuilder().buildTransitions(
          null,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }

  static PageRouteBuilder fadeForwards(Widget screen, {int duration = 300}) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => screen,
      transitionDuration: Duration(milliseconds: duration),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return const FadeForwardsPageTransitionsBuilder().buildTransitions(
          null,
          context,
          animation,
          secondaryAnimation,
          child,
        );
      },
    );
  }
}