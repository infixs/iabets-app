import 'package:flutter/material.dart';

import '../../../../domain/entities/custom_strategy_entity.dart';

class StrategyCreationEntryWidget extends StatefulWidget {
  final List<EntryStrategy> entrys;
  final int index;
  const StrategyCreationEntryWidget(
      {Key? key, required this.entrys, required this.index})
      : super(key: key);

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
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
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
                style: TextStyle(color: Colors.white),
                value: colorResultText.value,
                items: <String>[
                  '',
                  'Vermelho',
                  'Preto',
                  'Branco',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  colorResultText.value = value!;
                  if (colorResultText.value == 'Vermelho') {
                    colorResult = StrategyColors.Red;
                  } else if (colorResultText.value == 'Preto') {
                    colorResult = StrategyColors.Black;
                  } else if (colorResultText.value == 'Branco') {
                    colorResult = StrategyColors.White;
                  } else {
                    colorResult = null;
                  }
                  if (colorResult != null && colorTarget != null) {
                    if (widget.entrys.length > widget.index) {
                      widget.entrys.removeAt(widget.index);
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategy(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    } else {
                      widget.entrys.insert(
                          widget.index,
                          EntryStrategy(
                              colorResult: colorResult!,
                              colorTarget: colorTarget!));
                    }
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
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
                style: TextStyle(color: Colors.white),
                value: colorTargetText.value,
                items: <String>[
                  '',
                  'Vermelho',
                  'Preto',
                  'Branco',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (value) {
                  colorTargetText.value = value!;
                  if (colorTargetText.value == 'Vermelho') {
                    colorTarget = StrategyColors.Red;
                  } else if (colorTargetText.value == 'Preto') {
                    colorTarget = StrategyColors.Black;
                  } else if (colorTargetText.value == 'Branco') {
                    colorTarget = StrategyColors.White;
                  } else {
                    colorTarget = null;
                  }
                  if (colorResult != null && colorTarget != null) {
                    if (widget.entrys.length > widget.index) {
                      widget.entrys.removeAt(widget.index);
                      widget.entrys.insert(
                        widget.index,
                        EntryStrategy(
                            colorResult: colorResult!,
                            colorTarget: colorTarget!),
                      );
                    } else {
                      widget.entrys.insert(
                          widget.index,
                          EntryStrategy(
                              colorResult: colorResult!,
                              colorTarget: colorTarget!));
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
