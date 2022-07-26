import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/user/user_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final GlobalKey<FormState> formkey = GlobalKey<FormState>();
  final TextEditingController textEditingController = TextEditingController();

  @override
  void dispose() {
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Redefinir senha'),
      ),
      body: Form(
        key: formkey,
        child: SizedBox(
          height: size.height,
          width: size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Coloque o email para redefinir a senha',
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 25,
                    bottom: 30,
                    left: size.width * 0.15,
                    right: size.width * 0.15),
                child: TextFormField(
                  controller: textEditingController,
                  validator: (String? input) {
                    if (input != null && input.isNotEmpty) {
                      return null;
                    } else {
                      return 'digite seu email';
                    }
                  },
                  decoration: const InputDecoration(
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.0),
                    ),
                    labelText: 'E-mail',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(2),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: size.width * 0.2),
                child: ElevatedButton(
                  onPressed: () async {
                    final isValid = formkey.currentState!.validate();

                    if (isValid) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => const Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                      if (await BlocProvider.of<UserCubit>(context)
                          .resetPassword(textEditingController.text)) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content:
                                Text('Email de redefinição de senha enviado!'),
                          ),
                        );
                      } else {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Aconteceu algum erro!'),
                          ),
                        );
                      }
                    }
                  },
                  child: SizedBox(
                    height: 50,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        Icon(
                          Icons.mail,
                          size: 30,
                        ),
                        Text(
                          'Redefinir senha',
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
