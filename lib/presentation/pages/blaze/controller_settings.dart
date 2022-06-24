import 'package:flutter/material.dart';

import 'package:ia_bet/domain/entities/double_config.dart';

import '../../bloc/blaze/double_config_cubit.dart';

class SettingsController {
  final formkey = GlobalKey<FormState>();

  final TextEditingController stopGainController = TextEditingController();
  final TextEditingController stoplossController = TextEditingController();
  final TextEditingController firstBetPriceController = TextEditingController();
  final TextEditingController firstBetWhiteController = TextEditingController();
  final TextEditingController newFirstBetPriceController =
      TextEditingController();
  final TextEditingController newFirstBetWhiteController =
      TextEditingController();
  final TextEditingController multiplierController = TextEditingController();

  List<int> elevations = [2, 4, 8];

  List<Map<String, dynamic>> gales = [
    {'price': 100, 'white': 10},
    {'price': 200, 'white': 20},
    {'price': 400, 'white': 40},
    {'price': 600, 'white': 70},
    {'price': 900, 'white': 10},
    {'price': 1200, 'white': 40},
    {'price': 1500, 'white': 70},
    {'price': 1800, 'white': 10},
    {'price': 100, 'white': 10},
    {'price': 200, 'white': 20},
    {'price': 400, 'white': 40},
    {'price': 600, 'white': 70},
    {'price': 900, 'white': 10},
    {'price': 1200, 'white': 40},
    {'price': 1500, 'white': 70},
    {'price': 1800, 'white': 10},
  ];

  void init(DoubleConfigEntity doubleConfig) {
    stopGainController.text = doubleConfig.amountStopGain.toString();
    stoplossController.text = doubleConfig.amountStopLoss.toString();
    firstBetPriceController.text = doubleConfig.entryAmount.toString();
    firstBetWhiteController.text = doubleConfig.entryWhiteAmount.toString();
  }

  void dispose() {
    stopGainController.dispose();
    stoplossController.dispose();
    firstBetPriceController.dispose();
    firstBetWhiteController.dispose();
    newFirstBetPriceController.dispose();
    newFirstBetWhiteController.dispose();
    multiplierController.dispose();
  }
}
