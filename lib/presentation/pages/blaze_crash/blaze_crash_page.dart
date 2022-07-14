import 'package:flutter/material.dart';

import '../blaze_double/components/custom_app_bar_settings/custom_app_bar_settings.dart';

import 'blaze_crash_controller.dart';

class BlazeCrashPage extends StatefulWidget {
  const BlazeCrashPage({super.key});

  @override
  State<BlazeCrashPage> createState() => _BlazeCrashPageState();
}

class _BlazeCrashPageState extends State<BlazeCrashPage> {
  final CrashController crashController = CrashController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0f1923),
      appBar: CustomAppBarSettings(
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            const Text(
              'Blaze Crash',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 100,
              width: 250,
              child: Card(
                color: const Color(0xff0a1117),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'CHANCE DE CRASH FAVORÁVEL',
                        style: TextStyle(color: Colors.white),
                      ),
                      StreamBuilder(
                        stream: crashController.getChance(),
                        builder: (BuildContext context,
                                AsyncSnapshot<String> snapshot) =>
                            (snapshot.data != null)
                                ? Text(
                                    snapshot.data!,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  )
                                : const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 250,
              width: 250,
              child: Card(
                color: const Color(0xff0a1117),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: StreamBuilder(
                    stream: crashController.getData(),
                    builder: (BuildContext context,
                            AsyncSnapshot<List<String>?> snapshot) =>
                        snapshot.data != null
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Vela sinal',
                                    style: TextStyle(
                                        color: Colors.pink, fontSize: 20),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 12),
                                    child: Text(
                                      snapshot.data!.first,
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 40),
                                    ),
                                  ),
                                  const Text(
                                    'Entrada apos',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16),
                                  ),
                                  Text(
                                    snapshot.data!.last,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 30),
                                  ),
                                  const Text(
                                    'CASAS APÓS',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    'A VELA SINAL',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  const Text(
                                    ' ',
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                ],
                              )
                            : Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Text(
                                    'AGUARDANDO SINAL',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Center(
                                    child: CircularProgressIndicator(),
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
    );
  }
}
