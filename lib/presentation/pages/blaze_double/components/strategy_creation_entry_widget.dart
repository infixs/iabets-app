import 'package:flutter/material.dart';

import 'package:ia_bet/data/model/entry_strategy_model.dart';

import '../../../../domain/entities/custom_strategy_entity.dart';

class StrategyCreationEntryWidget extends StatefulWidget {
  final List<EntryStrategyModel> entrys;
  final int index;
  const StrategyCreationEntryWidget(
      {super.key, required this.entrys, required this.index});

  @override
  State<StrategyCreationEntryWidget> createState() =>
      _StrategyCreationEntryWidgetState();
}

class _StrategyCreationEntryWidgetState
    extends State<StrategyCreationEntryWidget> {
  StrategyColors? colorTarget;
  final ValueNotifier<String> colorTargetText = ValueNotifier<String>('');
  StrategyColors? colorResult;
  final ValueNotifier<String> colorResultText = ValueNotifier<String>('');

  @override
  void dispose() {
    colorTargetText.dispose();
    colorResultText.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 75,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 6),
              child: Text(
                'Resultado',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: colorResultText,
              builder: (BuildContext context, value, Widget? child) =>
                  DropdownButton<String>(
                dropdownColor: const Color(0xff0f1923),
                style: const TextStyle(color: Colors.white),
                value: colorResultText.value,
                items: <String>[
                  '',
                  'Vermelho',
                  'Preto',
                  'Branco',
                ]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  colorResultText.value = value!;
                  if (colorResultText.value == 'Vermelho') {
                    colorResult = StrategyColors.red;
                  } else if (colorResultText.value == 'Preto') {
                    colorResult = StrategyColors.black;
                  } else if (colorResultText.value == 'Branco') {
                    colorResult = StrategyColors.white;
                  }
                  if (colorResult != null && colorTarget != null) {
                    if (widget.entrys.length > widget.index) {
                      widget.entrys.removeAt(widget.index);
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategyModel(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    } else {
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategyModel(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    }
                  }
                },
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 6, right: 6),
              child: Text(
                'Entrada',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            ValueListenableBuilder(
              valueListenable: colorTargetText,
              builder: (BuildContext context, value, Widget? child) =>
                  DropdownButton<String>(
                dropdownColor: const Color(0xff0f1923),
                style: const TextStyle(color: Colors.white),
                value: colorTargetText.value,
                items: <String>[
                  '',
                  'Vermelho',
                  'Preto',
                  'Branco',
                ]
                    .map<DropdownMenuItem<String>>(
                      (String value) => DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  colorTargetText.value = value!;
                  if (colorTargetText.value == 'Vermelho') {
                    colorTarget = StrategyColors.red;
                  } else if (colorTargetText.value == 'Preto') {
                    colorTarget = StrategyColors.black;
                  } else if (colorTargetText.value == 'Branco') {
                    colorTarget = StrategyColors.white;
                  }
                  if (colorResult != null && colorTarget != null) {
                    if (widget.entrys.length > widget.index) {
                      widget.entrys.removeAt(widget.index);
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategyModel(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    } else {
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategyModel(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    }
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
