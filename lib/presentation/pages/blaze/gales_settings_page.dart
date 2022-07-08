import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/data/model/double_config_model.dart';
import 'package:ia_bet/presentation/pages/blaze/controller_settings.dart';

import '../../../domain/entities/double_config.dart';
import '../../bloc/blaze/double_config_cubit.dart';

import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'components/gale_widget.dart';

class GalesSettingsPage extends StatefulWidget {
  const GalesSettingsPage({Key? key}) : super(key: key);

  @override
  State<GalesSettingsPage> createState() => _GalesSettingsPageState();
}

class _GalesSettingsPageState extends State<GalesSettingsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SettingsController settingsController = SettingsController();

  void editGale({required List<Gale> gales, required int index}) =>
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color(0xff0f1923),
          content: Form(
            key: settingsController.formkeyEdit,
            child: SizedBox(
              height: 350,
              child: Column(
                children: [
                  Text(
                    'Editar gale',
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    child: TextFormField(
                      controller:
                          settingsController.editFirstBetPriceController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.white),
                      validator: (String? input) {
                        if (input != null && input.isNotEmpty) {
                          return null;
                        } else {
                          return 'digite algum valor';
                        }
                      },
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff1bb57f), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelText: 'Vermelho ou preto',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 30),
                    child: TextFormField(
                      controller:
                          settingsController.editFirstBetWhiteController,
                      keyboardType: TextInputType.number,
                      validator: (String? input) {
                        if (input != null && input.isNotEmpty) {
                          return null;
                        } else {
                          return 'digite algum valor';
                        }
                      },
                      style: TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        fillColor: Colors.white,
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xff1bb57f), width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Colors.white, width: 1.0),
                        ),
                        labelText: 'Proteção Branco',
                        labelStyle: TextStyle(color: Colors.white),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xff1bb57f),
                    ),
                    onPressed: () {
                      final isValid = settingsController
                          .formkeyEdit.currentState!
                          .validate();

                      if (isValid) {
                        gales.removeAt(index);
                        gales.insert(
                          index,
                          Gale(
                            amount: double.parse(settingsController
                                .editFirstBetPriceController.text),
                            amountProtection: double.parse(settingsController
                                .editFirstBetWhiteController.text),
                          ),
                        );
                        settingsController.editFirstBetPriceController.clear();
                        settingsController.editFirstBetWhiteController.clear();
                        Navigator.pop(context);
                      }
                    },
                    child: Center(
                      child: Text(
                        'Salvar',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<DoubleConfigCubit, DoubleConfigState>(
      builder: (context, doubleConfigState) => doubleConfigState
              is DoubleConfigLoaded
          ? Scaffold(
              key: scaffoldKey,
              backgroundColor: const Color(0xff0f1923),
              drawer: Drawer(
                child: Container(
                  color: const Color(0xff0f1923),
                ),
              ),
              appBar: CustomAppBarSettings(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      'Gales',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    IconButton(
                      onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              body: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  child: Form(
                    key: settingsController.formkey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.75,
                          child: StatefulBuilder(
                            builder: (BuildContext context,
                                    void Function(void Function()) setState) =>
                                ReorderableListView.builder(
                              padding:
                                  const EdgeInsets.only(left: 20, right: 20),
                              itemCount:
                                  doubleConfigState.doubleConfig.gales.length,
                              onReorder: (oldPosition, newPosition) =>
                                  setState(() {
                                if (oldPosition < newPosition) {
                                  newPosition -= 1;
                                }
                                final Gale gale = doubleConfigState
                                    .doubleConfig.gales
                                    .removeAt(oldPosition);
                                doubleConfigState.doubleConfig.gales
                                    .insert(newPosition, gale);

                                final DoubleConfigModel doubleConfig =
                                    DoubleConfigModel(
                                  amountStopGain: doubleConfigState
                                      .doubleConfig.amountStopGain,
                                  amountStopLoss: doubleConfigState
                                      .doubleConfig.amountStopLoss,
                                  elevations:
                                      doubleConfigState.doubleConfig.elevations,
                                  enabled:
                                      doubleConfigState.doubleConfig.enabled,
                                  entryAmount: doubleConfigState
                                      .doubleConfig.entryAmount,
                                  entryWhiteAmount: doubleConfigState
                                      .doubleConfig.entryWhiteAmount,
                                  gales: doubleConfigState.doubleConfig.gales,
                                  isActiveElevation: doubleConfigState
                                      .doubleConfig.isActiveElevation,
                                  isActiveGale: doubleConfigState
                                      .doubleConfig.isActiveGale,
                                  isActiveStopGain: doubleConfigState
                                      .doubleConfig.isActiveStopGain,
                                  isActiveStopLoss: doubleConfigState
                                      .doubleConfig.isActiveStopLoss,
                                  maxElevation: doubleConfigState
                                      .doubleConfig.maxElevation,
                                  maxGales:
                                      doubleConfigState.doubleConfig.maxGales,
                                  strategies:
                                      doubleConfigState.doubleConfig.strategies,
                                  wallet:
                                      doubleConfigState.doubleConfig.wallet ??
                                          0, customStrategies: doubleConfigState
                                                        .doubleConfig.customStrategies
                                );

                                BlocProvider.of<DoubleConfigCubit>(context)
                                    .saveDoubleConfig(doubleConfig);
                              }),
                              itemBuilder: (BuildContext context, int index) =>
                                  GestureDetector(
                                onTap: () => editGale(
                                    gales: doubleConfigState.doubleConfig.gales,
                                    index: index),
                                key: Key('$index'),
                                child: SizedBox(
                                  height: 70,
                                  child: GaleWidget(
                                    index: index,
                                    gales: doubleConfigState.doubleConfig.gales,
                                    doubleConfig:
                                        doubleConfigState.doubleConfig,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: size.height * 0.01,
                            left: 20,
                            right: 20,
                          ),
                          child: Container(
                            height: 70,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 70,
                                  width: size.width * 0.38,
                                  child: TextFormField(
                                    controller: settingsController
                                        .newFirstBetPriceController,
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(color: Colors.white),
                                    validator: (String? input) {
                                      if (input != null && input.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'digite algum valor';
                                      }
                                    },
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
                                SizedBox(
                                  height: 70,
                                  width: size.width * 0.38,
                                  child: TextFormField(
                                    controller: settingsController
                                        .newFirstBetWhiteController,
                                    keyboardType: TextInputType.number,
                                    validator: (String? input) {
                                      if (input != null && input.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'digite algum valor';
                                      }
                                    },
                                    style: TextStyle(color: Colors.white),
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
                                SizedBox(
                                  height: 70,
                                  width: size.width * 0.1,
                                  child: CircleAvatar(
                                    backgroundColor: const Color(0xff1bb57f),
                                    child: IconButton(
                                      splashRadius: 25,
                                      color: Colors.white,
                                      onPressed: () {
                                        final isValid = settingsController
                                            .formkey.currentState!
                                            .validate();

                                        if (isValid) {
                                          doubleConfigState.doubleConfig.gales
                                              .add(
                                            Gale(
                                              amount: double.parse(
                                                  settingsController
                                                      .newFirstBetPriceController
                                                      .text),
                                              amountProtection: double.parse(
                                                  settingsController
                                                      .newFirstBetWhiteController
                                                      .text),
                                            ),
                                          );

                                          FocusManager.instance.primaryFocus
                                              ?.unfocus();
                                          final DoubleConfigModel doubleConfig =
                                              DoubleConfigModel(
                                            amountStopGain: doubleConfigState
                                                .doubleConfig.amountStopGain,
                                            amountStopLoss: doubleConfigState
                                                .doubleConfig.amountStopLoss,
                                            elevations: doubleConfigState
                                                .doubleConfig.elevations,
                                            enabled: doubleConfigState
                                                .doubleConfig.enabled,
                                            entryAmount: doubleConfigState
                                                .doubleConfig.entryAmount,
                                            entryWhiteAmount: doubleConfigState
                                                .doubleConfig.entryWhiteAmount,
                                            gales: doubleConfigState
                                                .doubleConfig.gales,
                                            isActiveElevation: doubleConfigState
                                                .doubleConfig.isActiveElevation,
                                            isActiveGale: doubleConfigState
                                                .doubleConfig.isActiveGale,
                                            isActiveStopGain: doubleConfigState
                                                .doubleConfig.isActiveStopGain,
                                            isActiveStopLoss: doubleConfigState
                                                .doubleConfig.isActiveStopLoss,
                                            maxElevation: doubleConfigState
                                                .doubleConfig.maxElevation,
                                            maxGales: doubleConfigState
                                                .doubleConfig.maxGales,
                                            strategies: doubleConfigState
                                                .doubleConfig.strategies,
                                            wallet: doubleConfigState
                                                    .doubleConfig.wallet ??
                                                0, customStrategies: doubleConfigState
                                                        .doubleConfig.customStrategies
                                          );

                                          BlocProvider.of<DoubleConfigCubit>(
                                                  context)
                                              .saveDoubleConfig(doubleConfig);
                                          settingsController
                                              .newFirstBetPriceController
                                              .clear();
                                          settingsController
                                              .newFirstBetWhiteController
                                              .clear();
                                        }
                                      },
                                      icon: Icon(Icons.add),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
