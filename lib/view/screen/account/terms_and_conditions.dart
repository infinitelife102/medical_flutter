import 'package:dr_ai/core/utils/theme/fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../controller/launch_uri/launch_uri_cubit.dart';
import '../../../core/utils/constant/image.dart';
import '../../../core/utils/theme/color.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms and Conditions'),
      ),
      backgroundColor: ColorManager.white,
      body: SingleChildScrollView(
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
            Gap(15.h),
            _buildSectionTitle(
                'Terms & Conditions for DR.AI Medical Assistant'),
            _buildLastUpdated('Last Updated: June 7, 2025'),
            Gap(16.h),
            _buildParagraph(
                'Please read these Terms and Conditions carefully before using the DR.AI application.'),
            _buildParagraph(
                'By accessing or using the App, you agree to be bound by these Terms. If you do not agree to any part of these Terms, you may not access or use the App.'),
            Gap(24.h),
            _buildSectionHeader('1. Description of Service'),
            _buildParagraph(
                'The DR.AI App is an AI-powered mobile healthcare platform designed to assist users in accessing general health information, locating nearby hospitals, and managing personal medical records via NFC technology. The App includes an AI-powered chat feature to provide preliminary medical consultations and general health advice.'),
            Gap(16.h),
            _buildHighlightedSection('Important Medical Disclaimer:'),
            _buildParagraph(
                'The information provided through the DR.AI App, including AI-generated consultations, is for general informational and educational purposes only. It is not and should not be considered a substitute for professional medical advice, diagnosis, or treatment from a qualified physician or healthcare professional.'),
            _buildParagraph(
                'You should not disregard professional medical advice or delay seeking it because of anything you have read or received through the App.'),
            _buildParagraph(
                'In medical emergencies, contact your local emergency services immediately.'),
            Gap(24.h),
            _buildSectionHeader('2. User Accounts'),
            _buildParagraph(
                'To access certain features of the App, you may be required to create an account. You are responsible for maintaining the confidentiality of your account information and password, and for all activities that occur under your account. You must provide us with accurate, complete, and up-to-date information.'),
            Gap(24.h),
            _buildSectionHeader('3. Permitted and Prohibited Use'),
            _buildSubheader('Permitted Use:'),
            _buildBulletPoint(
                'Using the App for its intended purpose: personal health assistance, hospital location, and managing your private medical records.'),
            _buildBulletPoint(
                'Complying with all applicable laws and regulations.'),
            Gap(12.h),
            _buildSubheader('Prohibited Use:'),
            _buildBulletPoint(
                'Using the App for any unlawful, fraudulent, or unauthorized purpose.'),
            _buildBulletPoint(
                'Attempting unauthorized access to any part of the App or our systems.'),
            _buildBulletPoint('Providing false or misleading information.'),
            _buildBulletPoint(
                'Using the App to diagnose or treat others, or to promote false medical information.'),
            _buildBulletPoint(
                'Reproducing, duplicating, selling, or reselling any part of the App without express permission.'),
            Gap(24.h),
            _buildSectionHeader('4. Intellectual Property'),
            _buildParagraph(
                'The App, its original content, features, and functionality are and will remain the exclusive property of DR-AI and are protected by copyright, trademark, and other intellectual property laws. You may not use our name, trademarks, or any part of the App\'s content without prior written consent.'),
            Gap(24.h),
            _buildSectionHeader('5. Disclaimer'),
            _buildParagraph(
                'The App is provided on an "AS IS" and "AS AVAILABLE" basis, without any warranties of any kind, either express or implied. We do not warrant that the App will be uninterrupted, secure, error-free, or that the information provided will be entirely accurate or up-to-date at all times. You assume full responsibility for any risks associated with your use of the App.'),
            Gap(24.h),
            _buildSectionHeader('6. Limitation of Liability'),
            _buildParagraph(
                'To the maximum extent permitted by law, we shall not be liable for any indirect, incidental, special, consequential, or punitive damages, or any loss of profits or revenues, whether incurred directly or indirectly, or any loss of data, use, goodwill, or other intangible losses, resulting from (a) your access to or use of or inability to access or use the App; (b) any conduct or content of any third party on the App; (c) any content obtained from the App; and (d) unauthorized access, use, or alteration of your transmissions or content.'),
            Gap(24.h),
            _buildSectionHeader('7. Changes to the Terms and Conditions'),
            _buildParagraph(
                'We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will make reasonable efforts to provide prior notice before any material changes take effect. Your continued access or use of the App after such changes become effective signifies your agreement to the revised Terms.'),
            Gap(24.h),
            _buildSectionHeader('8. Governing Law'),
            _buildParagraph(
                'These Terms shall be governed and construed in accordance with the laws of Egypt, without regard to its conflict of law provisions.'),
            Gap(24.h),
            _buildSectionHeader('9. Contact Information'),
            _buildParagraph(
                'If you have any questions about these Terms and Conditions, please contact us at:'),
            _buildEmailLink(context, 'mahmoudelsayed.test@gmail.com'),
            Gap(32.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: FontFamilyManager.poppins,
          fontSize: 20.sp,
          fontWeight: FontWeight.w600,
          color: ColorManager.green,
        ),
      ),
    );
  }

  Widget _buildLastUpdated(String text) {
    return SelectableText(
      text,
      style: TextStyle(
        fontFamily: FontFamilyManager.poppins,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: ColorManager.darkGrey,
        fontStyle: FontStyle.italic,
      ),
    );
  }

  Widget _buildSectionHeader(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: FontFamilyManager.poppins,
          fontSize: 17.sp,
          fontWeight: FontWeight.w600,
          color: ColorManager.dark,
        ),
      ),
    );
  }

  Widget _buildSubheader(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: FontFamilyManager.poppins,
          fontSize: 15.sp,
          fontWeight: FontWeight.w500,
          color: ColorManager.darkBlue,
        ),
      ),
    );
  }

  Widget _buildHighlightedSection(String text) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: ColorManager.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border:
            Border.all(color: ColorManager.green.withOpacity(0.3), width: 1),
      ),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: FontFamilyManager.poppins,
          fontSize: 15.sp,
          fontWeight: FontWeight.w600,
          color: ColorManager.green,
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: SelectableText(
        text,
        style: TextStyle(
          fontFamily: FontFamilyManager.poppins,
          fontSize: 14.sp,
          color: ColorManager.dark,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: EdgeInsets.only(left: 16.w, bottom: 8.h),
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
            child: SelectableText(
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

  Widget _buildEmailLink(BuildContext context, String email) {
    return BlocListener<LaunchUriCubit, LaunchUriState>(
      listener: (context, state) {},
      child: Padding(
        padding: EdgeInsets.only(bottom: 12.h),
        child: InkWell(
          onTap: () => context.read<LaunchUriCubit>().openEmailApp(
                email: email,
                subject: "Terms and Conditions Inquiry",
                body: "I have a question regarding the Terms and Conditions.",
              ),
          child: Text(
            'Email: $email',
            style: TextStyle(
                fontFamily: FontFamilyManager.poppins,
                fontSize: 14.sp,
                color: Colors.blue,
                height: 1.5,
                decoration: TextDecoration.underline,
                decorationColor: Colors.blue),
          ),
        ),
      ),
    );
  }
}
