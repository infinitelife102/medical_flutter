import 'package:dr_ai/utils/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import '../../utils/constant/color.dart';

class MedicalTipCard extends StatelessWidget {
  final String title;
  final String description;
  final bool isArabic;

  const MedicalTipCard({
    Key? key,
    required this.title,
    required this.description,
    required this.isArabic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: ColorManager.grey.withOpacity(0.3), width: 0.5),
      ),
      color: ColorManager.white.withOpacity(0.9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: ColorManager.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Icon(
                          Icons.medical_services,
                          color: ColorManager.green,
                          size: 20,
                        ),
                      ),
                      const Gap(8),
                      Expanded(
                          child: Text(title,
                              style: context.textTheme.displayLarge?.copyWith(
                                fontSize: 16.sp,
                              ))),
                    ],
                  ),
                  const Gap(8),
                  Text(
                    description,
                    style: context.textTheme.bodySmall
                        ?.copyWith(color: ColorManager.black),
                    maxLines: 10,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
