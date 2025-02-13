import 'dart:math';

import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:b2b_multistep_onboarding/constants/asset_constant.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ShowAnimations {
  Widget success(BuildContext context) {
    return Lottie.asset(
      AssetConstants.animatedSuccess,
      repeat: false,
      reverse: true,
      width: 100,
      height: 150,
    );
  }

  Widget profileImgBG1(BuildContext context) {
    return Lottie.asset(
      AssetConstants.profileImgBG1,
      repeat: true,
      reverse: true,
      width: 200,
      height: 200,
    );
  }

  Widget profileImgBG2(BuildContext context) {
    return Lottie.asset(
      AssetConstants.profileImgBG2,
      repeat: true,
      reverse: true,
      width: 250,
      height: 250,
    );
  }

  Widget profileImgBG3(BuildContext context) {
    return Lottie.asset(
      AssetConstants.profileImgBG3,
      repeat: true,
      reverse: true,
      width: 250,
      height: 250,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**'],
            value: ColorFile.green300,
          ),
        ],
      ),
    );
  }

  Widget profileImgBG4(BuildContext context) {
    return Lottie.asset(
      AssetConstants.profileImgBG4,
      repeat: true,
      reverse: true,
      width: 250,
      height: 250,
    );
  }

  Widget arrowNext(BuildContext context) {
    return Lottie.asset(
      AssetConstants.arrowNext,
      repeat: true,
      height: 40,
      delegates: LottieDelegates(
        values: [
          ValueDelegate.color(
            const ['**'],
            value: ColorFile.green300,
          ),
        ],
      ),
    );
  }

  Widget arrowDown(BuildContext context) {
    return Transform.rotate(
      angle: -pi * .5,
      child: Lottie.asset(
        AssetConstants.arrowDown,
        repeat: true,
        height: 40,
        delegates: LottieDelegates(
          values: [
            ValueDelegate.color(
              const ['**'],
              value: ColorFile.green300,
            ),
          ],
        ),
      ),
    );
  }
}
