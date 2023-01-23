import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blaze/crash/crash_cubit.dart';
import '../../bloc/blaze/crash/crash_state.dart';

class PlayPixAviatorPage extends StatefulWidget {
  const PlayPixAviatorPage({super.key});

  @override
  State<PlayPixAviatorPage> createState() => _PlayPixAviatorPageState();
}

class _PlayPixAviatorPageState extends State<PlayPixAviatorPage> {
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
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/aviator_background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  'assets/images/logo-iabets-aviator.png',
                  width: 170,
                ),
              ),
              SizedBox(
                height: 120,
                width: 300,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: const BorderSide(color: Color(0xfffe7800), width: 2),
                  ),
                  color: Colors.black,
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
                              ? crashState.crashEntity.status.toUpperCase()
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
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/radar.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Card(
                  color: Colors.transparent,
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
                                ),
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
                                ),
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
