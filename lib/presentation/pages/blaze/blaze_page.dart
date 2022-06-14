import 'package:flutter/material.dart';

import 'components/button-activity.dart';
import 'components/custom_app_bar/custom_app_bar.dart';
import 'settings_blaze_page.dart';
import 'settings_controller.dart';

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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0f1923),
      appBar: CustomAppBar(
        height: 150,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => const SettingsPage(),
              ),
            );
          },
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
                      'R\$ ${settingsController.stopGain.value.toStringAsFixed(2)}',
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
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.white),
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
                        color: Colors.red,
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
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
          child: Column(
            children: [
              SizedBox(
                height: size.height * 0.35,
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
                      ListView.builder(
                        shrinkWrap: true,
                        itemCount: settingsController.strategies.length,
                        itemBuilder: (BuildContext context, int index) =>
                            Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, bottom: 15),
                          child: Column(
                            children: [
                              SizedBox(
                                width: size.width * 0.8,
                                child: Row(
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
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Container(
                                  height: 1,
                                  width: size.width * 0.8,
                                  color: const Color(0xff0f1923),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: SizedBox(
                  height: size.height * 0.3,
                  width: size.width * 0.95,
                  child: Card(
                    color: const Color(0xff0a1117),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top: 15, left: 30),
                                  child: Text('APOSTA',
                                      style: TextStyle(color: Colors.white)),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 50, right: 20),
                                  child: Stack(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.only(top: 15),
                                        child: Text(
                                          'VALOR',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.only(left: 45),
                                        padding: EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Color(0xff1bb57f),
                                        ),
                                        child: Text(
                                          'R\$ ${settingsController.firstBet['price']}',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(top: 15),
                                      child: Text(
                                        'BRANCO',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(left: 55),
                                      padding: EdgeInsets.all(3),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Color(0xff1bb57f),
                                      ),
                                      child: Text(
                                        'R\$ ${settingsController.firstBet['white']}',
                                        style: const TextStyle(
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Spacer(),
                              Flexible(
                                flex: 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: settingsController.gales.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${index + 1}° Gale',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 1,
                                            width: size.width * 0.8,
                                            color: const Color(0xff0f1923),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Flexible(
                                flex: 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: settingsController.gales.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'R\$ ${settingsController.gales[index]['price']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 1,
                                            width: size.width * 0.8,
                                            color: const Color(0xff0f1923),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Flexible(
                                flex: 2,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: settingsController.gales.length,
                                  itemBuilder:
                                      (BuildContext context, int index) =>
                                          Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8, bottom: 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${settingsController.gales[index]['white']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 4),
                                          child: Container(
                                            height: 1,
                                            width: size.width * 0.8,
                                            color: const Color(0xff0f1923),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
