import 'package:flutter/material.dart';
import 'package:dr_ai/core/utils/theme/color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:gap/gap.dart';

class DownloadDialog extends StatelessWidget {
  final double progress;
  final String message;
  final bool isDone;
  final VoidCallback? onOpen;
  final VoidCallback? onCancel;

  const DownloadDialog({
    super.key,
    required this.progress,
    required this.message,
    this.isDone = false,
    this.onOpen,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: REdgeInsets.all(18),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
      backgroundColor: ColorManager.white,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 18),
        decoration: BoxDecoration(
          color: ColorManager.white,
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              isDone ? 'Download Complete' : 'Downloading...',
              style: context.textTheme.bodyLarge?.copyWith(
                fontSize: 18.spMin,
                height: 0.9.h,
                color: ColorManager.green,
              ),
            ),
            Gap(8.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: context.textTheme.bodySmall,
            ),
            Gap(20.h),
            LinearProgressIndicator(
              value: isDone ? 1.0 : progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(ColorManager.green),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            Gap(8.h),
            Text(
              '${(progress * 100).toStringAsFixed(0)}%',
              style: context.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Gap(22.h),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: 8,
              runSpacing: 10,
              children: [
                if (!isDone)
                  TextButton(
                    onPressed: onCancel,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.grey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Cancel',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                  )
                else
                  ElevatedButton(
                    onPressed: onOpen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorManager.green,
                      foregroundColor: Colors.white,
                      padding:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.open_in_new, size: 16.w),
                        SizedBox(width: 8.w),
                        Text('Open'),
                      ],
                    ),
                  ),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isDone ? Colors.grey[300] : ColorManager.green,
                    foregroundColor: isDone ? Colors.black87 : Colors.white,
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                  ),
                  child: Text(isDone ? 'Close' : 'Background'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DownloadProgressDialog extends StatefulWidget {
  final String initialMessage;
  final Function(Function(double progress, String message, bool isDone))
      onControllerReady;
  final VoidCallback? onCancel;
  final VoidCallback? onOpen;

  const DownloadProgressDialog({
    super.key,
    required this.initialMessage,
    required this.onControllerReady,
    this.onCancel,
    this.onOpen,
  });

  @override
  State<DownloadProgressDialog> createState() => _DownloadProgressDialogState();
}

class _DownloadProgressDialogState extends State<DownloadProgressDialog> {
  double _progress = 0.0;
  String _message = '';
  bool _isDone = false;

  @override
  void initState() {
    super.initState();
    _message = widget.initialMessage;
    widget.onControllerReady((progress, message, isDone) {
      if (mounted) {
        setState(() {
          _progress = progress;
          _message = message;
          _isDone = isDone;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DownloadDialog(
      progress: _progress,
      message: _message,
      isDone: _isDone,
      onCancel: widget.onCancel,
      onOpen: _isDone ? widget.onOpen : null,
    );
  }
}

void showDownloadProgressDialog({
  required BuildContext context,
  required String initialMessage,
  required Function(Function(double progress, String message, bool isDone))
      onControllerReady,
  VoidCallback? onCancel,
  VoidCallback? onOpen,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return DownloadProgressDialog(
        initialMessage: initialMessage,
        onControllerReady: onControllerReady,
        onCancel: onCancel,
        onOpen: onOpen,
      );
    },
  );
}
