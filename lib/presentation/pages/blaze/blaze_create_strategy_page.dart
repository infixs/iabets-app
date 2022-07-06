import 'package:flutter/material.dart';

import 'blaze_create_strategy_controller.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'components/strategy_creation_item_widget.dart';

class BlazeCreateStrategyPage extends StatefulWidget {
  const BlazeCreateStrategyPage({Key? key}) : super(key: key);

  @override
  State<BlazeCreateStrategyPage> createState() =>
      _BlazeCreateStrategyPageState();
}

class _BlazeCreateStrategyPageState extends State<BlazeCreateStrategyPage> {
  final BlazeCreateStrategyController blazeCreateStrategyController =
      BlazeCreateStrategyController();

  void addStrategy() {
    List<int> positions = [];

    for (int i = 0; i != blazeCreateStrategyController.strategyes.length; i++) {
      positions.add(i);
    }

    int buttonValue = 0;

    bool red = false;
    bool black = false;
    bool white = false;
    bool equal = false;
    bool isRuleActive = false;

    showDialog<void>(
      context: context,
      builder: (BuildContext context) => StatefulBuilder(
        builder:
            (BuildContext context, void Function(void Function()) setState) =>
                AlertDialog(
          backgroundColor: const Color(0xff0f1923),
          content: SizedBox(
            height:
                blazeCreateStrategyController.strategyes.length > 0 ? 320 : 200,
            child: Column(children: [
              Text(
                'Seleciona as cores',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  Text(
                    'vermelho',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: red,
                    onChanged: (bool? value) => setState(() => red = !red),
                    inactiveThumbColor: const Color(0xfff12c4d),
                    activeColor: const Color(0xff1bb57f),
                    activeTrackColor: const Color(0xff0e0812),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'preto',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: black,
                    onChanged: (bool? value) => setState(() => black = !black),
                    inactiveThumbColor: const Color(0xfff12c4d),
                    activeColor: const Color(0xff1bb57f),
                    activeTrackColor: const Color(0xff0e0812),
                  )
                ],
              ),
              Row(
                children: [
                  Text(
                    'Branco',
                    style: TextStyle(color: Colors.white),
                  ),
                  Switch(
                    value: white,
                    onChanged: (bool? value) => setState(() => white = !white),
                    inactiveThumbColor: const Color(0xfff12c4d),
                    activeColor: const Color(0xff1bb57f),
                    activeTrackColor: const Color(0xff0e0812),
                  )
                ],
              ),
              blazeCreateStrategyController.strategyes.length > 0
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Regras',
                              style: TextStyle(color: Colors.white),
                            ),
                            Switch(
                              value: isRuleActive,
                              onChanged: (bool? value) =>
                                  setState(() => isRuleActive = !isRuleActive),
                              inactiveThumbColor: const Color(0xfff12c4d),
                              activeColor: const Color(0xff1bb57f),
                              activeTrackColor: const Color(0xff0e0812),
                            ),
                          ],
                        ),
                        isRuleActive
                            ? Column(
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Operação',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: DropdownButton<bool>(
                                          dropdownColor:
                                              const Color(0xff0f1923),
                                          style: TextStyle(color: Colors.white),
                                          value: equal,
                                          items: [true, false]
                                              .map<DropdownMenuItem<bool>>(
                                                  (bool value) =>
                                                      DropdownMenuItem<bool>(
                                                        value: value,
                                                        child: Text(
                                                          value
                                                              ? 'Igual'
                                                              : 'Diferente',
                                                        ),
                                                      ))
                                              .toList(),
                                          onChanged: (value) =>
                                              setState(() => equal = value!),
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        'Posição',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: DropdownButton<int>(
                                          dropdownColor:
                                              const Color(0xff0f1923),
                                          style: TextStyle(color: Colors.white),
                                          value: buttonValue,
                                          items: positions
                                              .map<DropdownMenuItem<int>>(
                                                (int value) =>
                                                    DropdownMenuItem<int>(
                                                  value: value,
                                                  child: Text(
                                                    'Resultado ${value + 1}',
                                                  ),
                                                ),
                                              )
                                              .toList(),
                                          onChanged: (value) => setState(
                                              () => buttonValue = value!),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              )
                            : Container(),
                      ],
                    )
                  : Container()
            ]),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final List<StrategyColors> colors = [];
                List<ResultRule>? rules;
                if (red) {
                  colors.add(StrategyColors.Red);
                }
                if (black) {
                  colors.add(StrategyColors.Black);
                }
                if (white) {
                  colors.add(StrategyColors.White);
                }

                if (isRuleActive) {
                  if (equal) {
                    rules = List.from([
                      (ResultRule(
                          operator: ResultRuleOperator.Equal,
                          position: buttonValue))
                    ]);
                  } else {
                    rules = List.from([
                      (ResultRule(
                          operator: ResultRuleOperator.Different,
                          position: buttonValue))
                    ]);
                  }
                }

                final ResultStrategyEntity value = ResultStrategyEntity(
                  colors: colors,
                  rules: rules,
                );

                blazeCreateStrategyController.add(value);
                Navigator.pop(context);
              },
              child: Container(
                width: 70,
                height: 40,
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
                child: Center(child: Text('Salvar')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveStrategy() => showDialog<void>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Salvar'),
          content: TextField(
            decoration: InputDecoration(
              labelText: 'Nome da estrategia',
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {},
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {},
              child: Text('Salvar'),
            )
          ],
        ),
      );

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
      body: AnimatedBuilder(
        animation: blazeCreateStrategyController,
        builder: (BuildContext context, Widget? child) => ListView.builder(
          itemCount: blazeCreateStrategyController.strategyes.length,
          itemBuilder: (BuildContext context, int index) =>
              StrategyCreationitemWidget(
            index: index,
            strategy: blazeCreateStrategyController.strategyes[index],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xff1bb57f),
            heroTag: "btn1",
            onPressed: addStrategy,
            child: Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: FloatingActionButton(
              backgroundColor: const Color(0xff1bb57f),
              heroTag: "btn2",
              onPressed: saveStrategy,
              child: Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}
