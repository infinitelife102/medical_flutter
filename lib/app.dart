import 'package:dr_ai/core/router/routes.dart';
import 'package:dr_ai/controller/chat/chat_cubit.dart';
import 'package:dr_ai/controller/validation/formvalidation_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'core/utils/theme/color.dart';
import 'core/utils/helper/responsive.dart';
import 'core/router/app_router.dart';
import 'core/utils/theme/app_theme.dart';
import 'controller/account/account_cubit.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    ScreenSize.init(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ChatCubit(),
        ),
        BlocProvider(
          create: (_) => ValidationCubit(),
        ),
        BlocProvider(
          create: (_) => AccountCubit(),
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        child: Builder(
            builder: (_) => MaterialApp(
                  builder: (context, widget) {
                    final mediaQueryData = MediaQuery.of(context);
                    final scaledMediaQueryData = mediaQueryData.copyWith(
                      textScaler: TextScaler.noScaling,
                    );
                    return MediaQuery(
                      data: scaledMediaQueryData,
                      child: widget!,
                    );
                  },
                  themeAnimationStyle: AnimationStyle(
                    duration: const Duration(microseconds: 250),
                    curve: Curves.ease,
                  ),
                  color: ColorManager.white,
                  debugShowCheckedModeBanner: false,
                  supportedLocales: const [
                    Locale('en', 'US'),
                    Locale('ar', 'EG'),
                  ],
                  locale: const Locale('en', 'US'),
                  title: 'Dr AI',
                  theme: AppTheme.lightTheme,
                  initialRoute: RouteManager.initialRoute,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                )),
      ),
    );
  }
}
