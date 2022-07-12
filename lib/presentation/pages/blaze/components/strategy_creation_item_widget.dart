import 'package:flutter/material.dart';

import '../../../../data/model/result_strategy_model.dart';
import '../../../../domain/entities/custom_strategy_entity.dart';

class StrategyCreationitemWidget extends StatefulWidget {
  final ResultStrategyModel strategy;
  final int index;
  const StrategyCreationitemWidget(
      {super.key, required this.strategy, required this.index});

  @override
  State<StrategyCreationitemWidget> createState() =>
      _StrategyCreationitemWidgetState();
}

class _StrategyCreationitemWidgetState
    extends State<StrategyCreationitemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 75,
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Resultado ${widget.index + 1}',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 20, right: 5),
                child: Text(
                  'Cores:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              widget.strategy.colors.contains(StrategyColors.red)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              widget.strategy.colors.contains(StrategyColors.black)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              widget.strategy.colors.contains(StrategyColors.white)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: widget.strategy.rules != null
                    ? Text(
                        'Regra: ${widget.strategy.rules!.first.operator.value} a posição ${widget.strategy.rules!.first.position + 1}',
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
                      )
                    : Container(),
              ),
            ],
          ),
        ),
        Container(height: 1, color: Colors.white)
      ],
    );
  }
}
