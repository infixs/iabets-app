import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ia_bet/presentation/pages/canais_page.dart';

import '../../domain/entities/user_entity.dart';
import '../bloc/user/user_cubit.dart';
import 'blaze_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<Map<String, dynamic>>> makeButtons() async => [
        {'title': 'canais', 'route': CanaisPage(userInfo: await getUser())},
        {'title': 'blaze', 'route': BlazePage()},
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
            ),
            Text('Bets')
          ],
        ),
      ),
      body: FutureBuilder(
        future: makeButtons(),
        builder: (BuildContext context,
            AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (BuildContext context, int index) => Padding(
                padding: EdgeInsets.only(
                    left: size.width * 0.2,
                    right: size.width * 0.2,
                    top: size.height * 0.05),
                child: ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            snapshot.data![index]['route']),
                  ),
                  child: Center(
                    child: Text(snapshot.data![index]['title']),
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
    );
  }
}
