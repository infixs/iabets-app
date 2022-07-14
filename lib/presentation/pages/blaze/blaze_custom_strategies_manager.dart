import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/data/model/custom_strategy_model.dart';

import '../../../data/model/double_config_model.dart';
import '../../bloc/blaze/double_config_cubit.dart';

import 'blaze_create_strategy_page.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'components/custom_strategy_item_widget.dart';
import 'controller_settings.dart';

class BlazeCustomStrategiesManager extends StatefulWidget {
  final SettingsController settingsController;
  const BlazeCustomStrategiesManager(
      {super.key, required this.settingsController});

  @override
  State<BlazeCustomStrategiesManager> createState() =>
      _BlazeCustomStrategiesManagerState();
}

class _BlazeCustomStrategiesManagerState
    extends State<BlazeCustomStrategiesManager> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff0f1923),
      appBar: CustomAppBarSettings(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Text(
              'Minhas estrategias',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
      body: BlocBuilder<DoubleConfigCubit, DoubleConfigState>(
        builder: (context, doubleConfigState) => doubleConfigState
                is DoubleConfigLoaded
            ? StatefulBuilder(
                builder: (BuildContext context,
                        void Function(void Function()) setState) =>
                    ReorderableListView.builder(
                  itemCount:
                      doubleConfigState.doubleConfig.customStrategies.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    key: Key('$index'),
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 20),
                    child: SizedBox(
                      height: 70,
                      child: CustomStrategyItem(
                        doubleConfig: doubleConfigState.doubleConfig,
                        customStrategies:
                            doubleConfigState.doubleConfig.customStrategies,
                        index: index,
                      ),
                    ),
                  ),
                  onReorder: (oldPosition, newPosition) => setState(() {
                    if (oldPosition < newPosition) {
                      newPosition -= 1;
                    }

                    final CustomStrategyModel customStrategy = doubleConfigState
                        .doubleConfig.customStrategies
                        .removeAt(oldPosition);
                    doubleConfigState.doubleConfig.customStrategies
                        .insert(newPosition, customStrategy);

                    final DoubleConfigModel doubleConfig = DoubleConfigModel(
                        amountStopGain:
                            doubleConfigState.doubleConfig.amountStopGain,
                        amountStopLoss:
                            doubleConfigState.doubleConfig.amountStopLoss,
                        elevations: doubleConfigState.doubleConfig.elevations,
                        enabled: doubleConfigState.doubleConfig.enabled,
                        entryAmount: doubleConfigState.doubleConfig.entryAmount,
                        entryWhiteAmount:
                            doubleConfigState.doubleConfig.entryWhiteAmount,
                        gales: doubleConfigState.doubleConfig.gales,
                        isActiveElevation:
                            doubleConfigState.doubleConfig.isActiveElevation,
                        isActiveGale:
                            doubleConfigState.doubleConfig.isActiveGale,
                        isActiveStopGain:
                            doubleConfigState.doubleConfig.isActiveStopGain,
                        isActiveStopLoss:
                            doubleConfigState.doubleConfig.isActiveStopLoss,
                        maxElevation:
                            doubleConfigState.doubleConfig.maxElevation,
                        maxGales: doubleConfigState.doubleConfig.maxGales,
                        strategies: doubleConfigState.doubleConfig.strategies,
                        wallet: doubleConfigState.doubleConfig.wallet ?? 0,
                        customStrategies:
                            doubleConfigState.doubleConfig.customStrategies,
                        stopWithWhite:
                            doubleConfigState.doubleConfig.stopWithWhite);

                    BlocProvider.of<DoubleConfigCubit>(context)
                        .saveDoubleConfig(doubleConfig);
                  }),
                ),
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xff1bb57f),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (BuildContext context) => BlazeCreateStrategyPage(
              settingsController: widget.settingsController,
            ),
          ),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
