import 'package:flutter/material.dart';

import 'package:ia_bet/domain/entities/double_config.dart';

class SettingsController {
  late final DoubleConfigEntity doubleConfigCopy;
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> formkeyEdit = GlobalKey<FormState>();
  final ValueNotifier<bool> stopGainIsOn = ValueNotifier<bool>(true);
  final ValueNotifier<bool> stopLossIsOn = ValueNotifier<bool>(true);
  final ValueNotifier<bool> elevationIsOn = ValueNotifier<bool>(true);
  final ValueNotifier<bool> galesIsOn = ValueNotifier<bool>(true);
  final TextEditingController stopGainController = TextEditingController();
  final TextEditingController stoplossController = TextEditingController();
  final TextEditingController firstBetPriceController = TextEditingController();
  final TextEditingController firstBetWhiteController = TextEditingController();
  final TextEditingController newFirstBetPriceController =
      TextEditingController();
  final TextEditingController newFirstBetWhiteController =
      TextEditingController();
  final TextEditingController editFirstBetPriceController =
      TextEditingController();
  final TextEditingController editFirstBetWhiteController =
      TextEditingController();
  final TextEditingController multiplierController = TextEditingController();
  final TextEditingController editMultiplierController =
      TextEditingController();

  Future<void> init(DoubleConfigEntity doubleConfig) async {
    doubleConfigCopy = doubleConfig;
    stopGainController.text = doubleConfig.amountStopGain.toString();
    stoplossController.text = doubleConfig.amountStopLoss.toString();
    firstBetPriceController.text = doubleConfig.entryAmount.toString();
    firstBetWhiteController.text = doubleConfig.entryWhiteAmount.toString();
    stopGainIsOn.value = doubleConfig.isActiveStopGain;
    stopLossIsOn.value = doubleConfig.isActiveStopLoss;
    elevationIsOn.value = doubleConfig.isActiveElevation;
    galesIsOn.value = doubleConfig.isActiveGale;
  }

  void dispose() {
    galesIsOn.dispose();
    elevationIsOn.dispose();
    stopGainIsOn.dispose();
    stopLossIsOn.dispose();
    stopGainController.dispose();
    stoplossController.dispose();
    firstBetPriceController.dispose();
    firstBetWhiteController.dispose();
    newFirstBetPriceController.dispose();
    newFirstBetWhiteController.dispose();
    multiplierController.dispose();
    editFirstBetPriceController.dispose();
    editFirstBetWhiteController.dispose();
    editMultiplierController.dispose();
  }
}
