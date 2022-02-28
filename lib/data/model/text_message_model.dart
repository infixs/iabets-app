//model message

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_platform_interface/src/timestamp.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  TextMessageModel(
 {   required String senderName,
    required String sederUID,
    required String recipientName,
    required String recipientUID,
    required String messageType,
    required String message,
    required String messageId,
    required Timestamp time,}
  ) : super(
    senderName:senderName,
    sederUID: sederUID,
    recipientName: recipientName,
    recipientUID: recipientUID,
    messsageType:messageType,
    message:message,
    messageId:messageId,
    time: time,
        );
  factory TextMessageModel.fromSnapShot(DocumentSnapshot snapshot){

    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return TextMessageModel(
      senderName: data['senderName'],
      sederUID: data['sederUID'],
      recipientName: data['recipientName'],
      recipientUID: data['recipientUID'],
      messageType: data['messageType'],
      message: data['message'],
      messageId: data['messageId'],
      time: data['time'],
    );
  }
  Map<String,dynamic> toDocument(){
    return {
      "senderName":senderName,
      "sederUID":sederUID,
      "recipientName":recipientName,
      "recipientUID":recipientUID,
      "messageType":messsageType,
      "message":message,
      "messageId":messageId,
      "time":time,
    };
  }
}
