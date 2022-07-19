import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blaze/crash/crash_cubit.dart';
import '../../bloc/blaze/crash/crash_state.dart';

class BlazeCrashPage extends StatefulWidget {
  const BlazeCrashPage({super.key});

  @override
  State<BlazeCrashPage> createState() => _BlazeCrashPageState();
}

class _BlazeCrashPageState extends State<BlazeCrashPage> {
  @override
  void initState() {
    BlocProvider.of<CrashCubit>(context).getCrash();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocBuilder<CrashCubit, CrashState>(builder: (context, crashState) {
      return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: const Color(0xff0f1923),
        appBar: AppBar(elevation: 0, backgroundColor: Colors.transparent),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            gradient: RadialGradient(colors: <Color>[
              Colors.grey.shade700,
              Colors.black,
            ], radius: 1),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Image.asset(
                'assets/images/iabetscrash.png',
                width: 140,
              ),
              SizedBox(
                height: 120,
                width: 300,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xfffe7800), width: 2),
                  ),
                  color: const Color(0xff1f1f1f),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'CHANCE DE CRASH FAVORÁVEL',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          (crashState is CrashLoaded)
                              ? crashState.crashEntity.status
                              : '--',
                          style: const TextStyle(
                              color: Color(0xfffe7800),
                              fontSize: 40,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 275,
                width: 275,
                decoration: const BoxDecoration(boxShadow: [
                  BoxShadow(
                    color: Color(0xfffe7800),
                    blurRadius: 20.0,
                    spreadRadius: 00,
                  ),
                ], shape: BoxShape.circle),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360),
                    side: const BorderSide(color: Color(0xfffe7800), width: 2),
                  ),
                  color: const Color(0xff1f1f1f),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (crashState is CrashLoaded &&
                            !crashState.crashEntity.waiting)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Alvo\nConfirmado',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  crashState.crashEntity.titleSignal,
                                  style: const TextStyle(
                                      color: Color(0xfffe7800),
                                      fontSize: 50,
                                      fontFamily: 'Nasalization',
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text(
                                'Entrar da',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600),
                              ),
                              Text(
                                crashState.crashEntity.orientationSignal,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 30,
                                    fontFamily: 'Nasalization',
                                    fontWeight: FontWeight.w600),
                              ),
                              const Text(
                                'Oportunidade\n apos o alvo',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: const [
                              Text(
                                'AGUARDANDO SINAL',
                                style: TextStyle(color: Colors.white),
                              ),
                              Center(
                                child: CircularProgressIndicator(),
                              ),
                            ],
                          ),
                  ),
                ),
              ),
              Image.asset(
                'assets/images/voce_nao_esta_sozinho.png',
                width: 80,
              ),
            ],
          ),
        ),
      );
    });
  }
}
