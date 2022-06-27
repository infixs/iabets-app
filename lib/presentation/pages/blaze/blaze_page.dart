import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';
import 'package:ia_bet/presentation/pages/blaze/components/custom_app_bar_blaze_page/custom_app_bar_blaze_page.dart';

import '../../../data/model/double_config_model.dart';
import '../../../domain/entities/double_config.dart';
import '../../../domain/entities/strategy_entity.dart';

import 'blaze_settings_page.dart';
import 'components/button-activity.dart';

class BlazePage extends StatefulWidget {
  const BlazePage({Key? key}) : super(key: key);

  @override
  State<BlazePage> createState() => _BlazePageState();
}

class _BlazePageState extends State<BlazePage> {
  @override
  void initState() {
    BlocProvider.of<DoubleConfigCubit>(context).getDoubleConfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<DoubleConfigCubit, DoubleConfigState>(
        builder: (context, doubleConfigState) {
      if (doubleConfigState is DoubleConfigLoaded) {
        print(doubleConfigState.doubleConfig.wallet);
        print(doubleConfigState.doubleConfig.amountStopGain);
        print(doubleConfigState.doubleConfig.amountStopLoss);
      }

      return Scaffold(
        backgroundColor: const Color(0xff0f1923),
        appBar: CustomAppBarBlazePage(
          height: 150,
          child: Padding(
            padding: const EdgeInsets.only(top: 15, left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        (doubleConfigState is DoubleConfigLoaded)
                            ? 'R\$ ${(doubleConfigState.doubleConfig.wallet ?? 0).toStringAsFixed(2)}'
                            : '--',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Text(
                      (doubleConfigState is DoubleConfigLoaded)
                          ? doubleConfigState.doubleConfig.amountStopGain
                              .toString()
                          : 'R\$--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Stop Gain',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      (doubleConfigState is DoubleConfigLoaded)
                          ? 'R\$ ${doubleConfigState.doubleConfig.amountStopLoss.toStringAsFixed(2)}'
                          : '--',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        //fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Stop Loss',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
                (doubleConfigState is DoubleConfigLoaded)
                    ? ButtonActivity(
                        activeColors: const [
                          Color.fromARGB(255, 58, 58, 58),
                          Color.fromARGB(255, 43, 40, 40),
                        ],
                        inactiveColors: const [
                          Color.fromARGB(255, 43, 40, 40),
                          Color.fromARGB(255, 58, 58, 58),
                        ],
                        onPressed: (value) {
                          showDialog<void>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                              content: Text(
                                  'Deseja ${value ? 'ativar' : 'desativar'} as apostas automaticas.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    final DoubleConfigModel doubleConfig =
                                        DoubleConfigModel(
                                      amountStopGain: doubleConfigState
                                          .doubleConfig.amountStopGain,
                                      amountStopLoss: doubleConfigState
                                          .doubleConfig.amountStopLoss,
                                      elevations: doubleConfigState
                                          .doubleConfig.elevations,
                                      enabled: !doubleConfigState
                                          .doubleConfig.enabled,
                                      entryAmount: doubleConfigState
                                          .doubleConfig.entryAmount,
                                      entryWhiteAmount: doubleConfigState
                                          .doubleConfig.entryWhiteAmount,
                                      gales:
                                          doubleConfigState.doubleConfig.gales,
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
                                    BlocProvider.of<DoubleConfigCubit>(context)
                                        .saveDoubleConfig(doubleConfig);
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    '${value ? 'Ativar' : 'Desativar'}',
                                  ),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(
                                    'Cancelar',
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                        activityChild: Text(
                          'ON',
                          style: TextStyle(
                            color: Color(0xff1bb57f),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        enabled: doubleConfigState.doubleConfig.enabled,
                        inactivityChild: Text(
                          'OFF',
                          style: TextStyle(
                            color: Color(0xfff12c4d),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : Center(
                        child: CircularProgressIndicator(),
                      ),
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
            child: Column(
              children: [
                SizedBox(
                  width: size.width * 0.95,
                  child: Card(
                    color: const Color(0xff0a1117),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: const Color(0xff0f1923),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side: const BorderSide(
                                      color: Color(0xff0f1923),
                                    ),
                                  ),
                                ),
                                onPressed: () {},
                                child: const Center(
                                  child: Text('Estrategias'),
                                ),
                              ),
                              IconButton(
                                splashRadius: 15,
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.keyboard_arrow_up,
                                  color: Colors.white,
                                ),
                              )
                            ],
                          ),
                        ),
                        if (doubleConfigState is DoubleConfigLoaded)
                          FutureBuilder<List<StrategyEntity>>(
                            future: BlocProvider.of<DoubleConfigCubit>(context)
                                .getStrategies(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<StrategyEntity>> snapshot) {
                              if (!snapshot.hasData)
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              else {
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

                                      return strategy;
                                    },
                                  );
                                  return Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20, right: 20, bottom: 15),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  strategy.name
                                                      .toString()
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12),
                                                ),
                                                strategy.active
                                                    ? const Icon(
                                                        Icons.done,
                                                        color:
                                                            Color(0xff1bb57f),
                                                      )
                                                    : const Icon(
                                                        Icons.close,
                                                        color:
                                                            Color(0xfff12c4d),
                                                      )
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0),
                                              child: Container(
                                                height: 1,
                                                color: const Color(0xff0f1923),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList());
                              }
                            },
                          ),
                        if (doubleConfigState is! DoubleConfigLoaded)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: SizedBox(
                    child: Card(
                      color: const Color(0xff0a1117),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'APOSTA',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Entrada',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 1,
                                              color: const Color(0xff0f1923),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (doubleConfigState is DoubleConfigLoaded)
                                      for (int i = 0;
                                          i !=
                                              doubleConfigState
                                                  .doubleConfig.gales.length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${i + 1}° Gale',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      const Color(0xff0f1923),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'VALOR',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (doubleConfigState
                                                    is DoubleConfigLoaded)
                                                ? '${doubleConfigState.doubleConfig.entryAmount}'
                                                : '--',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 1,
                                              color: const Color(0xff0f1923),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (doubleConfigState is DoubleConfigLoaded)
                                      for (Gale gale in doubleConfigState
                                          .doubleConfig.gales)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            children: [
                                              Text(
                                                '${gale.amount}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      const Color(0xff0f1923),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'BRANCO',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (doubleConfigState
                                                    is DoubleConfigLoaded)
                                                ? '${doubleConfigState.doubleConfig.entryWhiteAmount}'
                                                : '--',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 1,
                                              color: const Color(0xff0f1923),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (doubleConfigState is DoubleConfigLoaded)
                                      for (Gale gale in doubleConfigState
                                          .doubleConfig.gales)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${gale.amountProtection}',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      const Color(0xff0f1923),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: SizedBox(
                    child: Card(
                      color: const Color(0xff0a1117),
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 15),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'APOSTA',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Entrada',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 1,
                                              color: const Color(0xff0f1923),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (doubleConfigState is DoubleConfigLoaded)
                                      for (int i = 0;
                                          i !=
                                              doubleConfigState.doubleConfig
                                                  .elevations.length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${i + 1}° Loss',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      const Color(0xff0f1923),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'MULTIPLICADOR',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 18, bottom: 6),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            '1X',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 4),
                                            child: Container(
                                              height: 1,
                                              color: const Color(0xff0f1923),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    if (doubleConfigState is DoubleConfigLoaded)
                                      for (int i = 0;
                                          i !=
                                              doubleConfigState.doubleConfig
                                                  .elevations.length;
                                          i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                '${doubleConfigState.doubleConfig.elevations[i]}X',
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4),
                                                child: Container(
                                                  height: 1,
                                                  color:
                                                      const Color(0xff0f1923),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xff1bb57f),
          onPressed: () {
            if (doubleConfigState is! DoubleConfigLoaded) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => BlazeSettingsPage(
                    doubleConfig: doubleConfigState.doubleConfig),
              ),
            );
          },
          child: Icon(Icons.settings),
        ),
      );
    });
  }
}
