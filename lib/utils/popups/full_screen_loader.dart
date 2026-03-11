import 'package:test/utils/loaders/circular_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import '../constants/colors.dart';
import '../helpers/helper_functions.dart';
import '../loaders/animation_loader.dart';

/// A utility class for managing a full-screen loading dialog.
class TFullScreenLoader {
  static bool _isOpen = false;

  static void _runAfterBuild(VoidCallback callback) {
    final phase = SchedulerBinding.instance.schedulerPhase;
    if (phase == SchedulerPhase.persistentCallbacks) {
      WidgetsBinding.instance.addPostFrameCallback((_) => callback());
      return;
    }
    callback();
  }

  /// Open a full-screen loading dialog with a given text and animation.
  /// This method doesn't return anything.
  ///
  /// Parameters:
  ///   - text: The text to be displayed in the loading dialog.
  ///   - animation: The Lottie animation to be shown.
  static void openLoadingDialog(String text, String animation) {
    _runAfterBuild(() {
      if (_isOpen) return;
      final overlayContext = Get.overlayContext;
      if (overlayContext == null) return;

      _isOpen = true;
      showDialog(
        context: overlayContext,
        barrierDismissible: false,
        useRootNavigator: true,
        builder: (_) => PopScope(
          canPop: false,
          child: Container(
            color: THelperFunctions.isDarkMode(Get.context!)
                ? TColors.dark
                : TColors.white,
            width: double.infinity,
            height: double.infinity,
            child: Column(
              children: [
                const SizedBox(height: 250),
                TAnimationLoaderWidget(text: text, animation: animation),
              ],
            ),
          ),
        ),
      ).whenComplete(() {
        _isOpen = false;
      });
    });
  }

  static void popUpCirular() {
    Get.defaultDialog(
      title: '',
      onWillPop: () async => false,
      content: const TCircularLoader(),
      backgroundColor: Colors.transparent,
    );
  }

  /// Stop the currently open loading dialog.
  /// This method doesn't return anything.
  static void stopLoading() {
    _runAfterBuild(() {
      if (!_isOpen) return;
      final overlayContext = Get.overlayContext;
      if (overlayContext == null) return;

      Navigator.of(overlayContext, rootNavigator: true).pop();
      _isOpen = false;
    });
  }
}
