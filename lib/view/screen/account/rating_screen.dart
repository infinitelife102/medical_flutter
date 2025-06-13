import 'package:dr_ai/core/cache/cache.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:dr_ai/core/utils/helper/scaffold_snakbar.dart';
import 'package:dr_ai/controller/account/account_cubit.dart';
import 'package:dr_ai/view/widget/button_loading_indicator.dart';
import 'package:dr_ai/view/widget/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';

import '../../../core/utils/theme/color.dart';
import '../../../core/utils/constant/image.dart';

class RatingScreen extends StatefulWidget {
  const RatingScreen({super.key});

  @override
  RatingScreenState createState() => RatingScreenState();
}

class RatingScreenState extends State<RatingScreen>
    with SingleTickerProviderStateMixin {
  int _selectedRating = 0;
  bool _isloading = false;
  bool _isInitialized = false;

  late AnimationController _animationController;
  late List<Animation<double>> _starAnimations;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _starAnimations = List.generate(5, (index) {
      return Tween<double>(begin: 1.0, end: 1.3).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Interval(index * 0.1, index * 0.1 + 0.5,
              curve: Curves.elasticOut),
        ),
      );
    });

    final cachedRating = CacheData.getdata(key: "rating");
    if (cachedRating != null && cachedRating > 0) {
      Future.delayed(const Duration(milliseconds: 300), () {
        _updateRating(cachedRating, animateOnLoad: true);
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _updateRating(int rating, {bool animateOnLoad = false}) {
    if (_selectedRating != rating || animateOnLoad) {
      setState(() {
        _selectedRating = rating;
        _isInitialized = true;
      });
      _animationController.reset();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: REdgeInsets.all(16.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
      ),
      elevation: 0,
      backgroundColor: ColorManager.white,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 28.h),
        child: BlocProvider(
          create: (context) => AccountCubit(),
          child: BlocConsumer<AccountCubit, AccountState>(
            listener: (context, state) {
              if (state is AccountRatingResult) {
                _selectedRating = state.rating ?? 0;
              }
              if (state is AccountRatingLoading) {
                _isloading = true;
              }
              if (state is AccountRatingSuccess) {
                context.pop();
                _isloading = false;
                customSnackBar(
                    context, "Thank you for your feedback", ColorManager.green);
              }
              if (state is AccountRatingFailure) {
                _isloading = false;
                context.pop();
                customSnackBar(context, state.message, ColorManager.error);
              }
            },
            builder: (context, state) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    ImageManager.opinionIcon,
                    width: 125.w,
                    height: 125.w,
                  ),
                  Gap(12.h),
                  Text(
                    'Your opinion matters to us',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodyLarge
                        ?.copyWith(fontSize: 18.spMin),
                  ),
                  Gap(6.h),
                  Text(
                    'Please rate your experience with the app',
                    textAlign: TextAlign.center,
                    style: context.textTheme.bodySmall,
                  ),
                  Gap(12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      final starNumber = index + 1;
                      return GestureDetector(
                        onTap: () => _updateRating(starNumber),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          child: AnimatedBuilder(
                            animation: _animationController,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _selectedRating >= starNumber
                                    ? _starAnimations[index].value
                                    : 1.0,
                                child: Icon(
                                  _selectedRating >= starNumber
                                      ? Icons.star_rounded
                                      : Icons.star_border_rounded,
                                  color: _selectedRating >= starNumber
                                      ? ColorManager.amber
                                      : ColorManager.grey,
                                  size: 45.r,
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }),
                  ),
                  Gap(24.h),
                  CustomButton(
                    isDisabled: _isloading,
                    widget: _isloading ? const ButtonLoadingIndicator() : null,
                    title: 'Submit',
                    onPressed: () {
                      if (_selectedRating == CacheData.getdata(key: "rating")) {
                        context.pop();
                      } else {
                        context
                            .bloc<AccountCubit>()
                            .storeUserRating(_selectedRating);
                      }
                    },
                  ),
                  Gap(13.h),
                  CustomButton(
                    backgroundColor: ColorManager.error,
                    title: 'Cancel',
                    onPressed: () => context.pop(),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
