import 'routes.dart';
import '../../controller/auth/log_out/log_out_cubit.dart';
import '../../view/screen/account/delete_account/delete_account_screen.dart';
import '../../view/screen/account/delete_account/re_auth_screen.dart';
import '../../view/screen/auth/login_screen.dart';
import '../../view/screen/auth/password_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/auth/sign_in/sign_in_cubit.dart';
import '../../controller/auth/sign_up/sign_up_cubit.dart';
import '../../controller/launch_uri/launch_uri_cubit.dart';
import '../../controller/maps/maps_cubit.dart';
import '../../view/screen/account/about_us_screen.dart';
import '../../view/screen/account/change_password/new_pass_word.dart';
import '../../view/screen/account/change_password/old_password_screen.dart';
import '../../view/screen/auth/create_profile.dart';
import '../../view/screen/auth/email_screen.dart';
import '../../view/screen/chat/chat_screen.dart';
import '../../view/screen/chat/voice_screen.dart';
import '../../view/screen/nav_bar/home_screen.dart';
import '../../view/screen/nav_bar/maps_screen.dart';
import '../../view/screen/nav_bar/nav_bar_screen_.dart';
import '../../view/screen/account/edit_profile_screen.dart';
import '../../view/screen/splash_screen.dart';
import 'page_transition.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteManager.initialRoute:
        return CustomPageTransitions.fade(BlocProvider(
          create: (context) => LogOutCubit(),
          child: const SplashScreen(),
        ));
      case RouteManager.login:
        return CustomPageTransitions.fade(BlocProvider(
          create: (context) => SignInCubit(),
          child: const LoginScreen(),
        ));
      case RouteManager.home:
        return CustomPageTransitions.fadeForwards(
          const HomeScreen(),
        );
      case RouteManager.email:
        return CustomPageTransitions.fadeForwards(BlocProvider(
          create: (context) => SignUpCubit(),
          child: const EmailScreen(),
        ));
      case RouteManager.password:
        String userEmail = settings.arguments as String;
        return CustomPageTransitions.fadeForwards(BlocProvider(
          create: (context) => SignUpCubit(),
          child: PasswordScreen(email: userEmail),
        ));
      case RouteManager.information:
        List<String?> userCredential = settings.arguments as List<String?>;
        return CustomPageTransitions.fadeForwards(BlocProvider(
          create: (context) => SignUpCubit(),
          child: CreateProfile(userCredential: userCredential),
        ));
      case RouteManager.nav:
        return CustomPageTransitions.fadeForwards(MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (context) => MapsCubit(),
            ),
            BlocProvider(
              create: (context) => LaunchUriCubit(),
            ),
          ],
          child: const NavbarScreen(),
        ));
      case RouteManager.chat:
        return CustomPageTransitions.fadeForwards(
          const ChatScreen(),
        );
      case RouteManager.voice:
        return CustomPageTransitions.fade(
          const VoiceChatScreen(),
        );
      case RouteManager.editProfile:
        return CustomPageTransitions.fadeForwards(
          const EditProfileScreen(),
        );
      case RouteManager.oldPassword:
        return CustomPageTransitions.fadeForwards(
          const OldPasswordScreen(),
        );
      case RouteManager.newPassword:
        return CustomPageTransitions.fadeForwards(
          const NewPasswordScreen(),
        );
      case RouteManager.aboutUs:
        return CustomPageTransitions.fadeForwards(
          const AboutUsScreen(),
        );
      case RouteManager.maps:
        return CustomPageTransitions.fadeForwards(BlocProvider(
          create: (context) => MapsCubit(),
          child: const MapScreen(),
        ));
      case RouteManager.reAuthScreen:
        return CustomPageTransitions.fadeForwards(
          const ReAuthScreen(),
        );
      case RouteManager.deleteAccount:
        return CustomPageTransitions.fadeForwards(const DeleteAccountScreen());
      default:
        return null;
    }
  }
}
