// interface entre o datasource e o domínio

import 'dart:typed_data';

import 'package:ia_bet/domain/entities/double_config.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';
import 'package:ia_bet/domain/entities/strategy_entity.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';

import '../../data/model/double_config_model.dart';
import '../entities/aviator_entity.dart';
import '../entities/crash_entity.dart';

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
  Future<void> setDeviceidToken();

  Stream<List<UserEntity>> getAllUsers();
  Stream<UserEntity> getCurrentUser();

  Stream<List<TextMessageEntity>> getMessages(String channelId);
  Stream<List<MyChatEntity>> getMyChat(String uid);

  Future<void> sendPushMessage(String channelId, String title, String message);

  Future<void> deleteMessages(String channelId, List<String> messages);
  Future<void> editMessage(
      String channelId, String messageId, String messageText);

  Future<void> createOneToOneChatChannel(
      String uid, String name, List<UserEntity> allUsers);
  Future<String?> getOneToOneSingleUserChannelId(String uid, String canalName);
  Future<void> addToMyChat(MyChatEntity myChatEntity, UserEntity allUsers);
  Future<void> sendTextMessage(TextMessageEntity textMessageEntity,
      String channelId, UserEntity allUsers);
  Future<void> uploadFileMessage(String canalName, String name, Uint8List file);
  Future<String> getDownloadFileMessage(String canalName, String name);

  Stream<DoubleConfigEntity> getDoubleConfig();
  Future<void> saveDoubleConfig(DoubleConfigModel doubleConfig);
  Future<List<StrategyEntity>> getStrategies();
  Stream<CrashEntity?> getCrashEntity();
  Stream<AviatorEntity?> getAviatorEntity();
}
