import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/data/model/custom_strategy_model.dart';
import 'package:ia_bet/domain/entities/double_config.dart';

import '../../../../data/model/double_config_model.dart';
import '../../../bloc/blaze/double_config_cubit.dart';
import '../controller_settings.dart';

class CustomStrategyItem extends StatelessWidget {
  final SettingsController settingsController;
  final int index;
  final List<CustomStrategyModel> customStrategies;
  final DoubleConfigEntity doubleConfig;
  const CustomStrategyItem(
      {super.key,
      required this.index,
      required this.customStrategies,
      required this.doubleConfig,
      required this.settingsController});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff0a1117),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Icon(
            Icons.open_with,
            color: Colors.white,
          ),
          Text(
            customStrategies[index].name,
            style: const TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          ),
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xfff12c4d),
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              onPressed: () {
                doubleConfig.customStrategies.remove(customStrategies[index]);
                final DoubleConfigModel newDoubleConfig = DoubleConfigModel(
                  amountStopGain: doubleConfig.amountStopGain,
                  amountStopLoss: doubleConfig.amountStopLoss,
                  elevations: doubleConfig.elevations,
                  enabled: doubleConfig.enabled,
                  entryAmount: doubleConfig.entryAmount,
                  entryWhiteAmount: doubleConfig.entryWhiteAmount,
                  gales: doubleConfig.gales,
                  isActiveElevation: doubleConfig.isActiveElevation,
                  isActiveStopGain: doubleConfig.isActiveStopGain,
                  isActiveStopLoss: doubleConfig.isActiveStopLoss,
                  isActiveGale: doubleConfig.isActiveGale,
                  maxElevation: doubleConfig.maxElevation,
                  maxGales: doubleConfig.maxGales,
                  strategies: doubleConfig.strategies,
                  wallet: doubleConfig.wallet ?? 0,
                  customStrategies: doubleConfig.customStrategies,
                  stopWithWhite: doubleConfig.stopWithWhite,
                );

                BlocProvider.of<DoubleConfigCubit>(context)
                    .saveDoubleConfig(newDoubleConfig);
                settingsController.update();
              },
              icon: const Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
