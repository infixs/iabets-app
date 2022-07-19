import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ia_bet/data/datasource/api.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/user/user_cubit.dart';

import 'blaze_crash/blaze_crash_page.dart';
import 'blaze_double/blaze_page.dart';
import 'canais_page.dart';
import 'canal_page.dart';
import 'login_page.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      if (message.data.containsKey('crash')) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const BlazeCrashPage(),
          ),
        );
      }
    });
  }

  Future<List<Map<String, dynamic>>> makeButtons() async {
    var products = [];
    try {
      products = (await getProducts(
        (await getUser() as UserEntity),
      ));
    } catch (e) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage(),
        ),
      );
    }

    final bool crashItem = products.contains('Crash');
    final bool doubleItem = products.contains('Automatic');

    if (mounted) {
      requestNotificationPermission(context, [
        'chat',
        ...(crashItem ? ['crash'] : []),
        ...(doubleItem ? ['automatic'] : [])
      ]);
    }

    final List<Map<String, dynamic>> buttons = [
      {
        'title': 'Canais',
        'icon': SvgPicture.asset(
          'assets/images/chat.svg',
          width: 30,
        ),
        'route': await getUser() != null
            ? CanaisPage(userInfo: (await getUser() as UserEntity))
            : null,
      },
    ];

    if (doubleItem) {
      buttons.add(
        {
          'title': 'Blaze double',
          'icon': SvgPicture.asset(
            'assets/images/blaze.svg',
            width: 30,
          ),
          'route': const BlazeDoublePage(),
        },
      );
    }
    if (crashItem) {
      buttons.add(
        {
          'title': 'Blaze crash',
          'icon': SvgPicture.asset(
            'assets/images/blaze.svg',
            width: 30,
          ),
          'route': const BlazeCrashPage(),
        },
      );
    }

    return buttons;
  }

  Future<UserEntity?> getUser() async {
    if (await BlocProvider.of<UserCubit>(context).isSignInUseCase.call()) {
      return await BlocProvider.of<UserCubit>(context)
          .getCurrentUserWithReturn();
    } else {
      return null;
    }
  }

  void handleMenuClick(String value) {
    switch (value) {
      case 'config':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const PerfilPage(),
          ),
        );
        break;
      case 'logout':
        BlocProvider.of<UserCubit>(context).logout();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocListener<UserCubit, UserState>(
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                SvgPicture.asset(
                  'assets/images/logo.svg',
                  width: 100,
                  color: Colors.white,
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                onSelected: handleMenuClick,
                itemBuilder: (BuildContext bcontext) => [
                  const PopupMenuItem<String>(
                    value: 'config',
                    child: Text('Configurações'),
                  ),
                  const PopupMenuItem<String>(
                    value: 'logout',
                    child: Text('Sair'),
                  )
                ],
              ),
            ],
          ),
          body: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/background_home_page.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              FutureBuilder(
                future: makeButtons(),
                builder: (BuildContext context,
                    AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (BuildContext context, int index) =>
                          SizedBox(
                        height: size.height * 0.09,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            primary: Colors.grey.shade300.withAlpha(120),
                          ),
                          onPressed: () =>
                              snapshot.data![index]['route'] != null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              snapshot.data![index]['route']),
                                    )
                                  : null,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.07),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: snapshot.data![index]['icon'],
                                ),
                                Expanded(
                                  child: Text(
                                    snapshot.data![index]['title'],
                                    style: const TextStyle(
                                        color: Colors.black, fontSize: 18),
                                  ),
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
      listener: (context, authState) {
        if (authState is UserLogout) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (BuildContext context) => const LoginPage(),
            ),
          );
        }
      },
    );
  }
}

void requestNotificationPermission(context, List<String> products) async {
  String token = await FirebaseMessaging.instance.getToken() as String;

  BlocProvider.of<UserCubit>(context).setUserToken(token);

  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    for (var product in products) {
      {
        FirebaseMessaging.instance.subscribeToTopic(product);
      }
    }
  } else {
    debugPrint('User declined or has not accepted permission');
  }
}
