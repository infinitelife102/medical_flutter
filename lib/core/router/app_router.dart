import '../../view/screen/account/about_us/social_media_screen.dart';
import '../../view/screen/account/app_feedback_screen.dart';
import '../../view/screen/account/app_updates_screen.dart';
import '../../view/screen/account/privacy_policy.dart';
import '../../view/screen/account/terms_and_conditions.dart';
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
import '../../view/screen/account/about_us/about_us_screen.dart';
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
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (_) => LogOutCubit(),
          child: const SplashScreen(),
        ));
      case RouteManager.login:
        return PageTransitionManager.materialPageRoute(BlocProvider(
          create: (_) => SignInCubit(),
          child: const LoginScreen(),
        ));
      case RouteManager.home:
        return PageTransitionManager.materialPageRoute(
          const HomeScreen(),
        );
      case RouteManager.email:
        return PageTransitionManager.materialPageRoute(BlocProvider(
          create: (_) => SignUpCubit(),
          child: const EmailScreen(),
        ));
      case RouteManager.password:
        String userEmail = settings.arguments as String;
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (_) => SignUpCubit(),
          child: PasswordScreen(email: userEmail),
        ));
      case RouteManager.information:
        List<String?> userCredential = settings.arguments as List<String?>;
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (_) => SignUpCubit(),
          child: CreateProfile(userCredential: userCredential),
        ));
      case RouteManager.nav:
        return PageTransitionManager.materialPageRoute(MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => MapsCubit(),
            ),
            BlocProvider(
              create: (_) => LaunchUriCubit(),
            ),
          ],
          child: const NavbarScreen(),
        ));
      case RouteManager.chat:
        return PageTransitionManager.materialPageRoute(
          const ChatScreen(),
        );
      case RouteManager.voice:
        return PageTransitionManager.materialBottomToTopTransition(
          const VoiceChatScreen(),
        );
      case RouteManager.editProfile:
        return PageTransitionManager.materialSlideTransition(
          const EditProfileScreen(),
        );
      case RouteManager.oldPassword:
        return PageTransitionManager.materialSlideTransition(
          const OldPasswordScreen(),
        );
      case RouteManager.newPassword:
        return PageTransitionManager.fadeTransition(
          const NewPasswordScreen(),
        );
      case RouteManager.aboutUs:
        return PageTransitionManager.materialSlideTransition(
          const AboutUsScreen(),
        );
      case RouteManager.maps:
        return PageTransitionManager.fadeTransition(BlocProvider(
          create: (_) => MapsCubit(),
          child: const MapScreen(),
        ));
      case RouteManager.reAuthScreen:
        return PageTransitionManager.materialSlideTransition(
          const ReAuthScreen(),
        );
      case RouteManager.deleteAccount:
        return PageTransitionManager.fadeTransition(
            const DeleteAccountScreen());
      case RouteManager.termsAndConditions:
        return PageTransitionManager.materialSlideTransition(
          BlocProvider(
              create: (_) => LaunchUriCubit(),
              child: const TermsAndConditionsScreen()),
        );
      case RouteManager.privacyPolicy:
        return PageTransitionManager.materialSlideTransition(
          BlocProvider(
              create: (_) => LaunchUriCubit(),
              child: const PrivacyPolicyScreen()),
        );
      case RouteManager.appUpdates:
        return PageTransitionManager.materialSlideTransition(
            const AppUpdatesScreen());
      case RouteManager.appSocialMedia:
        return PageTransitionManager.materialSlideTransition(
            const SocialMediaScreen());
      case RouteManager.appFeedback:
        return PageTransitionManager.materialSlideTransition(
            const AppFeedbackScreen());
      default:
        return null;
    }
  }
}
