import 'dart:typed_data';

import 'package:ia_bet/data/datasource/firebase_remote_datasource.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/domain/repositories/firebase_repository.dart';

class FirebaseRepositoryImpl implements FirebaseRepository{
  final FirebaseRemoteDataSource remoteDataSource;

  FirebaseRepositoryImpl({required this.remoteDataSource});
  @override
  Future<void> getCreateCurrentUser(UserEntity user) async =>
      await remoteDataSource.getCreateCurrentUser(user);

  @override
  Future<String> getCurrentUID()async =>
      await remoteDataSource.getCurrentUID();
  @override
  Future<bool> isSignIn()async =>
      await remoteDataSource.isSignIn();

  @override
  Future<void> signInWithPhoneNumber(String smsPinCode) async =>
      await remoteDataSource.signInWithPhoneNumber(smsPinCode);

  @override
  Future<void> signOut() async =>
      await remoteDataSource.signOut();

  @override
  Future<void> verifyPhoneNumber(String phoneNumber) async =>
      await remoteDataSource.verifyPhoneNumber(phoneNumber);

  @override
  Future<void> addToMyChat(MyChatEntity myChatEntity, UserEntity allUsers) async{
    return remoteDataSource.addToMyChat(myChatEntity, allUsers);
  }

  @override
  Future<void> createOneToOneChatChannel(String uid, String name, List<UserEntity> allUsers) async
  => remoteDataSource.createOneToOneChatChannel(uid, name, allUsers);

  @override
  Stream<List<UserEntity>> getAllUsers() =>
      remoteDataSource.getAllUsers();

  @override
  Future<void> sendPushMessage(String channelId, String title, String message) =>
      remoteDataSource.sendPushMessage(channelId, title, message);

  @override
  Stream<UserEntity> getCurrentUser() =>
      remoteDataSource.getCurrentUser();

  @override
  Future<void> setUserToken(String token) => remoteDataSource.setUserToken(token);

  @override
  Stream<List<TextMessageEntity>> getMessages(String channelId) {
    return remoteDataSource.getMessages(channelId);
  }

  @override
  Future<void> deleteMessages(String channelId, List<String> messages) {
    return remoteDataSource.deleteMessages(channelId, messages);
  }

  @override
  Stream<List<MyChatEntity>> getMyChat(String uid) {
    return remoteDataSource.getMyChat(uid);
  }

  @override
  Future<String> getOneToOneSingleUserChannelId(String uid, String canalName) =>
      remoteDataSource.getOneToOneSingleUserChannelId(uid, canalName);

  @override
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,String channelId, UserEntity allUsers)async {
    return remoteDataSource.sendTextMessage(textMessageEntity, channelId, allUsers);
  }

  @override 
  Future<void> signInWithEmail({required String email, required String password}){
    return remoteDataSource.signInWithEmail(email: email, password: password);
  }

  @override 
  Future<void> uploadFileMessage(String canalName, String name, Uint8List file){
    return remoteDataSource.uploadFileMessage(canalName, name, file);
  }

  @override 
  Future<String> getDownloadFileMessage(String canalName, String name){
    return remoteDataSource.getDownloadFileMessage(canalName, name);
  }


}