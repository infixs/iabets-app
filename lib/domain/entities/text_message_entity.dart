import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'dart:typed_data';

class TextMessageEntity extends Equatable {
  final String senderName;
  final String sederUID;
  final String recipientName;
  final String recipientUID;
  final String messsageType;
  final String message;
  final String messageId;
  final bool? isResponse;
  final String? responseText;
  final String? responseSenderName;
  final FileEntity? file;
  final Timestamp time;

  const TextMessageEntity({
    required this.senderName,
    required this.sederUID,
    required this.recipientName,
    required this.recipientUID,
    required this.messsageType,
    required this.message,
    required this.messageId,
    this.isResponse,
    this.responseText,
    this.responseSenderName,
    this.file,
    required this.time,
  });

  @override
  List<Object> get props => [
        senderName,
        sederUID,
        recipientName,
        recipientUID,
        messsageType,
        message,
        messageId,
        isResponse != null && isResponse == true,
        responseText != null ? responseText.toString() : '',
        responseSenderName != null ? responseSenderName.toString() : '',
        file!,
        time,
      ];
}

class FileEntity {
  final String name;
  String mime;
  String? url;
  String? id;
  bool? failed;
  String? localPath;
  final Uint8List? bytes;

  FileEntity({
    required this.name,
    required this.mime,
    this.url,
    this.id,
    this.failed,
    this.localPath,
    this.bytes,
  });
}
