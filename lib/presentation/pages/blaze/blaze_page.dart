import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';
import 'package:ia_bet/presentation/pages/blaze/components/custom_app_bar_blaze_page/custom_app_bar_blaze_page.dart';

import '../../../data/model/double_config_model.dart';
import '../../../domain/entities/double_config.dart';

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
      return Scaffold(
        backgroundColor: const Color(0xff0f1923),
        appBar: CustomAppBarBlazePage(
          height: 170,
          child: Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, top: 10),
                      child: RichText(
                        text: TextSpan(
                          text: 'Stop Gain: ',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          children: [
                            TextSpan(
                              text: (doubleConfigState is DoubleConfigLoaded)
                                  ? 'R\$ ${doubleConfigState.doubleConfig.amountStopGain.toStringAsFixed(2)}'
                                  : 'R\$--',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        text: 'Stop loss: ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        children: [
                          TextSpan(
                            text: (doubleConfigState is DoubleConfigLoaded)
                                ? 'R\$ ${doubleConfigState.doubleConfig.amountStopLoss.toStringAsFixed(2)}'
                                : '--',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
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
                                      isActiveGale: doubleConfigState
                                          .doubleConfig.isActiveGale,
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
                                  child: Text('Estrategias ativas'),
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
                          Column(
                              children: doubleConfigState
                                  .doubleConfig.strategies
                                  .map((Strategy strategy) {
                            return Column(
                              children: [
                                strategy.active
                                    ? Padding(
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
                                                const Icon(
                                                  Icons.done,
                                                  color: Color(0xff1bb57f),
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
                                      )
                                    : Container(),
                              ],
                            );
                          }).toList()),
                        if (doubleConfigState is! DoubleConfigLoaded)
                          Center(
                            child: CircularProgressIndicator(),
                          )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 20),
                  child: Container(
                    child: Card(
                      color: const Color(0xff0a1117),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 15, bottom: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: Text(
                                    'APOSTA',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  'Entrada',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: Text(
                                    'VALOR',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  (doubleConfigState is DoubleConfigLoaded)
                                      ? doubleConfigState
                                          .doubleConfig.entryAmount
                                          .toString()
                                      : '--',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 18.0),
                                  child: Text(
                                    'BRANCO',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                Text(
                                  (doubleConfigState is DoubleConfigLoaded)
                                      ? doubleConfigState
                                          .doubleConfig.entryWhiteAmount
                                          .toString()
                                      : '--',
                                  style: TextStyle(color: Colors.white),
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
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Card(
                            color: const Color(0xff0a1117),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 15),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              'APOSTA',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          if (doubleConfigState
                                              is DoubleConfigLoaded)
                                            for (int i = 0;
                                                i !=
                                                    doubleConfigState
                                                        .doubleConfig
                                                        .gales
                                                        .length;
                                                i++)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Container(
                                                        height: 1,
                                                        color: const Color(
                                                            0xff0f1923),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              'VALOR',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          if (doubleConfigState
                                              is DoubleConfigLoaded)
                                            for (Gale gale in doubleConfigState
                                                .doubleConfig.gales)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 6.0),
                                                child: Column(
                                                  children: [
                                                    Text(
                                                      '${gale.amount}',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Container(
                                                        height: 1,
                                                        color: const Color(
                                                            0xff0f1923),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 18.0),
                                            child: Text(
                                              'BRANCO',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          if (doubleConfigState
                                              is DoubleConfigLoaded)
                                            for (Gale gale in doubleConfigState
                                                .doubleConfig.gales)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 4),
                                                      child: Container(
                                                        height: 1,
                                                        color: const Color(
                                                            0xff0f1923),
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
                        (doubleConfigState is DoubleConfigLoaded)
                            ? Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Card(
                                  color: doubleConfigState
                                          .doubleConfig.isActiveGale
                                      ? Colors.green
                                      : Colors.red,
                                  child: Container(
                                    margin: EdgeInsets.all(3),
                                    child: Text(
                                      doubleConfigState
                                              .doubleConfig.isActiveGale
                                          ? 'Ativado'
                                          : 'Desativado',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                      ],
                    )),
                Padding(
                  padding: const EdgeInsets.only(bottom: 70),
                  child: Stack(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Card(
                          color: const Color(0xff0a1117),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, top: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'APOSTA',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        if (doubleConfigState
                                            is DoubleConfigLoaded)
                                          for (int i = 0;
                                              i !=
                                                  doubleConfigState.doubleConfig
                                                      .elevations.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18, bottom: 6),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Container(
                                                      height: 1,
                                                      color: const Color(
                                                          0xff0f1923),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'MULTIPLICADOR',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        if (doubleConfigState
                                            is DoubleConfigLoaded)
                                          for (int i = 0;
                                              i !=
                                                  doubleConfigState.doubleConfig
                                                      .elevations.length;
                                              i++)
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 18, bottom: 6),
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
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 4),
                                                    child: Container(
                                                      height: 1,
                                                      color: const Color(
                                                          0xff0f1923),
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
                      (doubleConfigState is DoubleConfigLoaded)
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10),
                              child: Card(
                                color: doubleConfigState
                                        .doubleConfig.isActiveElevation
                                    ? Colors.green
                                    : Colors.red,
                                child: Container(
                                  margin: EdgeInsets.all(3),
                                  child: Text(
                                    doubleConfigState
                                            .doubleConfig.isActiveElevation
                                        ? 'Ativado'
                                        : 'Desativado',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                    ],
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
                builder: (BuildContext context) => BlazeSettingsPage(),
              ),
            );
          },
          child: Icon(Icons.settings),
        ),
      );
    });
  }
}
