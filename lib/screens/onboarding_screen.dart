import 'package:b2b_multistep_onboarding/widgets/app_components.dart';
import 'package:b2b_multistep_onboarding/config/app_color.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:b2b_multistep_onboarding/controllers/onboarding_controller.dart';
import 'package:b2b_multistep_onboarding/screens/dashboard_screen.dart';
import 'package:easy_stepper/easy_stepper.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());

  OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Onboarding',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          _buildStepper(),
          SizedBox(height: 10),
          _buildStepContent(),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildStepper() {
    return Obx(
      () => EasyStepper(
        activeStep: controller.currentStep.value,
        stepShape: StepShape.rRectangle,
        stepBorderRadius: 20,
        borderThickness: 2,
        stepRadius: 18,
        finishedStepBorderColor: Colors.deepPurple,
        finishedStepBackgroundColor: Colors.deepPurpleAccent,
        activeStepBackgroundColor: Colors.deepPurple,
        activeStepBorderColor: Colors.deepPurpleAccent,
        showTitle: true,
        activeStepTextColor: Colors.black,
        finishedStepTextColor: Colors.white,
        steps: [
          EasyStep(title: 'Business', icon: Icon(Icons.business)),
          EasyStep(title: 'Email', icon: Icon(Icons.email)),
          EasyStep(title: 'Logo', icon: Icon(Icons.image)),
          EasyStep(title: 'Details', icon: Icon(Icons.info)),
          EasyStep(title: 'Review', icon: Icon(Icons.check_circle)),
        ],
      ),
    );
  }

  Widget _buildStepContent() {
    final AppComponents appComponent = AppComponents();

    return Obx(() {
      switch (controller.currentStep.value) {
        case 0:
          return appComponent.stepOne(Get.context!);
        case 1:
          return appComponent.stepTwo(Get.context!);
        case 2:
          return appComponent.stepThree(Get.context!);
        case 3:
          return appComponent.stepFour(Get.context!);
        case 4:
          return appComponent.stepFive(Get.context!);
        default:
          return Container();
      }
    });
  }

  Widget _buildNavigationButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 50),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: controller.currentStep.value > 0
                  ? () {
                      controller.previousStep();
                    }
                  : null,
              child: Container(
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                  color: controller.currentStep.value > 0
                      ? Colors.red
                      : Colors.grey,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () async {
                if (controller.currentStep.value < 4) {
                  controller.nextStep();
                } else {
                  await controller.saveData();
                  Get.off(() => const DashboardScreen());
                }
              },
              child: Container(
                height: 60,
                width: 120,
                decoration: BoxDecoration(
                  color: ColorFile.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Text(
                    controller.currentStep.value < 4 ? 'Next' : 'Finish',
                    style: TextStyle(
                      color: ColorFile.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
