import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/entities/strategy_entity.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';

import '../../../data/model/double_config_model.dart';

import 'Elevate_settings_page.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'controller_settings.dart';
import 'gales_settings_page.dart';

class BlazeSettingsPage extends StatefulWidget {
  final DoubleConfigEntity doubleConfig;

  const BlazeSettingsPage({Key? key, required this.doubleConfig})
      : super(key: key);

  @override
  State<BlazeSettingsPage> createState() => _BlazeSettingsPageState();
}

class _BlazeSettingsPageState extends State<BlazeSettingsPage> {
  final SettingsController settingsController = SettingsController();

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoubleConfigCubit, DoubleConfigState>(
        builder: (context, doubleConfigState) {
      return doubleConfigState is DoubleConfigLoaded
          ? FutureBuilder(
              future: settingsController.init(doubleConfigState.doubleConfig),
              builder: (BuildContext context, AsyncSnapshot<void> snapshot) =>
                  Scaffold(
                backgroundColor: const Color(0xff0f1923),
                appBar: CustomAppBarSettings(
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                      const Text(
                        'Configurações',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      )
                    ],
                  ),
                ),
                body: SingleChildScrollView(
                  child: Form(
                    key: settingsController.formkey,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 8),
                            child: StatefulBuilder(
                              builder: (BuildContext context,
                                      void Function(void Function())
                                          setState) =>
                                  FutureBuilder<List<StrategyEntity>>(
                                future:
                                    BlocProvider.of<DoubleConfigCubit>(context)
                                        .getStrategies(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<StrategyEntity>>
                                        snapshot) {
                                  if (!snapshot.hasData)
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  return Column(
                                      children: snapshot.data!.map((element) {
                                    final Strategy strategy = doubleConfigState
                                        .doubleConfig.strategies
                                        .firstWhere(
                                      (el) => el.id == element.id,
                                      orElse: () {
                                        final strategy = Strategy(
                                            id: element.id,
                                            active: false,
                                            name: element.name);
                                        doubleConfigState
                                            .doubleConfig.strategies
                                            .add(strategy);
                                        return strategy;
                                      },
                                    );
                                    return Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              element.name,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                            Switch(
                                              value: strategy.active,
                                              onChanged: (value) => setState(
                                                  () => strategy.active =
                                                      !strategy.active),
                                              inactiveThumbColor:
                                                  const Color(0xfff12c4d),
                                              activeColor:
                                                  const Color(0xff1bb57f),
                                              activeTrackColor:
                                                  const Color(0xff0e0812),
                                            )
                                          ],
                                        ),
                                        Container(
                                          height: 1,
                                          color: const Color(0xff0e0812),
                                        )
                                      ],
                                    );
                                  }).toList());
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20, bottom: 20),
                            child: Row(
                              children: [
                                const Spacer(),
                                Flexible(
                                  flex: 15,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        validator: (String? input) {
                                          if (input != null &&
                                              input.isNotEmpty) {
                                            return null;
                                          } else {
                                            return 'digite algum valor';
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: Colors.white),
                                        controller: settingsController
                                            .stopGainController,
                                        decoration: InputDecoration(
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff1bb57f),
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                          ),
                                          labelText: 'Stop gain',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ValueListenableBuilder(
                                          valueListenable:
                                              settingsController.stopGainIsOn,
                                          builder: (BuildContext context, value,
                                                  Widget? child) =>
                                              Checkbox(
                                                  value: settingsController
                                                      .stopGainIsOn.value,
                                                  onChanged: (bool? value) =>
                                                      settingsController
                                                          .stopGainIsOn
                                                          .value = value!),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                Flexible(
                                  flex: 15,
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        validator: (String? input) {
                                          if (input != null &&
                                              input.isNotEmpty) {
                                            return null;
                                          } else {
                                            return 'digite algum valor';
                                          }
                                        },
                                        keyboardType: TextInputType.number,
                                        style: TextStyle(color: Colors.white),
                                        controller: settingsController
                                            .stoplossController,
                                        decoration: const InputDecoration(
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Color(0xff1bb57f),
                                                width: 1.0),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.white,
                                                width: 1.0),
                                          ),
                                          labelText: 'Stop loss',
                                          labelStyle:
                                              TextStyle(color: Colors.white),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(2),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: ValueListenableBuilder(
                                          valueListenable:
                                              settingsController.stopLossIsOn,
                                          builder: (BuildContext context, value,
                                                  Widget? child) =>
                                              Checkbox(
                                                  value: settingsController
                                                      .stopLossIsOn.value,
                                                  onChanged: (bool? value) =>
                                                      settingsController
                                                          .stopLossIsOn
                                                          .value = value!),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          Text(
                            'Primeira aposta',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              children: [
                                const Spacer(),
                                Flexible(
                                  flex: 15,
                                  child: TextFormField(
                                    validator: (String? input) {
                                      if (input != null && input.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'digite algum valor';
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    controller: settingsController
                                        .firstBetPriceController,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1bb57f),
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      labelText: 'Vermelho ou preto',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(
                                  flex: 2,
                                ),
                                Flexible(
                                  flex: 15,
                                  child: TextFormField(
                                    validator: (String? input) {
                                      if (input != null && input.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'digite algum valor';
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    controller: settingsController
                                        .firstBetWhiteController,
                                    decoration: const InputDecoration(
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xff1bb57f),
                                            width: 1.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1.0),
                                      ),
                                      labelText: 'Proteção Branco',
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(2),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Spacer(),
                                Flexible(
                                  flex: 5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            GalesSettingsPage(),
                                      ),
                                    ),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xff1bb57f),
                                            const Color(0xff08835d),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      height: 50,
                                      child: Center(
                                        child: Text(
                                          'Gales',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Flexible(
                                    child: ValueListenableBuilder(
                                  valueListenable: settingsController.galesIsOn,
                                  builder: (BuildContext context, bool value,
                                          Widget? child) =>
                                      Switch(
                                    value: settingsController.galesIsOn.value,
                                    onChanged: (bool value) =>
                                        settingsController.galesIsOn.value =
                                            !settingsController.galesIsOn.value,
                                    inactiveThumbColor: const Color(0xfff12c4d),
                                    activeColor: const Color(0xff1bb57f),
                                    activeTrackColor: const Color(0xff0e0812),
                                  ),
                                )),
                                const Spacer(flex: 2),
                                Flexible(
                                  flex: 5,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: EdgeInsets.all(0),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            ElevateSettingsPage(),
                                      ),
                                    ),
                                    child: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            const Color(0xff1bb57f),
                                            const Color(0xff08835d),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Alavancar',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                Flexible(
                                  child: ValueListenableBuilder(
                                    valueListenable:
                                        settingsController.elevationIsOn,
                                    builder: (BuildContext context, bool value,
                                            Widget? child) =>
                                        Switch(
                                      value: settingsController
                                          .elevationIsOn.value,
                                      onChanged: (bool value) =>
                                          settingsController
                                                  .elevationIsOn.value =
                                              !settingsController
                                                  .elevationIsOn.value,
                                      inactiveThumbColor:
                                          const Color(0xfff12c4d),
                                      activeColor: const Color(0xff1bb57f),
                                      activeTrackColor: const Color(0xff0e0812),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: const Color(0xff1bb57f),
                  onPressed: () {
                    final isValid =
                        settingsController.formkey.currentState!.validate();
                    if (isValid) {
                      final DoubleConfigModel doubleConfig = DoubleConfigModel(
                        amountStopGain: double.parse(
                            settingsController.stopGainController.text),
                        amountStopLoss: double.parse(
                            settingsController.stoplossController.text),
                        elevations: doubleConfigState.doubleConfig.elevations,
                        enabled: doubleConfigState.doubleConfig.enabled,
                        entryAmount: double.parse(
                            settingsController.firstBetPriceController.text),
                        entryWhiteAmount: double.parse(
                            settingsController.firstBetWhiteController.text),
                        gales: doubleConfigState.doubleConfig.gales,
                        isActiveGale: settingsController.galesIsOn.value,
                        isActiveElevation:
                            settingsController.elevationIsOn.value,
                        isActiveStopGain: settingsController.stopGainIsOn.value,
                        isActiveStopLoss: settingsController.stopLossIsOn.value,
                        maxElevation:
                            doubleConfigState.doubleConfig.maxElevation,
                        maxGales: doubleConfigState.doubleConfig.maxGales,
                        strategies: doubleConfigState.doubleConfig.strategies,
                        wallet: doubleConfigState.doubleConfig.wallet ?? 0,
                      );
                      BlocProvider.of<DoubleConfigCubit>(context)
                          .saveDoubleConfig(doubleConfig);
                      Navigator.pop(context);
                    }
                  },
                  child: Icon(Icons.save),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            );
    });
  }
}
