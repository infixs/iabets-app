import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/firebase_options.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/blaze/crash/crash_cubit.dart';
import 'package:ia_bet/presentation/bloc/blaze/double/double_config_cubit.dart';
import 'package:ia_bet/presentation/bloc/communication/communication_cubit.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';

import 'constants/device_id.dart';
import 'injection_container.dart' as di;
import 'presentation/pages/home_page.dart';
import 'presentation/pages/login_page.dart';

void main() async {
  FlutterNativeSplash.preserve(
    widgetsBinding: WidgetsFlutterBinding.ensureInitialized(),
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  try {
    Deviceid.deviceId = await getDeviceInfo();
  } catch (error, stackTrace) {
    debugPrint(error.toString());
    debugPrint(stackTrace.toString());
  }
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: CustomColors.kPrimaryColor,
      statusBarBrightness: Brightness.light,
      statusBarIconBrightness: Brightness.light,
    ),
  );
  runApp(const MyApp());
}

Future<String> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

  if (Platform.isIOS) {
    final IosDeviceInfo iosDeviceInfo = await deviceInfo.iosInfo;
    return iosDeviceInfo.identifierForVendor ??
        (await deviceInfo.deviceInfo).toMap()['id'] ??
        'none|isIOS'; // unique ID on iOS
  } else if (Platform.isAndroid) {
    final AndroidDeviceInfo androidDeviceInfo = await deviceInfo.androidInfo;
    return androidDeviceInfo.androidId ??
        (await deviceInfo.deviceInfo).toMap()['id'] ??
        'none|isAndroid'; // unique ID on Android
  } else {
    return (await deviceInfo.deviceInfo).toMap()['id'];
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => di.sl<AuthCubit>()..appStarted(),
        ),
        BlocProvider<UserCubit>(
          create: (context) => di.sl<UserCubit>()..getCurrentUser(),
        ),
        BlocProvider<CommunicationCubit>(
          create: (_) => di.sl<CommunicationCubit>(),
        ),
        BlocProvider<MyChatCubit>(
          create: (_) => di.sl<MyChatCubit>(),
        ),
        BlocProvider<DoubleConfigCubit>(
          create: (_) => di.sl<DoubleConfigCubit>(),
        ),
        BlocProvider<CrashCubit>(
          create: (_) => di.sl<CrashCubit>(),
        )
      ],
      child: MaterialApp(
        title: 'IA BET',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: const MaterialColor(0xFF263C43, {
            50: CustomColors.kPrimaryColor,
            100: CustomColors.kPrimaryColor,
            200: CustomColors.kPrimaryColor,
            300: CustomColors.kPrimaryColor,
            400: CustomColors.kPrimaryColor,
            500: CustomColors.kPrimaryColor,
            600: CustomColors.kPrimaryColor,
            700: CustomColors.kPrimaryColor,
            800: CustomColors.kPrimaryColor,
            900: CustomColors.kPrimaryColor,
          }),
          fontFamily: 'Roboto',
        ),
        home: BlocListener<AuthCubit, AuthState>(
          child: const Center(
            child: CircularProgressIndicator(),
          ),
          listener: (context, authState) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                FlutterNativeSplash.remove();
                return (authState is Authenticated)
                    ? const HomePage()
                    : const LoginPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Notificação recebida: $message");
}
