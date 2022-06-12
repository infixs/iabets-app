import 'package:flutter/material.dart';

import 'components/custom_app_bar/custom_app_bar.dart';
import 'settings_blaze_page.dart';
import 'settings_controller.dart';

class BlazePage extends StatefulWidget {
  final double totalMoney;

  const BlazePage({
    Key? key,
    required this.totalMoney,
  }) : super(key: key);

  @override
  State<BlazePage> createState() => _BlazePageState();
}

class _BlazePageState extends State<BlazePage> {
  final ValueNotifier<bool> isOnBalze = ValueNotifier<bool>(false);

  final SettingsController settingsController = SettingsController();

  void switchChange(bool value) => isOnBalze.value = !isOnBalze.value;

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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 25),
                      ),
                    ),
                    Text(
                      'R\$ ${settingsController.stopGain.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Text(
                        'Stop Gain',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                    Text(
                      'R\$ ${settingsController.stopLoss.value.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    const Text(
                      'Stop Loss',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
                ValueListenableBuilder(
                  valueListenable: isOnBalze,
                  builder: (BuildContext context, value, Widget? child) => Row(
                    children: [
                      Text(
                        'Off',
                        style: TextStyle(
                            color: isOnBalze.value
                                ? Colors.transparent
                                : Colors.white),
                      ),
                      Switch(
                        value: isOnBalze.value,
                        onChanged: switchChange,
                        inactiveThumbColor: const Color(0xff0f1923),
                        activeColor: const Color(0xff1bb57f),
                        activeTrackColor: const Color(0xff0f1923),
                      ),
                      Text(
                        'On',
                        style: TextStyle(
                            color: isOnBalze.value
                                ? Colors.white
                                : Colors.transparent),
                      ),
                    ],
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
                width: size.width * 0.85,
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
                              onPressed: () {},
                              icon: const Icon(
                                Icons.arrow_circle_up,
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
                              left: 8, right: 8, bottom: 8),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    settingsController.strategies[index]
                                        ['name'],
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  settingsController.strategies[index]['value']
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
                              Container(
                                height: 1,
                                width: size.width * 0.8,
                                color: const Color(0xff0f1923),
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
                  width: size.width * 0.85,
                  child: Card(
                    color: const Color(0xff0a1117),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text('Cor',
                                        style: TextStyle(color: Colors.white)),
                                    Text('aposta',
                                        style: TextStyle(color: Colors.white)),
                                  ],
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Preço',
                                      style: TextStyle(color: Colors.white)),
                                  Text(
                                      'R\$ ${settingsController.firstBet['price']}',
                                      style:
                                          const TextStyle(color: Colors.white)),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(right: 25),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text('Branco',
                                        style: TextStyle(color: Colors.white)),
                                    Text(
                                        'R\$ ${settingsController.firstBet['white']}',
                                        style: const TextStyle(
                                            color: Colors.white)),
                                  ],
                                ),
                              ),
                            ],
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
                                        top: 4, bottom: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${index + 1}° Gale',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Container(
                                          height: 1,
                                          width: size.width * 0.8,
                                          color: const Color(0xff0f1923),
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
                                        top: 4, bottom: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'R\$ ${settingsController.gales[index]['price']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Container(
                                          height: 1,
                                          width: size.width * 0.8,
                                          color: const Color(0xff0f1923),
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
                                        top: 4, bottom: 4),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '${settingsController.gales[index]['white']}',
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        Container(
                                          height: 1,
                                          width: size.width * 0.8,
                                          color: const Color(0xff0f1923),
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
