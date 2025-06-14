import 'package:dr_ai/core/router/routes.dart';
import 'package:dr_ai/core/utils/helper/custom_dialog.dart';
import 'package:dr_ai/core/utils/helper/error_screen.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:dr_ai/view/screen/account/app_feedback_screen.dart';
import 'package:dr_ai/view/screen/account/app_updates_screen.dart';
import 'package:dr_ai/view/screen/account/social_media_screen.dart';
import 'package:dr_ai/view/widget/custom_scrollable_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../../core/utils/theme/color.dart';
import '../../../core/utils/constant/image.dart';
import '../../widget/build_profile_card.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final divider = Divider(color: ColorManager.grey, thickness: 1.w);
    return Scaffold(
      body: Column(
        children: [
          Gap(32.h),
          const CustomTitleBackButton(
            title: "About Us",
          ),
          Gap(32.h),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Column(
              children: [
                BuildProfileCard(
                  title: "App Updates",
                  image: ImageManager.updateIcon,
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteManager.appUpdates),
                ),
                divider,
                BuildProfileCard(
                  title: "App Feedback",
                  image: ImageManager.feedbackIcon,
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteManager.appFeedback),
                ),
                divider,
                BuildProfileCard(
                  title: "Social Media",
                  image: ImageManager.socialMediaIcon,
                  onPressed: () =>
                      Navigator.pushNamed(context, RouteManager.appSocialMedia),
                ),
                divider,
                BuildProfileCard(
                    removeColorIcon: true,
                    title: "Support",
                    image: ImageManager.splashLogo,
                    onPressed: () => context.push(CustomErrorScreen(
                        errorMessage: "Support is currently unavailable",
                        stackTrace:
                            "This is a test designed to simulate a production exception"))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
