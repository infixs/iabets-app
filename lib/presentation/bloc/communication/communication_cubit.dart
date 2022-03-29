import 'dart:async';
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
import 'package:ia_bet/domain/usecases/delete_messages_usecase.dart';
import 'package:ia_bet/domain/usecases/edit_message_usecase.dart';

part 'communication_state.dart';

class CommunicationCubit extends Cubit<CommunicationState> {
  final SendTextMessageUseCase sendTextMessageUseCase;
  final GetOneToOneSingleUserChatChannelUseCase
      getOneToOneSingleUserChatChannelUseCase;
  final GetTextMessagesUseCase getTextMessagesUseCase;
  final AddToMyChatUseCase addToMyChatUseCase;
  final GetAllUserUseCase getAllUserUseCase;
  final UploadFiletUseCase uploadFiletUseCase;
  final GetUrlFileUseCase getUrlFileUseCase;
  final DeleteMessagesUseCase deleteMessagesUseCase;
  final EditMessageUseCase editMessageUseCase;

  CommunicationCubit(
      {required this.getTextMessagesUseCase,
      required this.addToMyChatUseCase,
      required this.getOneToOneSingleUserChatChannelUseCase,
      required this.sendTextMessageUseCase,
      required this.getAllUserUseCase,
      required this.getUrlFileUseCase,
      required this.uploadFiletUseCase,
      required this.deleteMessagesUseCase,
      required this.editMessageUseCase})
      : super(CommunicationInitial());

  Future<void> sendTextMessage(
      {required String senderId,
      required String message,
      required String senderName,
      required String canalName,
      required String type,
      bool? isResponse,
      String? responseText,
      String? responseSenderName,
      FileEntity? file,
      required UserEntity element}) async {
    try {
      /*List<UserEntity> allUsers = [];
      final userStreamData = await getAllUserUseCase.call();
      userStreamData.listen((users) {
        allUsers = users;
      });

      allUsers = await userStreamData.first;*/

      UserEntity userDefault = new UserEntity(
          name: senderName,
          email: 'admin@iabets.com.br',
          phoneNumber: '+55',
          isOnline: false,
          uid: senderId,
          profileUrl: '',
          isAdmin: true);

      await sendTextMessageUseCase.sendTextMessage(
          TextMessageEntity(
            time: Timestamp.now(),
            sederUID: senderId,
            message: message,
            messageId: "",
            messsageType: type,
            recipientName: senderName,
            recipientUID: senderId,
            file: file,
            isResponse: isResponse == null ? false : isResponse,
            responseText: responseText == null ? '' : responseText,
            responseSenderName:
                responseSenderName == null ? '' : responseSenderName,
            senderName: senderName,
          ),
          canalName,
          userDefault);

      await addToMyChatUseCase.call(
          MyChatEntity(
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

      /*allUsers.forEach((element) async {
        await addToMyChatUseCase.call(
            MyChatEntity(
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
      });*/
    } on SocketException catch (e) {
      print(e);
      emit(CommunicationFailure());
    } catch (e) {
      print(e);
      emit(CommunicationFailure());
    }
  }

  Future<void> getMessages(
      {required String senderId, required String canalName}) async {
    emit(CommunicationLoading());
    try {
      final messagesStreamData = getTextMessagesUseCase.call(canalName);

      messagesStreamData.listen((messages) {
        emit(CommunicationLoaded(messages: messages));
      });

      List<TextMessageEntity> messages = await messagesStreamData.first;

      emit(CommunicationLoaded(messages: await messagesStreamData.first));
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  String getMessage(int index) {
    return (state as CommunicationLoaded).messages[index].message;
  }

  Future<void> deleteMessages(
      {required String channelId, required List<int> messages}) async {
    List<TextMessageEntity> currentMessages =
        (state as CommunicationLoaded).messages;

    List<String> deleteMessages = [];

    messages.forEach((message) {
      deleteMessages.add(currentMessages[message].messageId);
    });

    deleteMessagesUseCase.call(channelId, deleteMessages);
  }

  Future<void> editMessage(
      {required String channelId,
      required int messageIndex,
      required String messageText}) async {
    String messageId =
        (state as CommunicationLoaded).messages[messageIndex].messageId;

    print(channelId);
    print(messageId);
    print(messageText);
    editMessageUseCase.call(channelId, messageId, messageText);
  }

  Future<void> sendFile(
      {required String canalName,
      required String name,
      required Uint8List file,
      required String senderId,
      required type,
      required UserEntity element}) async {
    emit(CommunicationLoading());

    try {
      await uploadFiletUseCase.call(canalName, name, file);
      await sendTextMessage.call(
          senderId: senderId,
          message: senderId,
          canalName: canalName,
          senderName: name,
          type: type,
          element: element);
    } on SocketException catch (_) {
      emit(CommunicationFailure());
    } catch (_) {
      emit(CommunicationFailure());
    }
  }

  Future<String> getUrl(
      {required String canalName, required String name}) async {
    emit(CommunicationLoading());

    try {
      var url = await getUrlFileUseCase.call(canalName, name);

      return url;
    } on SocketException catch (_) {
      emit(CommunicationFailure());
      return '';
    } catch (_) {
      emit(CommunicationFailure());
      return '';
    }
  }
}

class FileCubit extends Cubit<FileState> {
  FileCubit() : super(FileInitial());

  Future<void> getLocalOrDownload() async{
    
  }
}
