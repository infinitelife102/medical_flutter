import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import '../../../controller/launch_uri/launch_uri_cubit.dart';
import '../../../core/utils/constant/image.dart';
import '../../../core/utils/theme/color.dart';
import '../../../core/utils/theme/fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
            _buildSectionTitle('Privacy Policy for DR.AI Medical Assistant'),
            _buildLastUpdated('Last Updated: June 7, 2025'),
            Gap(16.h),
            _buildParagraph(
                'This Privacy Policy explains how DR-AI collects, uses, stores, and discloses information gathered from users of the DR.AI application. We are committed to protecting your privacy and handling your personal and sensitive health data responsibly and transparently.'),
            Gap(24.h),
            _buildSectionHeader('1. Information We Collect'),
            _buildParagraph(
                'We collect various types of information to provide and improve our services:'),
            Gap(12.h),
            _buildSubheader('Personal Information You Provide:'),
            _buildBulletPoint(
                'Identity Information: Your full name, date of birth, gender, login credentials (email and password).'),
            _buildBulletPoint(
                'Contact Information: Your phone number and email address.'),
            _buildBulletPoint(
                'Health Profile Information: Blood type, height, weight, chronic diseases, general medical history that you input or upload into the App.'),
            _buildBulletPoint(
                'Emergency Contact Data: Names and phone numbers of close contacts (e.g., father, son) that you designate for emergency purposes.'),
            Gap(12.h),
            _buildSubheader('Sensitive Health Data:'),
            _buildBulletPoint(
                'Medical Records: Detailed medical history that you may store in the App.'),
            _buildBulletPoint(
                'NFC Data: Basic health information (such as blood type, allergies, chronic diseases) stored on your NFC chip, which can be read by the App.'),
            _buildBulletPoint(
                'AI-Generated Diagnoses: Outputs from the AI based on your inquiries and symptoms.'),
            Gap(12.h),
            _buildSubheader('Usage Data:'),
            _buildBulletPoint(
                'Information about how you access and use the App (e.g., features used, pages visited, time spent in the App, interactions with the chatbot).'),
            _buildBulletPoint(
                'Device information (e.g., device type, operating system, unique device identifiers, IP address).'),
            Gap(12.h),
            _buildSubheader('Location Data:'),
            _buildBulletPoint(
                'To provide the nearest hospitals feature, we may collect your precise geographical location data when granted permission.'),
            Gap(24.h),
            _buildSectionHeader('2. How We Use Your Information'),
            _buildParagraph(
                'We use the information we collect for the following purposes:'),
            _buildBulletPoint(
                'To Provide and Operate DR.AI Services: To manage your account, provide AI consultations, locate hospitals, and manage your medical records.'),
            _buildBulletPoint(
                'To Improve and Customize the App: To understand how users interact with the App and enhance features and functionalities, and to personalize your experience (typically using aggregated or anonymized data).'),
            _buildBulletPoint(
                'To Communicate with You: To send updates, health alerts, reminders, or important service-related notifications.'),
            _buildBulletPoint(
                'For Security and Fraud Prevention: To protect the security of the App and users, and to detect and prevent fraudulent or unauthorized activities.'),
            _buildBulletPoint(
                'For Analytics and Statistics: To perform internal analyses regarding App usage and performance (typically done using anonymized or aggregated data).'),
            _buildBulletPoint(
                'To Improve the AI Model: We may use data (in an anonymized or aggregated form) to enhance the performance and accuracy of our AI model in providing medical consultations.'),
            _buildBulletPoint(
                'For NFC Service: To enable the storage and reading of essential health information on your NFC chip for quick access in emergencies.'),
            Gap(24.h),
            _buildSectionHeader('3. How We Share Your Information'),
            _buildParagraph(
                'We do not sell your personal information. We may share your information under the following circumstances:'),
            _buildBulletPoint(
                'With Service Providers: With third-party companies that help us operate the App and provide services (e.g., hosting providers, Firebase services, map service providers, AI API providers). These providers are committed to protecting your data under confidentiality agreements.'),
            _buildBulletPoint(
                'With Hospitals and Doctors: Your medical records or emergency data may be shared with hospitals or doctors only when necessary for providing medical care, or upon obtaining your explicit consent, or as required by legal obligations.'),
            _buildBulletPoint(
                'For Legal Purposes: If required by law or in response to a court order or other legal process, or to protect our rights or property.'),
            _buildParagraph(
                'NFC Data: Please be aware that information stored on your NFC chip may be readable by NFC-compatible devices without internet connection, and may not be encrypted with the same strength as cloud-stored data. You are responsible for understanding and protecting this data.'),
            Gap(24.h),
            _buildSectionHeader('4. Data Security'),
            _buildParagraph(
                'We implement reasonable security measures to protect your personal and health information from unauthorized access, alteration, disclosure, or destruction. These measures include encryption, firewalls, and access controls. However, no system is 100% secure, and we cannot guarantee the absolute security of your data.'),
            Gap(24.h),
            _buildSectionHeader('5. Your Data Rights'),
            _buildParagraph(
                'You have certain rights regarding your personal information, including the right to:'),
            _buildBulletPoint('Access your personal data that we hold.'),
            _buildBulletPoint(
                'Request correction of any inaccurate information.'),
            _buildBulletPoint(
                'Request deletion of your personal data (right to be forgotten), subject to legal obligations.'),
            _buildBulletPoint(
                'Withdraw your consent to data processing (where applicable).'),
            Gap(24.h),
            _buildSectionHeader('6. Data Retention'),
            _buildParagraph(
                'We will retain your personal information for as long as necessary to fulfill the purposes outlined in this Privacy Policy or to comply with our legal obligations.'),
            Gap(24.h),
            _buildSectionHeader('7. Changes to the Privacy Policy'),
            _buildParagraph(
                'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on this page. You are advised to review this Privacy Policy periodically for any changes.'),
            Gap(24.h),
            _buildSectionHeader('8. Contact Information'),
            _buildParagraph(
                'If you have any questions about this Privacy Policy, please contact us at:'),
            _buildEmailLink(context, 'draibrain.team@gmail.com'),
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
        child: Wrap(
          children: [
            Text(
              'Email: ',
              style: TextStyle(
                fontFamily: FontFamilyManager.poppins,
                fontSize: 14.sp,
                color: ColorManager.dark,
                height: 1.5,
              ),
            ),
            InkWell(
              onTap: () => context.read<LaunchUriCubit>().openEmailApp(
                    email: email,
                    subject: 'Privacy Policy Inquiry',
                    body: 'I have a question regarding the privacy policy.',
                  ),
              child: Text(
                email,
                style: TextStyle(
                  fontFamily: FontFamilyManager.poppins,
                  fontSize: 14.sp,
                  color: Colors.blue,
                  height: 1.5,
                  decoration: TextDecoration.underline,
                  decorationColor: Colors.blue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
