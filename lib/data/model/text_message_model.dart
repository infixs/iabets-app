//model message

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ia_bet/domain/entities/text_message_entity.dart';

class TextMessageModel extends TextMessageEntity {
  TextMessageModel({
    required String senderName,
    required String sederUID,
    required String recipientName,
    required String recipientUID,
    required String messageType,
    required String message,
    required String messageId,
    bool? isResponse,
    String? responseText,
    String? responseSenderName,
    FileEntity? file,
    required Timestamp time,
  }) : super(
          senderName: senderName,
          sederUID: sederUID,
          recipientName: recipientName,
          recipientUID: recipientUID,
          messsageType: messageType,
          message: message,
          messageId: messageId,
          isResponse: isResponse,
          responseText: responseText,
          responseSenderName: responseSenderName,
          file: file,
          time: time,
        );
  factory TextMessageModel.fromSnapShot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

    FileEntity fileData = FileEntity(
        mime: data['fileType'] ?? '',
        name: data['fileName'] ?? '',
        url: data['fileUrl'] ?? '',
        id: data['fileId'] ?? '');

    return TextMessageModel(
      senderName: data['senderName'],
      sederUID: data['sederUID'],
      recipientName: data['recipientName'],
      recipientUID: data['recipientUID'],
      messageType: data['messageType'],
      message: data['message'],
      messageId: snapshot.id,
      isResponse: data['isResponse'],
      responseText:
          data['responseText'] != null ? data['responseText'].toString() : '',
      responseSenderName: data['responseSenderName'] != null
          ? data['responseSenderName'].toString()
          : '',
      file: fileData,
      time: data['time'],
    );
  }
  Map<String, dynamic> toDocument() {
    return {
      "senderName": senderName,
      "sederUID": sederUID,
      "recipientName": recipientName,
      "recipientUID": recipientUID,
      "messageType": messsageType,
      "message": message,
      "messageId": messageId,
      "isResponse": isResponse == null ? false : isResponse,
      "responseText":
          responseText != null && responseText!.length > 0 ? responseText : '',
      "responseSenderName":
          responseSenderName != null && responseSenderName!.length > 0
              ? responseSenderName
              : '',
      "fileUrl": file?.url,
      "fileId": file?.id,
      "fileType": file?.mime,
      "time": time,
      "fileName": file?.name
    };
  }
}
