import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/data/model/double_config_model.dart';
import 'package:ia_bet/data/model/entry_strategy_model.dart';
import 'package:ia_bet/data/model/result_rule_model.dart';
import 'package:ia_bet/data/model/result_strategy_model.dart';

import '../../../data/model/custom_strategy_model.dart';
import '../../../domain/entities/custom_strategy_entity.dart';
import '../../bloc/blaze/double_config_cubit.dart';

import 'blaze_create_strategy_controller.dart';
import 'components/custom_app_bar_settings/custom_app_bar_settings.dart';
import 'components/strategy_creation_entry_widget.dart';
import 'components/strategy_creation_item_widget.dart';
import 'controller_settings.dart';

class BlazeCreateStrategyPage extends StatefulWidget {
  final SettingsController settingsController;
  const BlazeCreateStrategyPage({Key? key, required this.settingsController})
      : super(key: key);

  @override
  State<BlazeCreateStrategyPage> createState() =>
      _BlazeCreateStrategyPageState();
}

class _BlazeCreateStrategyPageState extends State<BlazeCreateStrategyPage> {
  final BlazeCreateStrategyController blazeCreateStrategyController =
      BlazeCreateStrategyController();
  final TextEditingController textEditingControllerName =
      TextEditingController();
  final List<EntryStrategyModel> entrys = [];
  final ValueNotifier<int> numberEntrys = ValueNotifier<int>(1);
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void dispose() {
    numberEntrys.dispose();
    super.dispose();
  }

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
                blazeCreateStrategyController.strategyes.isNotEmpty ? 320 : 200,
            child: Column(children: [
              const Text(
                'Seleciona as cores',
                style: TextStyle(color: Colors.white),
              ),
              Row(
                children: [
                  const Text(
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
                  const Text(
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
                  const Text(
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
              blazeCreateStrategyController.strategyes.isNotEmpty
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
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
                                      const Text(
                                        'Operação',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: DropdownButton<bool>(
                                          dropdownColor:
                                              const Color(0xff0f1923),
                                          style: const TextStyle(
                                              color: Colors.white),
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
                                      const Text(
                                        'Posição',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15),
                                        child: DropdownButton<int>(
                                          dropdownColor:
                                              const Color(0xff0f1923),
                                          style: const TextStyle(
                                              color: Colors.white),
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
                padding: const EdgeInsets.all(0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                final List<StrategyColors> colors = [];
                List<ResultRuleModel>? rules;
                if (red) {
                  colors.add(StrategyColors.red);
                }
                if (black) {
                  colors.add(StrategyColors.black);
                }
                if (white) {
                  colors.add(StrategyColors.white);
                }

                if (isRuleActive) {
                  if (equal) {
                    rules = List.from([
                      (ResultRuleModel(
                          operator: ResultRuleOperator.equal,
                          position: buttonValue))
                    ]);
                  } else {
                    rules = List.from([
                      (ResultRuleModel(
                          operator: ResultRuleOperator.different,
                          position: buttonValue))
                    ]);
                  }
                }

                final ResultStrategyModel value = ResultStrategyModel(
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
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff1bb57f),
                      Color(0xff08835d),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(child: Text('Salvar')),
              ),
            )
          ],
        ),
      ),
    );
  }

  void saveStrategy() =>
      (entrys.isNotEmpty && blazeCreateStrategyController.strategyes.isNotEmpty)
          ? showDialog<void>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Salvar'),
                content: Form(
                  key: formkey,
                  child: TextFormField(
                    validator: (String? input) {
                      if (input != null && input.isNotEmpty) {
                        return null;
                      } else {
                        return 'digite algum valor';
                      }
                    },
                    controller: textEditingControllerName,
                    decoration: const InputDecoration(
                      labelText: 'Nome da estrategia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancelar'),
                  ),
                  TextButton(
                    onPressed: () {
                      final bool isValid = formkey.currentState!.validate();

                      if (isValid) {
                        final CustomStrategyModel customStrategyModel =
                            CustomStrategyModel(
                          resultStrategyEntities:
                              blazeCreateStrategyController.strategyes,
                          entryStrategies: entrys,
                          name: textEditingControllerName.text,
                        );

                        widget.settingsController.doubleConfigCopy
                            ?.customStrategies
                            .add(customStrategyModel);

                        final DoubleConfigModel doubleConfig = DoubleConfigModel(
                            enabled: widget
                                .settingsController.doubleConfigCopy!.enabled,
                            isActiveGale: widget.settingsController
                                .doubleConfigCopy!.isActiveGale,
                            isActiveStopGain: widget.settingsController
                                .doubleConfigCopy!.isActiveStopGain,
                            isActiveStopLoss: widget.settingsController
                                .doubleConfigCopy!.isActiveStopLoss,
                            wallet: widget
                                .settingsController.doubleConfigCopy!.wallet,
                            amountStopGain: widget.settingsController
                                .doubleConfigCopy!.amountStopGain,
                            amountStopLoss: widget.settingsController
                                .doubleConfigCopy!.amountStopLoss,
                            maxGales: widget
                                .settingsController.doubleConfigCopy!.maxGales,
                            maxElevation: widget.settingsController
                                .doubleConfigCopy!.maxElevation,
                            gales: widget
                                .settingsController.doubleConfigCopy!.gales,
                            elevations: widget.settingsController
                                .doubleConfigCopy!.elevations,
                            isActiveElevation: widget.settingsController.doubleConfigCopy!.isActiveElevation,
                            strategies: widget.settingsController.doubleConfigCopy!.strategies,
                            entryAmount: widget.settingsController.doubleConfigCopy!.entryAmount,
                            entryWhiteAmount: widget.settingsController.doubleConfigCopy!.entryWhiteAmount,
                            customStrategies: widget.settingsController.doubleConfigCopy!.customStrategies);

                        BlocProvider.of<DoubleConfigCubit>(context)
                            .saveDoubleConfig(doubleConfig);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('Salvar'),
                  )
                ],
              ),
            )
          : showDialog<void>(
              context: context,
              builder: (BuildContext context) {
                Future.delayed(
                    const Duration(seconds: 2), () => Navigator.pop(context));
                return const AlertDialog(
                  content: Text('Você precisa configurar a entrada'),
                );
              },
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
        builder: (BuildContext context, Widget? child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            blazeCreateStrategyController.strategyes.isNotEmpty
                ? const Padding(
                    padding: EdgeInsets.only(left: 20, top: 10),
                    child: Text(
                      'Resultados',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  )
                : Container(),
            ListView.builder(
              shrinkWrap: true,
              itemCount: blazeCreateStrategyController.strategyes.length,
              itemBuilder: (BuildContext context, int index) =>
                  StrategyCreationitemWidget(
                index: index,
                strategy: blazeCreateStrategyController.strategyes[index],
              ),
            ),
            blazeCreateStrategyController.strategyes.isNotEmpty
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 10),
                        child: Row(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 175),
                              child: Text(
                                'Entradas',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                            const Text(
                              'Adicionar',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                            IconButton(
                              onPressed: () {
                                numberEntrys.value++;
                              },
                              icon: const Icon(
                                Icons.add,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      ),
                      ValueListenableBuilder(
                        valueListenable: numberEntrys,
                        builder:
                            (BuildContext context, int value, Widget? child) =>
                                ListView.builder(
                          shrinkWrap: true,
                          itemCount: numberEntrys.value,
                          itemBuilder: (BuildContext context, int index) =>
                              StrategyCreationEntryWidget(
                            entrys: entrys,
                            index: index,
                          ),
                        ),
                      ),
                    ],
                  )
                : Container()
          ],
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xff1bb57f),
            heroTag: "btn1",
            onPressed: addStrategy,
            child: const Icon(Icons.add),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: FloatingActionButton(
              backgroundColor: const Color(0xff1bb57f),
              heroTag: "btn2",
              onPressed: saveStrategy,
              child: const Icon(Icons.save),
            ),
          ),
        ],
      ),
    );
  }
}
