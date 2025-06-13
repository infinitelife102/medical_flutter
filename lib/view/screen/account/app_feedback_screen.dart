import 'package:dr_ai/core/utils/helper/scaffold_snakbar.dart';
import 'package:dr_ai/core/utils/helper/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import '../../../controller/feedback/feedback_cubit.dart';
import '../../../controller/feedback/feedback_state.dart';
import '../../../controller/validation/formvalidation_cubit.dart';
import '../../../core/utils/constant/image.dart';
import '../../../core/utils/theme/color.dart';
import '../../../core/utils/theme/fonts.dart';
import '../../widget/button_loading_indicator.dart';
import '../../widget/custom_button.dart';
import '../../widget/custom_text_field.dart';

class AppFeedbackScreen extends StatefulWidget {
  const AppFeedbackScreen({super.key});

  @override
  State<AppFeedbackScreen> createState() => _AppFeedbackScreenState();
}

class _AppFeedbackScreenState extends State<AppFeedbackScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _feedbackController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _selectedRating = 0;

  late AnimationController _animationController;
  late List<Animation<double>> _starAnimations;

  late final FeedbackCubit _feedbackCubit;
  late final ValidationCubit _validationCubit;

  @override
  void initState() {
    super.initState();
    _feedbackCubit = FeedbackCubit();
    _validationCubit = ValidationCubit();

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
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _feedbackController.dispose();
    _animationController.dispose();
    _feedbackCubit.close();
    _validationCubit.close();
    super.dispose();
  }

  void _updateRating(int rating) {
    if (_selectedRating != rating) {
      setState(() {
        _selectedRating = rating;
      });
      _animationController.reset();
      _animationController.forward();
      _feedbackCubit.updateRating(rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => _feedbackCubit),
        BlocProvider(create: (context) => _validationCubit),
      ],
      child: Scaffold(
        appBar: AppBar(title: Text("App Feedback")),
        backgroundColor: ColorManager.white,
        body: BlocConsumer<FeedbackCubit, FeedbackState>(
          listener: (context, state) {
            if (state is FeedbackSuccess) {
              _showSuccessDialog(context);
            } else if (state is FeedbackError) {
              _showErrorDialog(context, state.errorMessage);
            } else if (state is RatingUpdated) {
              setState(() {
                _selectedRating = state.rating;
              });
            }
          },
          builder: (context, state) {
            return Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 24.w),
                    physics: const BouncingScrollPhysics(),
                    child: Form(
                      key: _formKey,
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
                              "We value your feedback!",
                              style: TextStyle(
                                fontFamily: FontFamilyManager.poppins,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: ColorManager.green,
                              ),
                            ),
                          ),
                          Gap(8.h),
                          Center(
                            child: Text(
                              "Help us improve the DR.AI app by sharing your experience",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: FontFamilyManager.poppins,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400,
                                color: ColorManager.darkGrey,
                              ),
                            ),
                          ),
                          Gap(32.h),
                          _buildSectionTitle("Rate your experience"),
                          Gap(16.h),
                          _buildStarRatingSelector(),
                          Gap(24.h),
                          _buildSectionTitle("Your information"),
                          CustomTextFormField(
                            title: "Full Name",
                            controller: _nameController,
                            hintText: "Enter your full name",
                            validator: (value) =>
                                _validationCubit.nameValidator(value),
                          ),
                          CustomTextFormField(
                            title: "Email",
                            controller: _emailController,
                            hintText: "Enter your email address",
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                _validationCubit.validateEmail(value),
                          ),
                          Gap(24.h),
                          _buildSectionTitle("Your feedback"),
                          CustomTextFormField(
                            title: "Feedback",
                            controller: _feedbackController,
                            hintText:
                                "Tell us what you think about DR.AI Medical Assistant...",
                            maxLines: 5,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your feedback';
                              }
                              if (value.length < 10) {
                                return 'Feedback must be at least 10 characters';
                              }
                              return null;
                            },
                          ),
                          Gap(32.h),
                          CustomButton(
                            isDisabled: state is FeedbackLoading,
                            widget: state is FeedbackLoading == true
                                ? const ButtonLoadingIndicator()
                                : null,
                            title: "Submit",
                            onPressed: _submitFeedback,
                          ),
                          Gap(32.h),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: FontFamilyManager.poppins,
        fontSize: 16.sp,
        fontWeight: FontWeight.w600,
        color: ColorManager.dark,
      ),
    );
  }

  Widget _buildStarRatingSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => GestureDetector(
          onTap: () => _updateRating(index + 1),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w),
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.scale(
                  scale: _selectedRating > index
                      ? _starAnimations[index].value
                      : 1.0,
                  child: Icon(
                    index < _selectedRating
                        ? Icons.star_rounded
                        : Icons.star_border_rounded,
                    color: _selectedRating > index
                        ? ColorManager.amber
                        : ColorManager.grey,
                    size: 42.w,
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _submitFeedback() {
    if (_formKey.currentState!.validate()) {
      if (_selectedRating == 0) {
        customSnackBar(context, 'Please select a rating', ColorManager.error);
      }

      _feedbackCubit.submitFeedback(
        name: _nameController.text,
        email: _emailController.text,
        feedbackText: _feedbackController.text,
        rating: _selectedRating,
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    customDialog(
      context,
      title: "Thank you for your feedback!",
      subtitle:
          "Your feedback helps us improve the app. We appreciate your time!",
      buttonTitle: "Done",
      dismiss: false,
      image: ImageManager.trueIcon,
      onPressed: () {
        Navigator.pop(context);
        Navigator.pop(context);
      },
    );
  }

  void _showErrorDialog(BuildContext context, String errorMessage) {
    customDialog(
      context,
      title: "Error",
      subtitle: errorMessage,
      buttonTitle: "OK",
      image: ImageManager.facebookIcon,
      onPressed: () {
        Navigator.pop(context);
      },
    );
  }
}
