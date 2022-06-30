import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/user/user_cubit.dart';

import 'blaze/blaze_page.dart';
import 'canais_page.dart';

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
          'route': CanaisPage(userInfo: await getUser())
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

  Future<UserEntity> getUser() async =>
      await BlocProvider.of<UserCubit>(context).getCurrentUserWithReturn();

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
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
        ),
        body: Stack(
          children: [
            Image.asset('assets/images/background_home_page.png'),
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
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) =>
                                  snapshot.data![index]['route']),
                        ),
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
                                flex: 3,
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
        ));
  }
}
