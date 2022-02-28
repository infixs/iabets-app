import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/presentation/pages/home_page.dart';
import 'package:ia_bet/presentation/pages/login_page.dart';

class SplashPage extends StatefulWidget {
  SplashPage({Key? key}) : super(key: key);

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //_authVerify(context);

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: <Widget>[
            Image.asset(
              "assets/images/splash_01.png",
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
              alignment: Alignment.center,
            ),
            Positioned(
              left: 30.0,
              right: 30.0,
              bottom: 40.0,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Comunidade com expertise tecnológica',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                    Text('e educacional no futebol virtual.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color(0xFFFFFFFF),
                            fontSize: 15.0,
                            fontWeight: FontWeight.w400)),
                  ]),
            ),
            BlocListener<AuthCubit, AuthState>(
              child: Container(),
              listener: (context, authState) async {
                print('loading....');
                await Future.delayed(Duration(seconds: 1));

                if (authState is Authenticated) {
                  UserEntity user = await BlocProvider.of<UserCubit>(context)
                      .getCurrentUserWithReturn();
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(userInfo: user)));
                }
                if (authState is UnAuthenticated) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
