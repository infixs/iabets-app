import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';

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

  final ValueNotifier<bool> stopGainIsOn = ValueNotifier<bool>(true);
  final ValueNotifier<bool> stopLossIsOn = ValueNotifier<bool>(true);

  @override
  void dispose() {
    settingsController.dispose();
    stopGainIsOn.dispose();
    stopLossIsOn.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
                  child: Column(
                    children: [
                      for (int index = 0;
                          index != settingsController.strategies.length;
                          index++)
                        Column(
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
                                  inactiveThumbColor: const Color(0xfff12c4d),
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
                        ),
                    ],
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
                              style: TextStyle(color: Colors.white),
                              controller: settingsController.stopGainController,
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
                                valueListenable: stopGainIsOn,
                                builder: (BuildContext context, value,
                                        Widget? child) =>
                                    Checkbox(
                                        value: stopGainIsOn.value,
                                        onChanged: (bool? value) =>
                                            stopGainIsOn.value = value!),
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
                                  valueListenable: stopLossIsOn,
                                  builder: (BuildContext context, value,
                                          Widget? child) =>
                                      Checkbox(
                                          value: stopLossIsOn.value,
                                          onChanged: (bool? value) =>
                                              stopLossIsOn.value = value!),
                                ),
                              )
                            ],
                          )),
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
                    children: [
                      const Spacer(),
                      Flexible(
                        flex: 15,
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
                      const Spacer(flex: 2),
                      Flexible(
                        flex: 15,
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
          BlocProvider.of<DoubleConfigCubit>(context)
              .saveDoubleConfig(widget.doubleConfig);
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
