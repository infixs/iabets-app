// model Chat

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/my_chat_entity.dart';

class MyChatModel extends MyChatEntity {
  MyChatModel(
      {required String senderName,
      required String senderUID,
      required String recipientName,
      required String recipientUID,
      required String channelId,
      required String profileURL,
      required String recipientPhoneNumber,
      required String senderPhoneNumber,
      required String recentTextMessage,
      required bool isRead,
      required bool isArchived,
      required Timestamp time,
      required String name})
      : super(
            senderName: senderName,
            senderUID: senderUID,
            recipientName: recipientName,
            recipientUID: recipientUID,
            channelId: channelId,
            profileURL: profileURL,
            recipientPhoneNumber: recipientPhoneNumber,
            senderPhoneNumber: senderPhoneNumber,
            recentTextMessage: recentTextMessage,
            isRead: isRead,
            isArchived: isArchived,
            time: time,
            name: name);

  factory MyChatModel.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    return MyChatModel(
        senderName: data['senderName'],
        senderUID: data['senderUID'],
        senderPhoneNumber: data['senderPhoneNumber'],
        recipientName: data['recipientName'],
        recipientUID: data['recipientUID'],
        recipientPhoneNumber: data['recipientPhoneNumber'],
        channelId: data['channelId'],
        time: data['time'],
        isArchived: data['isArchived'],
        isRead: data['isRead'],
        recentTextMessage: data['recentTextMessage'],
        profileURL: data['profileURL'],
        name: data['name']);
  }

  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "senderUID": senderUID,
      "recipientName": recipientName,
      "recipientUID": recipientUID,
      "channelId": channelId,
      "profileURL": profileURL,
      "recipientPhoneNumber": recipientPhoneNumber,
      "senderPhoneNumber": senderPhoneNumber,
      "recentTextMessage": recentTextMessage,
      "isRead": isRead,
      "isArchived": isArchived,
      "time": time,
      "name": name
    };
  }
}
