import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blaze/double_config_cubit.dart';

import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
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
        builder: (context, doubleConfigState) =>
            doubleConfigState is DoubleConfigLoaded
                ? Container()
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
      ),
    );
  }
}
