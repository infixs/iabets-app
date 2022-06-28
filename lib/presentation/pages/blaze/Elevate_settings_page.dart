import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/presentation/pages/blaze/controller_settings.dart';

import '../../../data/model/double_config_model.dart';
import '../../bloc/blaze/double_config_cubit.dart';

import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';

class ElevateSettingsPage extends StatefulWidget {
  const ElevateSettingsPage({Key? key}) : super(key: key);

  @override
  State<ElevateSettingsPage> createState() => _ElevateSettingsPageState();
}

class _ElevateSettingsPageState extends State<ElevateSettingsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SettingsController settingsController = SettingsController();

  void editElevations({required List<int> elevations, required int index}) =>
      showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          backgroundColor: const Color(0xff0f1923),
          content: Form(
            key: settingsController.formkeyEdit,
            child: SizedBox(
              height: 250,
              child: Column(
                children: [
                  Text(
                    'Editar Elevação',
                    style: TextStyle(color: Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    child: TextFormField(
                      controller: settingsController.editMultiplierController,
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
                        labelText: 'Elevação',
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
                        elevations.removeAt(index);
                        elevations.insert(
                            index,
                            int.parse(settingsController
                                .editMultiplierController.text));
                        settingsController.editMultiplierController.clear();

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
                      'Multiplicadores',
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
                          child: ReorderableListView.builder(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            itemCount: doubleConfigState
                                .doubleConfig.elevations.length,
                            onReorder: (oldPosition, newPosition) =>
                                setState(() {
                              if (oldPosition < newPosition) {
                                newPosition -= 1;
                              }
                              final int item = doubleConfigState
                                  .doubleConfig.elevations
                                  .removeAt(oldPosition);
                              doubleConfigState.doubleConfig.elevations
                                  .insert(newPosition, item);

                              final DoubleConfigModel doubleConfig =
                                  DoubleConfigModel(
                                amountStopGain: doubleConfigState
                                    .doubleConfig.amountStopGain,
                                amountStopLoss: doubleConfigState
                                    .doubleConfig.amountStopLoss,
                                elevations:
                                    doubleConfigState.doubleConfig.elevations,
                                enabled: doubleConfigState.doubleConfig.enabled,
                                entryAmount:
                                    doubleConfigState.doubleConfig.entryAmount,
                                entryWhiteAmount: doubleConfigState
                                    .doubleConfig.entryWhiteAmount,
                                gales: doubleConfigState.doubleConfig.gales,
                                isActiveElevation: doubleConfigState
                                    .doubleConfig.isActiveElevation,
                                isActiveStopGain: doubleConfigState
                                    .doubleConfig.isActiveStopGain,
                                isActiveStopLoss: doubleConfigState
                                    .doubleConfig.isActiveStopLoss,
                                maxElevation:
                                    doubleConfigState.doubleConfig.maxElevation,
                                maxGales:
                                    doubleConfigState.doubleConfig.maxGales,
                                strategies:
                                    doubleConfigState.doubleConfig.strategies,
                                wallet:
                                    doubleConfigState.doubleConfig.wallet ?? 0,
                              );

                              BlocProvider.of<DoubleConfigCubit>(context)
                                  .saveDoubleConfig(doubleConfig);
                            }),
                            itemBuilder: (BuildContext context, int index) =>
                                GestureDetector(
                              onTap: () => editElevations(
                                elevations:
                                    doubleConfigState.doubleConfig.elevations,
                                index: index,
                              ),
                              key: Key('$index'),
                              child: SizedBox(
                                height: 70,
                                child: Card(
                                  color: const Color(0xff0a1117),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.open_with,
                                        color: Colors.white,
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Mutiplicador',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          Text(
                                            '${doubleConfigState.doubleConfig.elevations[index]}x',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ],
                                      ),
                                      CircleAvatar(
                                        backgroundColor:
                                            const Color(0xfff12c4d),
                                        child: IconButton(
                                          splashRadius: 25,
                                          onPressed: () {
                                            doubleConfigState
                                                .doubleConfig.elevations
                                                .remove(doubleConfigState
                                                    .doubleConfig
                                                    .elevations[index]);

                                            final DoubleConfigModel
                                                doubleConfig =
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
                                              entryWhiteAmount:
                                                  doubleConfigState.doubleConfig
                                                      .entryWhiteAmount,
                                              gales: doubleConfigState
                                                  .doubleConfig.gales,
                                              isActiveElevation:
                                                  doubleConfigState.doubleConfig
                                                      .isActiveElevation,
                                              isActiveStopGain:
                                                  doubleConfigState.doubleConfig
                                                      .isActiveStopGain,
                                              isActiveStopLoss:
                                                  doubleConfigState.doubleConfig
                                                      .isActiveStopLoss,
                                              maxElevation: doubleConfigState
                                                  .doubleConfig.maxElevation,
                                              maxGales: doubleConfigState
                                                  .doubleConfig.maxGales,
                                              strategies: doubleConfigState
                                                  .doubleConfig.strategies,
                                              wallet: doubleConfigState
                                                      .doubleConfig.wallet ??
                                                  0,
                                            );

                                            BlocProvider.of<DoubleConfigCubit>(
                                                    context)
                                                .saveDoubleConfig(doubleConfig);
                                          },
                                          icon: Icon(
                                            Icons.close,
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                    ],
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
                                  width: size.width * 0.75,
                                  child: TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller:
                                        settingsController.multiplierController,
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
                                      labelText: 'Valor Mutiplicador',
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
                                          doubleConfigState
                                              .doubleConfig.elevations
                                              .add(
                                            int.parse(settingsController
                                                .multiplierController.text),
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
                                                0,
                                          );

                                          BlocProvider.of<DoubleConfigCubit>(
                                                  context)
                                              .saveDoubleConfig(doubleConfig);
                                          settingsController
                                              .multiplierController
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
