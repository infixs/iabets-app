import 'package:flutter/material.dart';

import 'package:ia_bet/presentation/pages/blaze/controller_settings.dart';

import 'components/custom_app_bar_blaze_page/custom_app_bar_gales_page.dart';
import 'components/gale_widget.dart';

class GalesSettingsPage extends StatefulWidget {
  const GalesSettingsPage({Key? key}) : super(key: key);

  @override
  State<GalesSettingsPage> createState() => _GalesSettingsPageState();
}

class _GalesSettingsPageState extends State<GalesSettingsPage> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final SettingsController settingsController = SettingsController();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xff0f1923),
      drawer: Drawer(
        child: Container(
          color: const Color(0xff0f1923),
        ),
      ),
      appBar: CustomAppBarGalesPage(
        height: 130,
        child: Padding(
          padding: const EdgeInsets.only(top: 0, left: 20, right: 20),
          child: SizedBox(
            height: 70,
            child: Card(
              margin: EdgeInsets.all(8),
              color: const Color(0xfff12c4d),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'GALES',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600),
                    ),
                    IconButton(
                      onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      icon: Icon(
                        Icons.menu,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: size.height * 0.7,
              child: ReorderableListView.builder(
                padding: const EdgeInsets.only(left: 20, right: 20),
                itemCount: settingsController.gales.length,
                onReorder: (oldPosition, newPosition) => setState(() {
                  if (oldPosition < newPosition) {
                    newPosition -= 1;
                  }
                  final Map<String, dynamic> item =
                      settingsController.gales.removeAt(oldPosition);
                  settingsController.gales.insert(newPosition, item);
                }),
                itemBuilder: (BuildContext context, int index) => SizedBox(
                  height: 70,
                  key: Key('$index'),
                  child: GaleWidget(
                    settingsController: settingsController,
                    index: index,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: size.height * 0.01,
                left: 20,
                right: 20,
              ),
              child: Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 70,
                      width: size.width * 0.38,
                      child: TextFormField(
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
                    SizedBox(
                      height: 70,
                      width: size.width * 0.38,
                      child: TextFormField(
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
                    SizedBox(
                      height: 70,
                      width: size.width * 0.1,
                      child: CircleAvatar(
                        backgroundColor: const Color(0xff1bb57f),
                        child: IconButton(
                          splashRadius: 25,
                          color: Colors.white,
                          onPressed: () {},
                          icon: Icon(Icons.add),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
