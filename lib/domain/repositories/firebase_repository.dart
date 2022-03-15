// interface entre o datasource e o domínio

import 'dart:typed_data';

import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

abstract class FirebaseRepository {
  Future<void> verifyPhoneNumber(String phoneNumber);
  Future<void> signInWithPhoneNumber(String smsPinCode);
  Future<void> signInWithEmail(
      {required String email, required String password});
  Future<bool> isSignIn();
  Future<void> signOut();
  Future<String> getCurrentUID();
  Future<void> getCreateCurrentUser(UserEntity user);
  Future<void> setUserToken(String token);

  Stream<List<UserEntity>> getAllUsers();
  Stream<UserEntity> getCurrentUser();
  Stream<List<TextMessageEntity>> getMessages(String channelId);
  Stream<List<MyChatEntity>> getMyChat(String uid);

  Future<void> sendPushMessage(String channelId, String title, String message);

  Future<void> deleteMessages(String channelId, List<String> messages);
  Future<void> editMessage(String channelId, String messageId, String messageText);

  Future<void> createOneToOneChatChannel(
      String uid, String name, List<UserEntity> allUsers);
  Future<String> getOneToOneSingleUserChannelId(String uid, String canalName);
  Future<void> addToMyChat(MyChatEntity myChatEntity, UserEntity allUsers);
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId, UserEntity allUsers);
  Future<void> uploadFileMessage(String canalName, String name, Uint8List file);
  Future<String> getDownloadFileMessage(String canalName, String name);
}
