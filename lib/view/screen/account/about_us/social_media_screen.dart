import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../controller/launch_uri/launch_uri_cubit.dart';
import '../../../../core/utils/constant/image.dart';
import '../../../../core/utils/theme/color.dart';
import '../../../../core/utils/theme/fonts.dart';


class SocialMediaScreen extends StatelessWidget {
  const SocialMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Social Media"),
      ),
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Gap(32.h),
                    Center(
                      child: SvgPicture.asset(
                        ImageManager.splashLogo,
                        width: 50.w,
                        height: 50.h,
                      ),
                    ),
                    Gap(24.h),
                    Center(
                      child: Text(
                        "Connect with us",
                        style: TextStyle(
                          fontFamily: FontFamilyManager.poppins,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: ColorManager.green,
                        ),
                      ),
                    ),
                    Gap(6.h),
                    Center(
                      child: Text(
                        "Follow our social media accounts for updates, tips, and more!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: FontFamilyManager.poppins,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                          color: ColorManager.darkGrey,
                        ),
                      ),
                    ),
                    Gap(30.h),
                    _buildSocialMediaItem(
                      context: context,
                      title: "Facebook",
                      subtitle: "@draihealthcare",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/5968/5968764.png",
                      onTap: () => _openPlatformLink(
                          context, "https://www.facebook.com/draihealthcare"),
                    ),
                    _buildDivider(),
                    _buildSocialMediaItem(
                      context: context,
                      title: "Instagram",
                      subtitle: "@drai_healthcare",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/174/174855.png",
                      onTap: () => _openPlatformLink(
                          context, "https://www.instagram.com/drai_healthcare"),
                    ),
                    _buildDivider(),
                    _buildSocialMediaItem(
                      context: context,
                      title: "X",
                      subtitle: "@DrAI_Healthcare",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/5969/5969020.png",
                      onTap: () => _openPlatformLink(
                          context, "https://twitter.com/DrAI_Healthcare"),
                    ),
                    _buildDivider(),
                    _buildSocialMediaItem(
                      context: context,
                      title: "LinkedIn",
                      subtitle: "Dr. AI Medical Solutions",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/174/174857.png",
                      onTap: () => _openPlatformLink(context,
                          "https://www.linkedin.com/company/drai-medical"),
                    ),
                    _buildDivider(),
                    _buildSocialMediaItem(
                      context: context,
                      title: "YouTube",
                      subtitle: "DR.AI Healthcare Channel",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/174/174883.png",
                      onTap: () => _openPlatformLink(context,
                          "https://www.youtube.com/channel/draihealthcare"),
                    ),
                    _buildDivider(),
                    _buildSocialMediaItem(
                      context: context,
                      title: "Website",
                      subtitle: "www.draihealthcare.com",
                      iconUrl:
                          "https://cdn-icons-png.flaticon.com/512/2301/2301129.png",
                      onTap: () => _openPlatformLink(
                          context, "https://www.draihealthcare.com"),
                    ),
                    Gap(16.h),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openPlatformLink(BuildContext context, String url) {
    try {
      context.read<LaunchUriCubit>().openLink(url: url);
    } catch (e) {
      final Uri uri = Uri.parse(url);
      launchUrl(uri, mode: LaunchMode.externalApplication).catchError((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open $url')),
        );
      });
    }
  }

  Widget _buildSocialMediaItem({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String iconUrl,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Row(
          children: [
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: ColorManager.white,
                borderRadius: BorderRadius.circular(10.r),
                boxShadow: [
                  BoxShadow(
                    color: ColorManager.darkGrey.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Center(
                child: Image.network(
                  iconUrl,
                  width: 22.w,
                  height: 22.h,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.link,
                      size: 22.w,
                      color: ColorManager.darkGrey,
                    );
                  },
                ),
              ),
            ),
            Gap(12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: FontFamilyManager.poppins,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: ColorManager.dark,
                    ),
                  ),
                  Gap(2.h),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: FontFamilyManager.poppins,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      color: ColorManager.darkGrey,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: ColorManager.darkGrey,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      color: ColorManager.grey.withOpacity(0.3),
      thickness: 0.8.h,
    );
  }
}
