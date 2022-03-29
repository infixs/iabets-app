import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/usecases/get_my_chat_usecase.dart';
import 'package:ia_bet/domain/usecases/send_push_message_usecase.dart';

part 'my_chat_state.dart';

class MyChatCubit extends Cubit<MyChatState> {
  final GetMyChatUseCase getMyChatUseCase;
  final SendPushMessageUseCase sendPushMessageUseCase;

  MyChatCubit({
    required this.getMyChatUseCase,
    required this.sendPushMessageUseCase,
  }) : super(MyChatInitial());

  Future<void> getMyChat({required String uid}) async {
    try {
      final myChatStreamData = getMyChatUseCase.call(uid);
      myChatStreamData.listen((myChatData) {
        emit(MyChatLoaded(myChat: myChatData));
      });
      List<MyChatEntity> list = await myChatStreamData.first;
      print(list.length);
    } on SocketException catch (_) {
    } catch (_) {}
  }

  Future<void> sendPushMessage(
      {required String channelId,
      required String title,
      required String message}) async {
    try {
      sendPushMessageUseCase.call(channelId, title, message);
    } catch (_) {}
  }
}
