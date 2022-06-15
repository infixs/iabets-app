import 'package:flutter/material.dart';

import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'settings_controller.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final SettingsController settingsController = SettingsController();

  @override
  void dispose() {
    settingsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  controller: settingsController.stopGainController,
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xff1bb57f), width: 1.0),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white, width: 1.0),
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TextFormField(
                    controller: settingsController.stoplossController,
                    decoration: const InputDecoration(
                      fillColor: Colors.white,
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Color(0xff1bb57f), width: 1.0),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white, width: 1.0),
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
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: settingsController.strategies.length,
                  itemBuilder: (BuildContext context, int index) => Padding(
                    padding:
                        const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              settingsController.strategies[index]['name'],
                              style: const TextStyle(color: Colors.white),
                            ),
                            Switch(
                              value: settingsController.strategies[index]
                                  ['value'],
                              onChanged: (value) {
                                setState(() {
                                  settingsController.strategies[index]
                                          ['value'] =
                                      !settingsController.strategies[index]
                                          ['value'];
                                });
                              },
                              inactiveThumbColor: const Color(0xff0f1923),
                              activeColor: const Color(0xff1bb57f),
                              activeTrackColor: const Color(0xff0e0812),
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
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text(
                    'Aposta de entrada',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    children: [
                      Flexible(
                        flex: 5,
                        child: TextFormField(
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
                      const Spacer(),
                      Flexible(
                        flex: 5,
                        child: TextFormField(
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(
          left: 20,
          right: 20,
          bottom: 25,
        ),
        child: SizedBox(
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: const Color(0xff1bb57f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: const BorderSide(
                  color: Color(0xff1bb57f),
                ),
              ),
            ),
            onPressed: () {
              settingsController.saveConfig();
            },
            child: const Center(
              child: Text('Salvar'),
            ),
          ),
        ),
      ),
    );
  }
}
