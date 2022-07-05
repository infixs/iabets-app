import 'package:flutter/material.dart';

import 'blaze_create_strategy_controller.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';

class BlazeCreateStrategyPage extends StatefulWidget {
  const BlazeCreateStrategyPage({Key? key}) : super(key: key);

  @override
  State<BlazeCreateStrategyPage> createState() =>
      _BlazeCreateStrategyPageState();
}

class _BlazeCreateStrategyPageState extends State<BlazeCreateStrategyPage> {
  final BlazeCreateStrategyController blazeCreateStrategyController =
      BlazeCreateStrategyController();

  void addResult(int index) {
    bool red = false;
    bool black = false;
    bool equal = false;
    bool isRule = false;

    final isNew = (blazeCreateStrategyController.results.length <= index);

    if (!isNew) {
      red = blazeCreateStrategyController.results[index]['red'];
      black = blazeCreateStrategyController.results[index]['black'];
    }

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) =>
                AlertDialog(
          title: Text('Cores'),
          content: SizedBox(
            height: index != 0 ? 245 : 100,
            child: Column(
              children: [
                Row(
                  children: [
                    Text('Vermelho'),
                    Switch(
                        value: red,
                        onChanged: (bool value) => setState(() => red = !red))
                  ],
                ),
                Row(
                  children: [
                    Text('Preto'),
                    Switch(
                        value: black,
                        onChanged: (bool value) =>
                            setState(() => black = !black))
                  ],
                ),
                index != 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Text(
                                    'Regras',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                ),
                                Switch(
                                    value: isRule,
                                    onChanged: (bool value) =>
                                        setState(() => isRule = !isRule))
                              ],
                            ),
                            isRule
                                ? SizedBox(
                                    height: 40,
                                    width: 100,
                                    child: PageView.builder(
                                      controller: blazeCreateStrategyController
                                          .pageControllerResults,
                                      itemCount: index,
                                      scrollDirection: Axis.vertical,
                                      itemBuilder:
                                          (BuildContext context, int index) =>
                                              Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(
                                          'Resultado ${index + 1}',
                                        ),
                                      ),
                                    ),
                                  )
                                : Container(),
                            isRule
                                ? Row(
                                    children: [
                                      Text('diferente'),
                                      Switch(
                                          value: equal,
                                          onChanged: (bool value) =>
                                              setState(() => equal = !equal)),
                                      Text('igual'),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container()
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                if (isNew) {
                  blazeCreateStrategyController.add({
                    'red': red,
                    'black': black,
                    'rules': isRule
                        ? {
                            'equal': isRule,
                            'reference':
                                blazeCreateStrategyController.getResultIndice()
                          }
                        : {}
                  });
                } else {
                  blazeCreateStrategyController.results.removeAt(index);
                  blazeCreateStrategyController.insert(index, {
                    'red': red,
                    'black': black,
                    'rules': isRule
                        ? {
                            'equal': isRule,
                            'reference':
                                blazeCreateStrategyController.getResultIndice()
                          }
                        : {}
                  });
                }

                Navigator.pop(context);
              },
              child: Text('Salvar'),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
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
              'Criar estrategia',
              style: TextStyle(color: Colors.white, fontSize: 20),
            )
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: blazeCreateStrategyController,
                builder: (BuildContext context, Widget? child) =>
                    ListView.builder(
                  shrinkWrap: true,
                  itemCount: (blazeCreateStrategyController.results.length + 1),
                  itemBuilder: (BuildContext context, int index) => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: EdgeInsets.zero,
                        primary: const Color(0xff0a1117),
                      ),
                      onPressed: () => addResult(index),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Resultado ${index + 1}',
                            style: TextStyle(fontSize: 18),
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
    );
  }
}
