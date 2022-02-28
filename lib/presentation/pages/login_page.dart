import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ia_bet/constants/text_input_decoration.dart';
import 'package:ia_bet/data/model/user_model.dart';
import 'package:ia_bet/presentation/bloc/auth/auth_cubit.dart';
import 'package:ia_bet/presentation/bloc/auth_email/auth_email_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/presentation/pages/home_page.dart';
import 'package:ia_bet/injection_container.dart' as di;

class LoginPage extends StatefulWidget {
  LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

TextEditingController _emailController = TextEditingController();
TextEditingController _passwordController = TextEditingController();
late final users;

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  final _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  @override
  Widget build(BuildContext context) {
    final userAuth = context.watch<AuthCubit>().state;
    final isAuth = userAuth is Authenticated ? userAuth.uid : false;
    print("Login: Usuario está autenticado?" + isAuth.toString());
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
                listener: (context, emailAuthState) async {
              if (emailAuthState is PhoneAuthSmsCodeReceived) {
                await BlocProvider.of<AuthCubit>(context).loggedIn();
                //545590pqjlrd
                var user = await BlocProvider.of<UserCubit>(context)
                    .getCurrentUserWithReturn();

                print('Login page: depois do getCurrentUserWithReturn..');

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => HomePage(
                              userInfo: user,
                            )));
              }

              if (emailAuthState is PhoneAuthFailure) {
                BlocProvider.of<EmailAuthCubit>(context)
                    .emit(PhoneAuthInitial());
                Scaffold.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.red,
                  content: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Verifique seu usuário ou senha."),
                        Icon(Icons.error_outline)
                      ],
                    ),
                  ),
                ));
              }
            }, builder: (context, emailAuthState) {
              if (emailAuthState is PhoneAuthLoading) {
                return Scaffold(
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
                      decoration: BoxDecoration(
                        image: new DecorationImage(
                          fit: BoxFit.contain,
                          image: AssetImage(
                            "assets/images/marcadagua.png",
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
                          padding: EdgeInsets.all(30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(height: 50),
                              SvgPicture.asset(
                                "assets/images/logo.svg",
                                fit: BoxFit.cover,
                                alignment: Alignment.center,
                              ),
                              SizedBox(height: 35),
                              RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w300,
                                        fontSize: 18.0),
                                    children: const <TextSpan>[
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
                              SizedBox(height: 50),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.text,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Email',
                                ),
                              ),
                              SizedBox(height: 10),
                              TextFormField(
                                controller: _passwordController,
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                decoration: textInputDecoration.copyWith(
                                  hintText: 'Senha',
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  child: Text(
                                    'Esqueci minha senha',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.white,
                                        decoration: TextDecoration.underline),
                                  ),
                                  onPressed: () {},
                                ),
                              ),
                              SizedBox(height: 0),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        padding: MaterialStateProperty.all<
                                            EdgeInsets>(EdgeInsets.all(15)),
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                kSecondColor)),
                                    child: Text('Efetuar login',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w700)),
                                    onPressed: () async {
                                      print(_emailController.text);
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
                              SizedBox(height: 30),
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
        ));
  }
}
