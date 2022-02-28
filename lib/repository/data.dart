import 'package:flutter/material.dart';

List<ChatMessage> messages = [
  ChatMessage(
      messageContent: "Lorem ipsum dollor, ipsum dollor lorem ipsum.",
      messageType: "receiver"),
  ChatMessage(
      messageContent: "Lorem ipsum dollor, ipsum dollor lorem ipsum.",
      messageType: "sender"),
  ChatMessage(messageContent: "ok.", messageType: "receiver"),
];

class ChatMessage {
  String? messageContent;
  String? messageType;
  ChatMessage({@required this.messageContent, @required this.messageType});
}
