import 'package:b2b_multistep_onboarding/constants/asset_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowAnimations extends StatelessWidget {
  const ShowAnimations({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Lottie.asset(
          AssetConstants.animatedSuccess,
          repeat: false,
          reverse: true,
          width: 100,
          height: 150,
        ),
      ],
    );
  }
}
