import 'package:flutter/material.dart';

import '../controller_settings.dart';

class GaleWidget extends StatelessWidget {
  final int index;
  final SettingsController settingsController;

  const GaleWidget(
      {Key? key, required this.settingsController, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xff0a1117),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Vermelho/Preto',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '${settingsController.gales[index]['price']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Branco',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '${settingsController.gales[index]['white']}',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          CircleAvatar(
            backgroundColor: const Color(0xfff12c4d),
            child: IconButton(
              splashRadius: 25,
              onPressed: () {},
              icon: Icon(
                Icons.close,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
