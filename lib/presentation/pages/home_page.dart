import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/auth/auth_cubit.dart';
import '../bloc/user/user_cubit.dart';

import 'blaze/blaze_page.dart';
import 'canais_page.dart';
import 'login_page.dart';
import 'perfil_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, dynamic>>> makeButtons() async => [
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
        {
          'title': 'Blaze',
          'icon': SvgPicture.asset(
            'assets/images/blaze.svg',
            width: 30,
          ),
          'route': BlazePage(),
        },
      ];

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
            builder: (context) => PerfilPage(),
          ),
        );
        break;
      case 'logout':
        BlocProvider.of<AuthCubit>(context).loggedOut().then(
              (_) => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LoginPage(),
                ),
              ),
            );
        break;
    }
  }

  @override
  void dispose() {
    BlocProvider.of<UserCubit>(context).close();
    BlocProvider.of<AuthCubit>(context).close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return WillPopScope(
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
                PopupMenuItem<String>(
                  value: 'config',
                  child: Text('Configurações'),
                ),
                PopupMenuItem<String>(
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
              decoration: BoxDecoration(
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
                    itemBuilder: (BuildContext context, int index) => SizedBox(
                      height: size.height * 0.09,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          padding: EdgeInsets.zero,
                          primary: Colors.grey.shade300.withAlpha(120),
                        ),
                        onPressed: () => snapshot.data![index]['route'] != null
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(child: snapshot.data![index]['icon']),
                              Flexible(
                                child: Text(
                                  snapshot.data![index]['title'],
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                              ),
                              const Spacer(
                                flex: 1,
                              ),
                              Flexible(
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.black,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
