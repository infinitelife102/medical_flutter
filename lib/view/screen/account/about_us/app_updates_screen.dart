import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../../core/utils/constant/image.dart';
import '../../../../core/utils/theme/color.dart';
import '../../../../core/utils/theme/fonts.dart';

class AppUpdatesScreen extends StatelessWidget {
  const AppUpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Updates"),
      ),
      backgroundColor: ColorManager.white,
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              physics: const BouncingScrollPhysics(),
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
                  _buildCurrentVersion(),
                  Gap(24.h),
                  _buildSectionTitle("What's New"),
                  Gap(16.h),
                  _buildUpdateItem(
                    version: "3.2.0",
                    date: "June 14, 2025",
                    changes: [
                      "Completed all NFC features implementation",
                      "Enhanced Google Maps Performance",
                      "UI improvements across the application",
                      "Fixed all reported issues and bugs",
                      "Overall performance optimization"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "3.1.0",
                    date: "June 13, 2025",
                    changes: [
                      "Enhanced NFC reading capabilities for medical records",
                      "Improved UI/UX for easier navigation",
                      "Added voice chat with AI medical assistant",
                      "Updated Terms & Conditions and Privacy Policy",
                      "Fixed bugs and enhanced overall performance"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "3.0.0",
                    date: "April 25, 2025",
                    changes: [
                      "Added Medical Records system integration",
                      "Implemented NFC technology for medical ID cards",
                      "Enhanced data security and HIPAA compliance",
                      "Improved patient profile management",
                      "Added medical history tracking features"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "2.5.0",
                    date: "March 8, 2025",
                    changes: [
                      "Integrated Google Maps for hospital navigation",
                      "Added nearby hospitals and emergency facilities locator",
                      "Implemented route planning to medical facilities",
                      "Added ambulance service request feature",
                      "Improved emergency response system"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "2.0.0",
                    date: "January 12, 2025",
                    changes: [
                      "Complete UI/UX redesign for better user experience",
                      "Added comprehensive user profile creation",
                      "Enhanced medical condition tracking",
                      "Improved accessibility features",
                      "Added multilingual support"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "1.5.0",
                    date: "December 3, 2024",
                    changes: [
                      "Added authentication system with secure login",
                      "Implemented database for storing patient information",
                      "Enhanced chat system with medical knowledge base",
                      "Added symptom tracking feature",
                      "Improved data synchronization between devices"
                    ],
                  ),
                  _buildDivider(),
                  _buildUpdateItem(
                    version: "1.0.0",
                    date: "October 15, 2024",
                    changes: [
                      "Initial release with AI medical chat assistant",
                      "Basic medical consultation features",
                      "Simple symptom analysis",
                      "Health tips and recommendations"
                    ],
                  ),
                  Gap(32.h),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentVersion() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 24.w),
      decoration: BoxDecoration(
        color: ColorManager.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: ColorManager.green.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Current Version",
            style: TextStyle(
              fontFamily: FontFamilyManager.poppins,
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.dark,
            ),
          ),
          Gap(8.h),
          Text(
            "3.2.0",
            style: TextStyle(
              fontFamily: FontFamilyManager.poppins,
              fontSize: 24.sp,
              fontWeight: FontWeight.w600,
              color: ColorManager.green,
            ),
          ),
          Gap(8.h),
          Text(
            "Your app is up to date",
            style: TextStyle(
              fontFamily: FontFamilyManager.poppins,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: ColorManager.darkGrey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: FontFamilyManager.poppins,
        fontSize: 18.sp,
        fontWeight: FontWeight.w600,
        color: ColorManager.dark,
      ),
    );
  }

  Widget _buildUpdateItem({
    required String version,
    required String date,
    required List<String> changes,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Version $version',
              style: TextStyle(
                fontFamily: FontFamilyManager.poppins,
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: ColorManager.green,
              ),
            ),
            const Spacer(),
            Text(
              date,
              style: TextStyle(
                fontFamily: FontFamilyManager.poppins,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: ColorManager.darkGrey,
              ),
            ),
          ],
        ),
        Gap(12.h),
        ...changes.map((change) => _buildChangeItem(change)).toList(),
        Gap(16.h),
      ],
    );
  }

  Widget _buildChangeItem(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 6.h, right: 8.w),
            width: 6.w,
            height: 6.w,
            decoration: BoxDecoration(
              color: ColorManager.dark,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: FontFamilyManager.poppins,
                fontSize: 14.sp,
                color: ColorManager.dark,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Divider(
        color: ColorManager.grey.withOpacity(0.5),
        thickness: 1.h,
      ),
    );
  }
}
