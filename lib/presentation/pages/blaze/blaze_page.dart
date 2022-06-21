import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';

import 'package:ia_bet/presentation/pages/blaze/components/custom_app_bar_blaze_page/custom_app_bar_blaze_page.dart';

import 'blaze_settings_page.dart';
import 'components/button-activity.dart';
import 'controller_settings.dart';

class BlazePage extends StatefulWidget {
  final double totalMoney;

  const BlazePage({Key? key, required this.totalMoney}) : super(key: key);

  @override
  State<BlazePage> createState() => _BlazePageState();
}

class _BlazePageState extends State<BlazePage> {
  final ValueNotifier<bool> isOnBalze = ValueNotifier<bool>(false);

  final SettingsController settingsController = SettingsController();

  void switchChange(bool value) => isOnBalze.value = value;

  @override
  void dispose() {
    isOnBalze.dispose();
    super.dispose();
  }

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
                        'R\$ ${widget.totalMoney.toStringAsFixed(2)}',
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
                      'R\$ ${settingsController.stopLoss.value.toStringAsFixed(2)}',
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
                ValueListenableBuilder(
                  valueListenable: isOnBalze,
                  builder: (BuildContext context, value, Widget? child) =>
                      ButtonActivity(
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
                                switchChange(value);
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
                    enabled: isOnBalze.value,
                    inactivityChild: Text(
                      'OFF',
                      style: TextStyle(
                        color: Color(0xfff12c4d),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                )
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
                        for (int index = 0;
                            index != settingsController.strategies.length;
                            index++)
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, right: 20, bottom: 15),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      settingsController.strategies[index]
                                              ['name']
                                          .toString()
                                          .toUpperCase(),
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 12),
                                    ),
                                    settingsController.strategies[index]
                                            ['value']
                                        ? const Icon(
                                            Icons.done,
                                            color: Color(0xff1bb57f),
                                          )
                                        : const Icon(
                                            Icons.close,
                                            color: Color(0xfff12c4d),
                                          )
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Container(
                                    height: 1,
                                    color: const Color(0xff0f1923),
                                  ),
                                )
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 30),
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
                                    for (int i = 0;
                                        i != settingsController.gales.length;
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
                                            '${settingsController.firstBet['price']}',
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
                                    for (Map<String, dynamic> gale
                                        in settingsController.gales)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Column(
                                          children: [
                                            Text(
                                              '${gale['price']}',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                      )
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
                                            '${settingsController.firstBet['white']}',
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
                                    for (Map<String, dynamic> gale
                                        in settingsController.gales)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 6.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${gale['white']}',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                  padding: const EdgeInsets.only(top: 10, bottom: 70),
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
                                    for (int i = 0;
                                        i !=
                                            settingsController
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
                                    for (int i = 0;
                                        i !=
                                            settingsController
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
                                              '${settingsController.elevations[i]}X',
                                              style: TextStyle(
                                                  color: Colors.white),
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
                                            '${settingsController.firstBet['price']}',
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
                                    for (int i = 0;
                                        i !=
                                            settingsController
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
                                              '${settingsController.gales[i]['price']}',
                                              style: TextStyle(
                                                  color: Colors.white),
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
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const BlazeSettingsPage(),
              ),
            );
          },
          child: Icon(Icons.settings),
        ),
      );
    });
  }
}
