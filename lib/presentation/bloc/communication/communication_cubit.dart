import 'dart:io';
import 'dart:typed_data';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:ia_bet/app_const.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/usecases/add_to_my_chat_usecase.dart';
import 'package:ia_bet/domain/usecases/get_all_user_usecase.dart';
import 'package:ia_bet/domain/usecases/get_one_to_one_single_user_chat_channel_usecase.dart';
import 'package:ia_bet/domain/usecases/get_text_messages_usecase.dart';
import 'package:ia_bet/domain/usecases/get_url_file_usecase.dart';
import 'package:ia_bet/domain/usecases/send_text_message_usecase.dart';
import 'package:ia_bet/domain/usecases/upload_file_usecase.dart';

part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final GetOneToOneSingleUserChatChannelUseCase getOneToOneSingleUserChatChannelUseCase;
  final GetTextMessagesUseCase getTextMessagesUseCase;
  final AddToMyChatUseCase addToMyChatUseCase;
  final GetAllUserUseCase getAllUserUseCase;
  final UploadFiletUseCase uploadFiletUseCase;
  final GetUrlFileUseCase getUrlFileUseCase;

  CommunicationCubit({
    required this.getTextMessagesUseCase,
    required this.addToMyChatUseCase,
    required this.getOneToOneSingleUserChatChannelUseCase,
    required this.sendTextMessageUseCase,
    required this.getAllUserUseCase,
    required this.getUrlFileUseCase,
    required this.uploadFiletUseCase
  }) : super(CommunicationInitial());



  Future<void> sendTextMessage({
    required String senderId,
    required String message,
    required String canalName,
    required String type,
    required UserEntity element
  }) async {
    try {

      List<UserEntity> allUsers = [] ;
     final userStreamData = await getAllUserUseCase.call();
     userStreamData.listen((users) {
       allUsers = users;
     });

     allUsers = await userStreamData.first;

        await sendTextMessageUseCase.sendTextMessage(
          TextMessageEntity(
            time: Timestamp.now(),
            sederUID: '111',
            message: message,
            messageId: "",
            messsageType: type, 
            recipientName: '', 
            recipientUID: '', 
            senderName: '',
          ),
          canalName,
          element
        );
        
        allUsers.forEach((element) async {
          await addToMyChatUseCase.call(MyChatEntity(
            time: Timestamp.now(),
            senderUID: '111',
            recentTextMessage: message,
            profileURL: "",
            isRead: false,
            isArchived: false,
            channelId: canalName, 
            name: '', 
            recipientName: '', 
            recipientPhoneNumber: '', 
            recipientUID: element.uid, 
            senderName: '', 
            senderPhoneNumber: '',
          ),
          element);
        });
          
    } on SocketException catch (e) {
      print(e);
      emit(CommunicationFailure());
    } catch (e) {
      print(e);
      emit(CommunicationFailure());
    }
  }

   Future<void> getMessages({required String senderId,required String canalName}) async {
    emit(CommunicationLoading());
    try{

      final messagesStreamData = getTextMessagesUseCase.call(canalName);
      messagesStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });

      List<TextMessageEntity> messages = await messagesStreamData.first;

      print('messages');
      print(messages.length);

      emit(CommunicationLoaded(messages: await messagesStreamData.first));

    }on SocketException catch(_){
      emit(CommunicationFailure());
    }catch(_){
      emit(CommunicationFailure());
    }
  }

  Future<void> sendFile({required String canalName, required String name, required Uint8List file, required String senderId, required type, required UserEntity element}) async{

      emit(CommunicationLoading());

      try{

        await uploadFiletUseCase.call(canalName, name, file);
        await sendTextMessage.call(
          senderId: senderId,
          message: senderId,
          canalName: canalName,
          type: type,
          element: element
        );

      }on SocketException catch(_){

        emit(CommunicationFailure());

      }catch(_){

        emit(CommunicationFailure());

      }

  }

  Future<String> getUrl({required String canalName, required String name}) async{

      emit(CommunicationLoading());

      try{

        var url = await getUrlFileUseCase.call(canalName, name);

        return url;
        


      }on SocketException catch(_){

        emit(CommunicationFailure());
        return '';

      }catch(_){

        emit(CommunicationFailure());
        return '';

      }

  }


}
