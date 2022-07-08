import 'package:flutter/material.dart';

import '../../../../domain/entities/custom_strategy_entity.dart';

class StrategyCreationitemWidget extends StatefulWidget {
  final ResultStrategyEntity strategy;
  final int index;
  const StrategyCreationitemWidget(
      {Key? key, required this.strategy, required this.index})
      : super(key: key);

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
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 5),
                child: Text(
                  'Cores:',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
              widget.strategy.colors.contains(StrategyColors.Red)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              widget.strategy.colors.contains(StrategyColors.Black)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    )
                  : Container(),
              widget.strategy.colors.contains(StrategyColors.White)
                  ? Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
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
                        style: TextStyle(color: Colors.white, fontSize: 16),
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
