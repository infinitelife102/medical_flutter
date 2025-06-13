import 'package:dr_ai/core/utils/constant/image.dart';
import 'package:dr_ai/core/utils/theme/color.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LockerWidget extends StatelessWidget {
  final bool isLocked;
  final Widget child;
  final Color? overlayColor;
  final double? opacity;
  final String? message;
  final Widget? customIcon;
  final String? svgIconPath;

  const LockerWidget({
    super.key,
    required this.isLocked,
    required this.child,
    this.overlayColor,
    this.opacity,
    this.message,
    this.customIcon,
    this.svgIconPath,
  });

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLocked,
      color: overlayColor ?? ColorManager.black.withOpacity(0.5),
      opacity: opacity ?? 0.8,
      progressIndicator: Container(
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: ColorManager.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (customIcon != null)
              customIcon!
            else if (svgIconPath != null)
              SizedBox(
                  height: 60.w,
                  width: 60.w,
                  child: SvgPicture.asset(svgIconPath!))
            else
              SvgPicture.asset(ImageManager.splashLogo),
            Gap(10.h),
            Text(
              "Screen Locked",
              style: context.textTheme.bodyMedium?.copyWith(
                color: ColorManager.green,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (message != null || message?.isNotEmpty == true)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: context.textTheme.bodySmall?.copyWith(
                    color: ColorManager.grey,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
          ],
        ),
      ),
      child: child,
    );
  }
}
