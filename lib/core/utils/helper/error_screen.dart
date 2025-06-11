import 'package:dr_ai/core/utils/constant/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../view/widget/custom_button.dart';
import '../theme/color.dart';

class CustomErrorScreen extends StatefulWidget {
  final String errorMessage;
  final String stackTrace;

  const CustomErrorScreen({
    super.key,
    required this.errorMessage,
    required this.stackTrace,
  });

  @override
  State<CustomErrorScreen> createState() => _CustomErrorScreenState();
}

class _CustomErrorScreenState extends State<CustomErrorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: ColorManager.green.withOpacity(0.1),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  ImageManager.splashLogo,
                  height: 100,
                ),
                const SizedBox(height: 24),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _animation.value),
                      child: child,
                    );
                  },
                  child: Icon(
                    Icons.error_outline,
                    size: 60,
                    color: ColorManager.green,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: ColorManager.green,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  widget.errorMessage,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: ColorManager.darkGrey,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
                // Using CustomButton instead of ElevatedButton
                CustomButton(
                  title: 'Try Again',
                  backgroundColor: ColorManager.green,
                  onPressed: () => Navigator.of(context).pop(),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    // Show detailed error in debug mode
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Error Details'),
                        titleTextStyle: TextStyle(
                          color: ColorManager.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                        content: SingleChildScrollView(
                          child: Text(widget.stackTrace),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                color: ColorManager.green,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  child: Text(
                    'View Details',
                    style: TextStyle(
                      color: ColorManager.green,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
