import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/entities/strategy_entity.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';

import '../../../data/model/double_config_model.dart';

import 'Elevate_settings_page.dart';
import 'blaze_create_strategy_page.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'controller_settings.dart';
import 'gales_settings_page.dart';

class BlazeSettingsPage extends StatefulWidget {
  const BlazeSettingsPage({Key? key}) : super(key: key);

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

  Future<DoubleConfigEntity> getDoubleConfigFirebase() async =>
      await BlocProvider.of<DoubleConfigCubit>(context)
          .firebaseRepository
          .getDoubleConfig()
          .first;

  Future<List<Gale>> getGalesDoubleConfigFirebase() async =>
      (await BlocProvider.of<DoubleConfigCubit>(context)
              .firebaseRepository
              .getDoubleConfig()
              .first)
          .gales;

  Future<List<int>> getElevationsDoubleConfigFirebase() async =>
      (await BlocProvider.of<DoubleConfigCubit>(context)
              .firebaseRepository
              .getDoubleConfig()
              .first)
          .elevations;

  Future<void> init() async => settingsController.init(
        await getDoubleConfigFirebase(),
      );

  Future<void> validateAndSave() async {
    final isValid = settingsController.formkey.currentState!.validate();
    if (isValid) {
      final DoubleConfigModel doubleConfig = DoubleConfigModel(
        amountStopGain:
            double.parse(settingsController.stopGainController.text),
        amountStopLoss:
            double.parse(settingsController.stoplossController.text),
        elevations: await getElevationsDoubleConfigFirebase(),
        enabled: settingsController.doubleConfigCopy!.enabled,
        entryAmount:
            double.parse(settingsController.firstBetPriceController.text),
        entryWhiteAmount:
            double.parse(settingsController.firstBetWhiteController.text),
        gales: await getGalesDoubleConfigFirebase(),
        isActiveGale: settingsController.galesIsOn.value,
        isActiveElevation: settingsController.elevationIsOn.value,
        isActiveStopGain: settingsController.stopGainIsOn.value,
        isActiveStopLoss: settingsController.stopLossIsOn.value,
        maxElevation: settingsController.doubleConfigCopy!.maxElevation,
        maxGales: settingsController.doubleConfigCopy!.maxGales,
        strategies: settingsController.doubleConfigCopy!.strategies,
        wallet: settingsController.doubleConfigCopy!.wallet ?? 0,
        customStrategies: settingsController.doubleConfigCopy!.customStrategies,
      );
      BlocProvider.of<DoubleConfigCubit>(context)
          .saveDoubleConfig(doubleConfig);
    }
  }

  Future<bool> isEqual() async {
    bool isEqual = true;

    final DoubleConfigEntity doubleConfigFirebase =
        await getDoubleConfigFirebase();

    if (settingsController.galesIsOn.value ==
        doubleConfigFirebase.isActiveGale) {
      if (doubleConfigFirebase.isActiveElevation ==
          settingsController.elevationIsOn.value) {
        if (doubleConfigFirebase.isActiveStopGain ==
            settingsController.stopGainIsOn.value) {
          if (doubleConfigFirebase.isActiveStopLoss ==
              settingsController.stopLossIsOn.value) {
            if (doubleConfigFirebase.amountStopGain ==
                double.parse(settingsController.stopGainController.text)) {
              if (doubleConfigFirebase.amountStopLoss ==
                  double.parse(settingsController.stoplossController.text)) {
                if (doubleConfigFirebase.entryAmount ==
                    double.parse(
                        settingsController.firstBetPriceController.text)) {
                  if (doubleConfigFirebase.entryWhiteAmount ==
                      double.parse(
                          settingsController.firstBetWhiteController.text)) {
                    final List<bool> strategiesFirebase = [];
                    final List<bool> strategiesLocal = [];
                    doubleConfigFirebase.strategies.forEach(
                        (Strategy element) =>
                            strategiesFirebase.add(element.active));
                    settingsController.doubleConfigCopy!.strategies.forEach(
                        (Strategy element) =>
                            strategiesLocal.add(element.active));

                    if (listEquals(strategiesFirebase, strategiesLocal)) {
                      isEqual = true;
                    } else {
                      isEqual = false;
                    }
                  } else {
                    isEqual = false;
                  }
                } else {
                  isEqual = false;
                }
              } else {
                isEqual = false;
              }
            } else {
              isEqual = false;
            }
          } else {
            isEqual = false;
          }
        } else {
          isEqual = false;
        }
      } else {
        isEqual = false;
      }
    } else {
      isEqual = false;
    }

    return isEqual;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: init(),
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) => Scaffold(
        backgroundColor: const Color(0xff0f1923),
        appBar: CustomAppBarSettings(
          child: Row(
            children: [
              IconButton(
                onPressed: () => isEqual().then((bool value) {
                  if (value) {
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                        title: Text(
                            'Você não salvou as alterações deseja salvar?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text('Sair sem salvar'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancelar'),
                          )
                        ],
                      ),
                    );
                  }
                }),
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
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: StatefulBuilder(
                      builder: (BuildContext context,
                              void Function(void Function()) setState) =>
                          FutureBuilder<List<StrategyEntity>>(
                        future: BlocProvider.of<DoubleConfigCubit>(context)
                            .getStrategies(),
                        builder: (BuildContext context,
                            AsyncSnapshot<List<StrategyEntity>> snapshot) {
                          if (!snapshot.hasData)
                            return Center(
                              child: CircularProgressIndicator(),
                            );

                          return Column(
                              children: snapshot.data!.map((element) {
                            final Strategy strategy = settingsController
                                .doubleConfigCopy!.strategies
                                .firstWhere(
                              (el) => el.id == element.id,
                              orElse: () {
                                final strategy = Strategy(
                                    id: element.id,
                                    active: false,
                                    name: element.name);
                                settingsController.doubleConfigCopy!.strategies
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
                                      style:
                                          const TextStyle(color: Colors.white),
                                    ),
                                    Switch(
                                      value: strategy.active,
                                      onChanged: (value) => setState(() =>
                                          strategy.active = !strategy.active),
                                      inactiveThumbColor:
                                          const Color(0xfff12c4d),
                                      activeColor: const Color(0xff1bb57f),
                                      activeTrackColor: const Color(0xff0e0812),
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
                  ElevatedButton(
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
                            BlazeCreateStrategyPage(
                          settingsController: settingsController,
                        ),
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
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Adicionar estrategia',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: Icon(Icons.add),
                          )
                        ],
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
                                  if (input != null && input.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'digite algum valor';
                                  }
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                                controller:
                                    settingsController.stopGainController,
                                decoration: InputDecoration(
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff1bb57f), width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  labelText: 'Stop gain',
                                  labelStyle: TextStyle(color: Colors.white),
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
                                      Switch(
                                    value:
                                        settingsController.stopGainIsOn.value,
                                    onChanged: (bool? value) =>
                                        settingsController.stopGainIsOn.value =
                                            value!,
                                    inactiveThumbColor: const Color(0xfff12c4d),
                                    activeColor: const Color(0xff1bb57f),
                                    activeTrackColor: const Color(0xff0e0812),
                                  ),
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
                                  if (input != null && input.isNotEmpty) {
                                    return null;
                                  } else {
                                    return 'digite algum valor';
                                  }
                                },
                                keyboardType: TextInputType.number,
                                style: TextStyle(color: Colors.white),
                                controller:
                                    settingsController.stoplossController,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Color(0xff1bb57f), width: 1.0),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 1.0),
                                  ),
                                  labelText: 'Stop loss',
                                  labelStyle: TextStyle(color: Colors.white),
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
                                      Switch(
                                    value:
                                        settingsController.stopLossIsOn.value,
                                    onChanged: (bool? value) =>
                                        settingsController.stopLossIsOn.value =
                                            value!,
                                    inactiveThumbColor: const Color(0xfff12c4d),
                                    activeColor: const Color(0xff1bb57f),
                                    activeTrackColor: const Color(0xff0e0812),
                                  ),
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
                            controller:
                                settingsController.firstBetPriceController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff1bb57f), width: 1.0),
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
                            controller:
                                settingsController.firstBetWhiteController,
                            decoration: const InputDecoration(
                              fillColor: Colors.white,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color(0xff1bb57f), width: 1.0),
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
                            onChanged: (bool value) => settingsController
                                .galesIsOn
                                .value = !settingsController.galesIsOn.value,
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
                            valueListenable: settingsController.elevationIsOn,
                            builder: (BuildContext context, bool value,
                                    Widget? child) =>
                                Switch(
                              value: settingsController.elevationIsOn.value,
                              onChanged: (bool value) =>
                                  settingsController.elevationIsOn.value =
                                      !settingsController.elevationIsOn.value,
                              inactiveThumbColor: const Color(0xfff12c4d),
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
          onPressed: () =>
              validateAndSave().then((_) => Navigator.pop(context)),
          child: Icon(Icons.save),
        ),
      ),
    );
  }
}
