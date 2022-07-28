import 'package:flutter/material.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ia_bet/data/datasource/api.dart';

import '../../constants/products_app.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/user/user_cubit.dart';

import 'blaze_crash/blaze_crash_page.dart';
import 'blaze_double/blaze_page.dart';
import 'canais_page.dart';
import 'login_page.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with ProductsApp, ConnectionWithApi {
  final List<String> myProducts = [];

  @override
  void initState() {
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
    super.initState();
  }

  void requestNotificationPermission(context, List<String> products) async {
    final String? token = await FirebaseMessaging.instance.getToken();

    if (token == null) {
      return;
    } else {
      BlocProvider.of<UserCubit>(context).setUserToken(token);

      final NotificationSettings settings =
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
        for (String product in products) {
          if (!ProductsApp.existingProducts.contains(product)) {
            FirebaseMessaging.instance.unsubscribeFromTopic(product);
          }
        }

        for (var product in products) {
          FirebaseMessaging.instance.subscribeToTopic(product);
        }
      } else {
        debugPrint('User declined or has not accepted permission');
      }
    }
  }

  Future<List<Map<String, dynamic>>> makeButtons() async {
    late final List<Map<String, dynamic>> products;
    bool crashItemHasBeenPurchased = false;
    bool doubleItemHasBeenPurchased = false;
    bool crashItemWaitingTimeHasPassed = false;
    int crashItemDaysToRelease = 1;

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

    for (var element in products) {
      if (element['product'] == 'Crash') {
        crashItemHasBeenPurchased = true;

        final List<String> createdAtRaw =
            (element['created_at'] as String).split('-');
        final DateTime createdAt = (DateTime(int.parse(createdAtRaw[0]),
            int.parse(createdAtRaw[1]), int.parse(createdAtRaw[2])));

        final int pastDays = (DateTime.now().difference(createdAt).inDays);
        crashItemDaysToRelease = 7 - pastDays;

        if (crashItemDaysToRelease <= 0) {
          crashItemWaitingTimeHasPassed = true;
        }
      }
      if (element['product'] == 'Automatic') {
        doubleItemHasBeenPurchased = true;
      }
    }

    if (mounted) {
      myProducts.add('chat');

      if (crashItemHasBeenPurchased && crashItemWaitingTimeHasPassed) {
        myProducts.add('crash');
      }
      if (doubleItemHasBeenPurchased) {
        myProducts.add('automatic');
      }

      requestNotificationPermission(context, myProducts);
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
        'WaitingTimeHasPassed': true,
      },
    ];

    if (doubleItemHasBeenPurchased) {
      buttons.add(
        {
          'title': 'Blaze double',
          'icon': SvgPicture.asset(
            'assets/images/blaze.svg',
            width: 30,
          ),
          'route': const BlazeDoublePage(),
          'WaitingTimeHasPassed': true
        },
      );
    }
    if (crashItemHasBeenPurchased) {
      buttons.add(
        {
          'title': 'Blaze crash',
          'icon': SvgPicture.asset(
            'assets/images/blaze.svg',
            width: 30,
            color: !crashItemWaitingTimeHasPassed ? Colors.grey.shade800 : null,
          ),
          'route': const BlazeCrashPage(),
          'WaitingTimeHasPassed': crashItemWaitingTimeHasPassed,
          'daysToWait': crashItemDaysToRelease
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

  void unsubscribeOnLogout() {
    for (String product in myProducts) {
      if (!ProductsApp.existingProducts.contains(product)) {
        FirebaseMessaging.instance.unsubscribeFromTopic(product);
      }
    }
  }

  void handleMenuClick(String value) async {
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
        try {
          unsubscribeOnLogout();
          await BlocProvider.of<UserCubit>(context)
              .logout(await getUser() as UserEntity);
        } catch (error, stackTrace) {
          debugPrint(error.toString());
          debugPrint(stackTrace.toString());
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const LoginPage(),
            ),
          );
        }
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
              IconButton(
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'Atualizar Produtos',
                onPressed: () {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('Seus produtos foram atualizados')));
                },
              ),
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
                          onPressed: snapshot.data![index]
                                  ['WaitingTimeHasPassed']
                              ? () => snapshot.data![index]['route'] != null
                                  ? Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              snapshot.data![index]['route']),
                                    )
                                  : null
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
                                  flex: 2,
                                  child: Text(
                                    snapshot.data![index]['title'],
                                    style: snapshot.data![index]
                                            ['WaitingTimeHasPassed']
                                        ? const TextStyle(
                                            color: Colors.black, fontSize: 18)
                                        : TextStyle(
                                            color: Colors.grey.shade800,
                                            fontSize: 18),
                                  ),
                                ),
                                !snapshot.data![index]['WaitingTimeHasPassed']
                                    ? Expanded(
                                        flex: 3,
                                        child: Text(
                                          '(Libera em ${snapshot.data![index]['daysToWait']} ${snapshot.data![index]['daysToWait'] > 1 ? 'dias' : 'dia'})',
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 18),
                                        ),
                                      )
                                    : Container(),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: snapshot.data![index]
                                          ['WaitingTimeHasPassed']
                                      ? Colors.black
                                      : Colors.grey.shade800,
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
