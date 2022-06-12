import 'package:flutter/material.dart';

class SettingsController {
  final ValueNotifier<double> stopGain = ValueNotifier<double>(0);
  final ValueNotifier<double> stopLoss = ValueNotifier<double>(0);
  List<Map<String, dynamic>> strategies = [
    {
      'name': 'Sequencia de 8',
      'value': true,
    },
    {
      'name': 'Somente brancos',
      'value': false,
    },
    {
      'name': 'Alternativa teste',
      'value': true,
    }
  ];
  List<Map<String, dynamic>> gales = [
    {'price': 100, 'white': 10},
    {'price': 200, 'white': 20},
    {'price': 400, 'white': 40},
  ];
  Map<String, dynamic> firstBet = {'price': 400, 'white': 40};

  final TextEditingController stopGainController = TextEditingController();
  final TextEditingController stoplossController = TextEditingController();
  final TextEditingController firstBetPriceController = TextEditingController();
  final TextEditingController firstBetWhiteController = TextEditingController();

  void dispose() {
    stopGain.dispose();
    stopLoss.dispose();
    stopGainController.dispose();
    stoplossController.dispose();
    firstBetPriceController.dispose();
    firstBetWhiteController.dispose();
  }

  void saveConfig() {
    stopGain.value = double.parse(stopGainController.text);
    stopLoss.value = double.parse(stoplossController.text);
    firstBet['price'] = double.parse(firstBetPriceController.text);
    firstBet['white'] = double.parse(firstBetWhiteController.text);
  }
}
