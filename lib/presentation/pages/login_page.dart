import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/constants/text_input_decoration.dart';
import 'package:ia_bet/injection_container.dart' as di;
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/auth_email/auth_email_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController _emailController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        key: _scaffoldKey,
        body: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => di.sl<AuthCubit>()..appStarted(),
            ),
            BlocProvider<UserCubit>(
              create: (_) => di.sl<UserCubit>()..getCurrentUser(),
            ),
            BlocProvider<EmailAuthCubit>(
              create: (_) => di.sl<EmailAuthCubit>(),
            ),
          ],
          child: BlocConsumer<EmailAuthCubit, EmailAuthState>(
              listener: (context, emailAuthState) {
            if (emailAuthState is PhoneAuthSmsCodeReceived) {
              BlocProvider.of<AuthCubit>(context).loggedIn().whenComplete(() {
                debugPrint('Login page: depois do getCurrentUserWithReturn..');

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomePage(),
                  ),
                );
              });
              //545590pqjlrd
            }
            if (emailAuthState is PhoneAuthFailure) {
              BlocProvider.of<EmailAuthCubit>(context).authFailure();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: Colors.red,
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("Verifique seu usuário ou senha."),
                        Icon(Icons.error_outline)
                      ],
                    ),
                  ),
                ),
              );
            }
          }, builder: (context, emailAuthState) {
            if (emailAuthState is PhoneAuthLoading) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            if (emailAuthState is PhoneAuthInitial) {
              return Stack(children: [
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.75,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.contain,
                        image: AssetImage(
                          "assets/images/marcadagua-full.png",
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: SingleChildScrollView(
                    child: Form(
                      key: formKey,
                      child: Padding(
                        padding: const EdgeInsets.all(30),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 50),
                            SvgPicture.asset(
                              "assets/images/logo.svg",
                              fit: BoxFit.cover,
                              alignment: Alignment.center,
                            ),
                            const SizedBox(height: 35),
                            RichText(
                              textAlign: TextAlign.center,
                              text: const TextSpan(
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w300,
                                      fontSize: 18.0),
                                  children: <TextSpan>[
                                    TextSpan(text: 'A '),
                                    TextSpan(
                                        text: ' melhor plataforma ',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700)),
                                    TextSpan(
                                        text:
                                            ' para gerir suas apostas esportivas',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w300)),
                                  ]),
                            ),
                            const SizedBox(height: 50),
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.text,
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Email',
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: _passwordController,
                              keyboardType: TextInputType.text,
                              obscureText: true,
                              decoration: textInputDecoration.copyWith(
                                hintText: 'Senha',
                              ),
                            ),
                            const SizedBox(height: 12),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                      padding:
                                          MaterialStateProperty.all<EdgeInsets>(
                                              const EdgeInsets.all(15)),
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                              kSecondColor)),
                                  child: const Text('Efetuar login',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w700)),
                                  onPressed: () async {
                                    debugPrint(_emailController.text);
                                    if (_emailController.text.isNotEmpty &&
                                        _passwordController.text.isNotEmpty) {
                                      await BlocProvider.of<EmailAuthCubit>(
                                              context)
                                          .submitVerifyPhoneNumber(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text);
                                    }
                                  }),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]);
            }
            return Container();
          }),
        ),
      ),
    );
  }
}
