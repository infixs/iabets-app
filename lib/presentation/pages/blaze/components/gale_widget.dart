import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/model/double_config_model.dart';
import '../../../../domain/entities/double_config.dart';
import '../../../bloc/blaze/double_config_cubit.dart';

class GaleWidget extends StatelessWidget {
  final DoubleConfigEntity doubleConfig;
  final int index;
  final List<Gale> gales;

  const GaleWidget(
      {super.key,
      required this.gales,
      required this.index,
      required this.doubleConfig});

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Vermelho/Preto',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '${gales[index].amount}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Branco',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '${gales[index].amountProtection}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          CircleAvatar(
            radius: 17,
            backgroundColor: const Color(0xfff12c4d),
            child: IconButton(
              padding: EdgeInsets.zero,
              splashRadius: 20,
              onPressed: () {
                doubleConfig.gales.remove(gales[index]);
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
                );

                BlocProvider.of<DoubleConfigCubit>(context)
                    .saveDoubleConfig(newDoubleConfig);
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
