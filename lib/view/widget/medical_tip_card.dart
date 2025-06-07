import 'package:dr_ai/utils/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../logic/medical_tips/medical_tips_cubit.dart';
import '../../utils/constant/color.dart';

class MedicalTipCard extends StatefulWidget {
  const MedicalTipCard({
    super.key,
  });

  @override
  State<MedicalTipCard> createState() => _MedicalTipCardState();
}

class _MedicalTipCardState extends State<MedicalTipCard> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalTipsCubit>().fetchDailyTip();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: BlocBuilder<MedicalTipsCubit, MedicalTipsState>(
        builder: (context, state) {
          return _buildCard(state);
        },
      ),
    );
  }

  Widget _buildCard(MedicalTipsState state) {
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
              child: _buildContent(state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContent(MedicalTipsState state) {
    if (state is MedicalTipsLoading) {
      return Skeletonizer(
        enabled: true,
        effect: ShimmerEffect(
          baseColor: ColorManager.grey.withOpacity(0.2),
          highlightColor: ColorManager.grey.withOpacity(0.4),
        ),
        child: _buildTipContent(
          title: "عنوان النصيحة الطبية",
          content: "هذا هو محتوى النصيحة الطبية التي سيتم عرضها للمستخدم. النصيحة الطبية تحتوي على معلومات مهمة للحفاظ على صحتك.",
        ),
      );
    } else if (state is MedicalTipsError) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildHeader("Medical Tips"),
          const Gap(8),
          Text(
            "فشل في تحميل النصيحة الطبية. الرجاء المحاولة مرة أخرى لاحقًا.",
            style: context.textTheme.bodySmall?.copyWith(color: ColorManager.black),
          ),
        ],
      );
    } else if (state is MedicalTipsLoaded) {
      return _buildTipContent(
        title: state.medicalTip.title,
        content: state.medicalTip.content,
      );
    } else {
      return _buildTipContent(
        title: "Medical Tips",
        content: "ابق على اطلاع بأحدث النصائح الطبية والمشورة الصحية للحفاظ على نمط حياة صحي.",
      );
    }
  }

  Widget _buildTipContent({required String title, required String content}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildHeader(title),
        const Gap(8),
        Text(
          content,
          style: context.textTheme.bodySmall?.copyWith(color: ColorManager.black),
          maxLines: 10,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildHeader(String title) {
    return Row(
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
          child: Text(
            title,
            style: context.textTheme.displayLarge?.copyWith(
              fontSize: 16.sp,
            ),
          ),
        ),
      ],
    );
  }
}
