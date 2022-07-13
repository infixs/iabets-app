import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/constants/text_input_decoration.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/presentation/pages/canal_page.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class CanaisPage extends StatefulWidget {
  final UserEntity userInfo;
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  CanaisPage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<CanaisPage> createState() => _CanaisPageState();
}

TextEditingController _canalController = TextEditingController();

class _CanaisPageState extends State<CanaisPage> {
/*   Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }
  
    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {

    }
  } */

  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: '111');
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.containsKey('channelId')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CanalPage(
              canalName: message.data['channelId'],
              senderName: widget.userInfo.name,
              senderUID: widget.userInfo.uid,
              userInfo: widget.userInfo,
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission(context);
    debugPrint('Home Page: Estou no build...');
    return WillPopScope(
      onWillPop: () async => true,
      child: BlocBuilder<MyChatCubit, MyChatState>(
          builder: (context, myChatState) {
        debugPrint('Home Page: Bloc MyChatCubit...');
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            iconTheme: const IconThemeData(
              color: Colors.white,
            ),
            elevation: 0,
            backgroundColor: kPrimaryColor,
            title: const Text(
              "IABets",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: Stack(children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 0,
              right: 0,
              bottom: 0,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black, Colors.transparent],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                blendMode: BlendMode.dstIn,
                child: Image.asset(
                  'assets/images/background.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              bottom: 0,
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  color: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (myChatState is MyChatLoaded)
                        Expanded(child: listaCanaisWidget(myChatState)),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              bottom: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              launchURL('https://placar.iabetsoficial.com.br/');
                            },
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: kPrimaryColor,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/placar.svg",
                                height: 25,
                                width: 55,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text("Placar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                      /*SizedBox(width: 15.0),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                                color: kPrimaryColor,
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/calculadora.svg",
                                height: 25,
                                width: 55,
                                fit: BoxFit.contain,
                                alignment: Alignment.center,
                              ),
                            ),
                            onTap: () {
                              debugPrint(2);
                              launchURL(
                                  'https://iabetsoficial.com.br/calculadora');
                            },
                          ),
                          SizedBox(height: 5),
                          Text("Calculadora",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),*/
                    ],
                  ),
                  BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                    debugPrint('Home Page: Estou no bloc builder do UserState');
                    if (userState is CurrentUserChanged &&
                        userState.user.isAdmin) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: _showDialog,
                            child: Container(
                              padding: const EdgeInsets.all(15),
                              decoration: const BoxDecoration(
                                color: kPrimaryColor,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(Icons.add, color: kSecondColor),
                              ),
                            ),
                          ),
                          const SizedBox(height: 5),
                        ],
                      );
                    } else {
                      return Column();
                    }
                  }),
                ],
              ),
            ),
          ]),
        );
      }),
    );
  }

  Widget searchWidget() {
    return TextField(
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: 'Procure por mensagens e usuários',
        filled: true,
        fillColor: Colors.grey[300],
        contentPadding:
            const EdgeInsets.only(left: 15.0, bottom: 8.0, top: 8.0),
        hintStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey),
        labelStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: const Material(
          color: kPrimaryColor,
          shadowColor: kPrimaryColor,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8.0),
            bottomRight: Radius.circular(8.0),
          ),
          child: Icon(
            Icons.search_rounded,
            color: kSecondColor,
          ),
        ),
      ),
    );
  }

  //Listar Canais

  Widget listaCanaisWidget(MyChatLoaded myChatData) {
    final nowTime = DateTime.now();
    return myChatData.myChat.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: myChatData.myChat.length,
            itemBuilder: (BuildContext context, int index) {
              final DateTime chatTime = DateTime.parse(
                  myChatData.myChat[index].time.toDate().toString());
              final difference = nowTime.difference(chatTime);
              return Column(
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(48)),
                          image: DecorationImage(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              image:
                                  AssetImage("assets/images/canal-image.png"))),
                    ),
                    title: Text(myChatData.myChat[index].channelId,
                        style: const TextStyle(
                            color: kSecondColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(
                        myChatData.myChat[index].recentTextMessage
                                    .indexOf('\n') >
                                0
                            ? myChatData.myChat[index].recentTextMessage
                                .substring(
                                    0,
                                    myChatData.myChat[index].recentTextMessage
                                        .indexOf('\n'))
                            : myChatData.myChat[index].recentTextMessage,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                    trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                  chatTime.day != nowTime.day
                                      ? timeago.format(
                                          nowTime.subtract(difference),
                                          locale: 'pt_BR')
                                      : "${chatTime.hour.toString().padLeft(2, '0')}:${chatTime.minute.toString().padLeft(2, '0')}",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400))),
                          Padding(
                              padding: const EdgeInsets.only(top: 5, right: 2),
                              child: SvgPicture.asset(
                                "assets/icons/pin.svg",
                                height: 15,
                                width: 15,
                                fit: BoxFit.contain,
                              )),
                        ]),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CanalPage(
                                    canalName:
                                        myChatData.myChat[index].channelId,
                                    senderName: widget.userInfo.name,
                                    senderUID: widget.userInfo.uid,
                                    userInfo: widget.userInfo,
                                  )));
                    },
                  ),
                ],
              );
            });
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: const Text("Novo Canal:"),
          content: TextFormField(
            controller: _canalController,
            keyboardType: TextInputType.text,
            decoration: textInputDecoration.copyWith(
              hintText: 'Digite o nome do novo canal',
            ),
          ),
          actions: <Widget>[
            // define os botões na base do dialogo
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () async {
                BlocProvider.of<UserCubit>(context).createChatChannel(
                    uid: widget.userInfo.uid, name: _canalController.text);

                // Navigator.of(context).pop();
                //Abrir ChatScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CanalPage(
                      canalName: _canalController.text,
                      senderName: widget.userInfo.name,
                      senderUID: widget.userInfo.uid,
                      userInfo: widget.userInfo,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  void requestNotificationPermission(context) async {
    String token = await FirebaseMessaging.instance.getToken() as String;

    BlocProvider.of<UserCubit>(context).setUserToken(token);

    NotificationSettings settings = await widget._messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('User granted permission');
      FirebaseMessaging.instance.subscribeToTopic('chat');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('User granted provisional permission');
      FirebaseMessaging.instance.subscribeToTopic('chat');
    } else {
      debugPrint('User declined or has not accepted permission');
    }
  }
}

void launchURL(url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}
