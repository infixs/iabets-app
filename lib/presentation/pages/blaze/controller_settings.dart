import 'package:flutter/material.dart';

class SettingsController {
  final formkey = GlobalKey<FormState>();

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
    },
  ];

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
  Map<String, dynamic> firstBet = {'price': 50, 'white': 5};

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
