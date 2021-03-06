import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/firebase_options.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/blaze/double_config_cubit.dart';
import 'package:ia_bet/presentation/bloc/communication/communication_cubit.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';

import 'injection_container.dart' as di;
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: kPrimaryColor,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (_) => di.sl<UserCubit>()..getCurrentUser(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => di.sl<CommunicationCubit>(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => di.sl<MyChatCubit>(),
        ),
        BlocProvider<DoubleConfigCubit>(
          create: (_) => di.sl<DoubleConfigCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'IA BET',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF263C43, {
            50: kPrimaryColor,
            100: kPrimaryColor,
            200: kPrimaryColor,
            300: kPrimaryColor,
            400: kPrimaryColor,
            500: kPrimaryColor,
            600: kPrimaryColor,
            700: kPrimaryColor,
            800: kPrimaryColor,
            900: kPrimaryColor,
          }),
          fontFamily: 'Roboto',
        ),
        home: BlocListener<AuthCubit, AuthState>(
          child: Container(),
          listener: (context, authState) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                FlutterNativeSplash.remove();
                return (authState is Authenticated) ? HomePage() : LoginPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Notifica????o recebida: $message");
}
