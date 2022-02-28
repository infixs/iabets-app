
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/constants/text_input_decoration.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/presentation/pages/canal_page.dart';
import 'package:ia_bet/presentation/pages/perfil_page.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'dart:async' show Timer;

class HomePage extends StatefulWidget {
  final UserEntity userInfo;

  HomePage({Key? key, required this.userInfo}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

TextEditingController _canalController = TextEditingController();

class _HomePageState extends State<HomePage> {
  Future<void> setupInteractedMessage() async {
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    FirebaseMessaging.onMessageOpenedApp.listen(_handleMessage);
  }

  void _handleMessage(RemoteMessage message) {
    if (message.data['type'] == 'chat') {
/*       Navigator.pushNamed(context, '/chat', 
        arguments: ChatArguments(message),
      ); */
    }
  }

  @override
  void initState() {
    BlocProvider.of<MyChatCubit>(context).getMyChat(uid: '111');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    requestNotificationPermission(context);
    print('Home Page: Estou no build...');
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<MyChatCubit, MyChatState>(
          builder: (context, myChatState) {
        print('Home Page: Bloc MyChatCubit...');
        return Scaffold(
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Colors.transparent,
              statusBarIconBrightness:
                  Brightness.light, // For Android (dark icons)
              statusBarBrightness: Brightness.light, // For iOS (dark icons)
            ),
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            automaticallyImplyLeading: false,
            elevation: 0,
            centerTitle: false,
            title: Text("IABets",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                )),
            actions: [
              PopupMenuButton<String>(
                onSelected: handleMenuClick,
                itemBuilder: (BuildContext bcontext) {
                  return [
                    PopupMenuItem<String>(
                      value: 'config',
                      child: Text('Configurações'),
                    ),
                    PopupMenuItem<String>(value: 'logout', child: Text('Sair'))
                  ];
                },
              ),
              /*IconButton(
                    icon: Icon(Icons.logout, color: Colors.red),
                    onPressed: () => Navigator.of(context).pop())*/
            ],
          ),
          body: Stack(children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 0,
              right: 0,
              bottom: 0,
              child: ShaderMask(
                shaderCallback: (rect) {
                  return LinearGradient(
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
                              print('1');
                              launchURL('https://placar.iabetsoficial.com.br/');
                            },
                            child: Container(
                              padding: EdgeInsets.all(15),
                              decoration: BoxDecoration(
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
                          SizedBox(height: 5),
                          Text("Placar",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w400,
                              )),
                        ],
                      ),
                      SizedBox(width: 15.0),
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
                              print(2);
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
                      ),
                    ],
                  ),
                  BlocBuilder<UserCubit, UserState>(
                      builder: (context, userState) {
                    print('Home Page: Estou no bloc builder do UserState');
                    if (userState is CurrentUserChanged &&
                        userState.user.isAdmin) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              behavior: HitTestBehavior.translucent,
                              child: Container(
                                padding: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Icon(Icons.add, color: kSecondColor),
                                ),
                              ),
                              onTap: () {
                                _showDialog();
                              }),
                          SizedBox(height: 5),
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
        hintStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey),
        labelStyle: TextStyle(
            fontSize: 16, fontWeight: FontWeight.w300, color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.grey.shade300),
          borderRadius: new BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: new BorderSide(color: Colors.grey.shade300),
          borderRadius: new BorderRadius.circular(8),
        ),
        suffixIcon: Material(
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
    final nowTime = new DateTime.now();

    return myChatData.myChat.isEmpty
        ? Container()
        : ListView.builder(
            itemCount: myChatData.myChat.length,
            itemBuilder: (BuildContext context, int index) {
              final DateTime chatTime =
                  DateTime.parse(myChatData.myChat[0].time.toDate().toString());
              final difference = nowTime.difference(chatTime);
              return Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 10),
                    leading: Container(
                      height: 48,
                      width: 48,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(48)),
                          image: new DecorationImage(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              image:
                                  AssetImage("assets/images/canal-image.png"))),
                    ),
                    title: Text(myChatData.myChat[index].channelId,
                        style: TextStyle(
                            color: kSecondColor,
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(myChatData.myChat[index].recentTextMessage,
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                    trailing: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                              padding: EdgeInsets.only(top: 6),
                              child: Text(
                                  chatTime.day != nowTime.day
                                      ? timeago.format(
                                          nowTime.subtract(difference),
                                          locale: 'pt_BR')
                                      : "${chatTime.hour.toString().padLeft(2, '0')}:${chatTime.minute.toString().padLeft(2, '0')}",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 14.0,
                                      fontWeight: FontWeight.w400))),
                          Padding(
                              padding: EdgeInsets.only(top: 5, right: 2),
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

  void handleMenuClick(String value) async {
    switch (value) {
      case 'config':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PerfilPage()));
        break;
      case 'logout':
        await BlocProvider.of<AuthCubit>(context).loggedOut();
        //Navigator.of(context).pop();
        break;
    }
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Novo Canal:"),
          content: TextFormField(
            controller: _canalController,
            keyboardType: TextInputType.text,
            decoration: textInputDecoration.copyWith(
              hintText: 'Digite o nome do novo canal',
            ),
          ),
          actions: <Widget>[
            // define os botões na base do dialogo
            new FlatButton(
              child: new Text("Salvar"),
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
                            )));
              },
            ),
          ],
        );
      },
    );
  }
}

void launchURL(url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}

void requestNotificationPermission(context) async {
  String token = await FirebaseMessaging.instance.getToken() as String;

  BlocProvider.of<UserCubit>(context).setUserToken(token);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('User granted provisional permission');
  } else {
    print('User declined or has not accepted permission');
  }
}
