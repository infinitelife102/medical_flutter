import 'package:dr_ai/core/utils/theme/color.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:flutter/material.dart';

void customSnackBar(BuildContext context,
    [String? message, Color? color, int? seconds]) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: Duration(seconds: seconds ?? 3),
      backgroundColor: (color ?? ColorManager.green).withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      content: Center(
        child: Text(
          message ?? "there was an error please try again later!",
          style:
              context.textTheme.bodySmall?.copyWith(color: ColorManager.white),
        ),
      )));
}

void downloadProgressSnackBar(BuildContext context, double progress,
    {String? message, Color? color, bool isDone = false}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      duration: isDone ? const Duration(seconds: 3) : const Duration(days: 1),
      backgroundColor: (color ?? ColorManager.green).withOpacity(0.9),
      behavior: SnackBarBehavior.floating,
      content: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  message ?? "Downloading PDF...",
                  style: context.textTheme.bodySmall?.copyWith(color: ColorManager.white),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: AlwaysStoppedAnimation<Color>(ColorManager.white),
                ),
                const SizedBox(height: 4),
                Text(
                  "${(progress * 100).toStringAsFixed(0)}%",
                  style: context.textTheme.bodySmall?.copyWith(color: ColorManager.white),
                ),
              ],
            ),
          ),
          if (isDone)
            Icon(
              Icons.check_circle,
              color: ColorManager.white,
            ),
        ],
      ),
    ),
  );
}
