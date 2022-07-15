import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/blaze/crash/crash_cubit.dart';
import '../../bloc/blaze/crash/crash_state.dart';
import '../blaze_double/components/custom_app_bar_settings/custom_app_bar_settings.dart';

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
        backgroundColor: const Color(0xff0f1923),
        appBar: CustomAppBarSettings(
          child: Row(
            children: [
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
              const Text(
                'Blaze Crash',
                style: TextStyle(color: Colors.white, fontSize: 20),
              )
            ],
          ),
        ),
        body: Container(
          height: size.height,
          width: size.width,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Image.asset('assets/images/APPCrash2.jpg').image,
                fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 100,
                width: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xff282C2D), width: 2),
                  ),
                  color: const Color(0xff0A1117),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'CHANCE DE CRASH FAVORÁVEL',
                          style: TextStyle(color: Colors.white),
                        ),
                        Text(
                          (crashState is CrashLoaded)
                              ? crashState.crashEntity.status
                              : '--',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 20),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 250,
                width: 250,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: Color(0xff282C2D), width: 2),
                  ),
                  color: const Color(0xff0A1117),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: (crashState is CrashLoaded)
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Estratégia\nConfirmada',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Color(0xffB35D2C),
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 12),
                                child: Text(
                                  crashState.crashEntity.titleSignal,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 50),
                                ),
                              ),
                              const Text(
                                'Entrar da',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                crashState.crashEntity.orientationSignal,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 30),
                              ),
                              const Text(
                                'RODADA APÓS',
                                style: TextStyle(color: Colors.white),
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
            ],
          ),
        ),
      );
    });
  }
}
