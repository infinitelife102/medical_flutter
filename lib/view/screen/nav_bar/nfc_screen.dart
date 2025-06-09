import 'package:dr_ai/core/utils/theme/color.dart';
import 'package:dr_ai/core/utils/constant/image.dart';
import 'package:dr_ai/core/utils/helper/extention.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class NFCScreen extends StatelessWidget {
  const NFCScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              ImageManager.nfcIcon,
              width: context.width / 2.5,
              height: context.width / 2.5,
              color: ColorManager.green,
            ),
            const Text(
              "NFC Screen",
            ),
          ],
        ),
      ),
    );
  }
}
