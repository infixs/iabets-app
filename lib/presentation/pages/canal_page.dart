import 'dart:async';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/scheduler.dart';
import 'package:ia_bet/app_const.dart';
import 'package:ia_bet/constants/cores_constants.dart';
import 'package:ia_bet/domain/entities/user_entity.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:ia_bet/repository/data.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../bloc/communication/communication_cubit.dart';

TextEditingController _textMessageController = TextEditingController();
TextEditingController _editMessageTextController = TextEditingController();
FirebaseMessaging _messaging = FirebaseMessaging.instance;

class CanalPage extends StatefulWidget {
  final String senderUID;
  final String senderName;
  final String canalName;
  final UserEntity userInfo;

  const CanalPage(
      {Key? key,
      required this.senderUID,
      required this.senderName,
      required this.canalName,
      required this.userInfo})
      : super(key: key);

  @override
  State<CanalPage> createState() => _CanalPageState();
}

class _CanalPageState extends State<CanalPage> {
  final MaskTextInputFormatter celularMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  ScrollController _scrollController = new ScrollController();
  var _isVisible = false;
  bool _selectMode = false;
  bool _keyBoardIsOpen = false;
  int totalMessages = 0;
  List<int> _selectedMessages = <int>[];

  @override
  void initState() {
    BlocProvider.of<CommunicationCubit>(context).getMessages(
      senderId: widget.senderUID,
      canalName: widget.canalName,
    );
    _textMessageController.addListener(() {});
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels <
          _scrollController.position.maxScrollExtent - 100) {
        if (_isVisible == false) {
          setState(() {
            _isVisible = true;
          });
        }
      } else {
        if (_isVisible == true) {
          setState(() {
            _isVisible = false;
          });
        }
      }
    });

    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _goScrollDown();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectMode) {
            _endSelectedMode();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          floatingActionButton: new Visibility(
            visible: _isVisible,
            child: Padding(
              padding: EdgeInsets.only(bottom: 60.0),
              child: new FloatingActionButton.small(
                elevation: 0,
                backgroundColor: Color(0xA1333333),
                onPressed: _goScrollDown,
                tooltip: 'Increment',
                child: Icon(Icons.arrow_downward),
              ),
            ),
          ),
          backgroundColor: kBackgroundColor,
          appBar: AppBar(
            titleSpacing: 0,
            elevation: 0,
            centerTitle: false,
            title: !_selectMode
                ? Row(children: [
                    Column(
                      children: [
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(48)),
                              image: new DecorationImage(
                                  fit: BoxFit.contain,
                                  alignment: Alignment.center,
                                  image: AssetImage(
                                      "assets/images/canal-image.png"))),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10),
                          child: Text(widget.canalName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w400,
                              )),
                        )
                      ],
                    )
                  ])
                : Text(
                    _selectedMessages.length.toString(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            actions: [
              _selectMode
                  ? IconButton(
                      onPressed: _deleteMessages,
                      icon: Icon(Icons.delete),
                    )
                  : Container(),
              _selectMode && _selectedMessages.length == 1
                  ? IconButton(
                      onPressed: _editMessage,
                      icon: Icon(Icons.edit),
                    )
                  : Container()
            ],
          ),
          body: BlocBuilder<CommunicationCubit, CommunicationState>(
              buildWhen: (context, state) {
            return state is CommunicationLoaded;
          }, builder: (_, communicationState) {
            if (!_keyBoardIsOpen &&
                MediaQuery.of(context).viewInsets.bottom > 0) {
              _goScrollDown();
              if (_scrollController.position.pixels >=
                  _scrollController.position.maxScrollExtent) {
                _keyBoardIsOpen = true;
              }
            }
            if (_keyBoardIsOpen &&
                MediaQuery.of(context).viewInsets.bottom == 0) {
              _keyBoardIsOpen = false;
            }

            if (communicationState is CommunicationLoaded) {
              if (totalMessages < communicationState.messages.length)
                _goScrollDown();
              totalMessages = communicationState.messages.length;
            }

            return BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
              print('ChatPage: Estou no userState');

              return Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      image: new DecorationImage(
                        fit: BoxFit.cover,
                        alignment: Alignment.center,
                        image: AssetImage(
                          "assets/images/chat-background.png",
                        ),
                      ),
                    ),
                  ),
                ),
                if (communicationState is CommunicationLoaded)
                  Visibility(
                      visible: true,
                      child: Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          bottom: userState is CurrentUserChanged &&
                                  userState.user.isAdmin
                              ? 64
                              : 45,
                          child: mensagesChatWidget(communicationState))),
                if (communicationState is! CommunicationLoaded)
                  Center(
                    child: CircularProgressIndicator(),
                  ),
                userState is CurrentUserChanged && userState.user.isAdmin
                    ? Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: writeMessageWidget())
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: Text(
                            "Esse canal é somente leitura",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ))
              ]);
            });
          }),
        ));
  }

  Widget mensagesChatWidget(CommunicationLoaded messages) {
    return Container(
      child: ListView.builder(
        controller: _scrollController,
        itemCount: messages.messages.length,
        padding: EdgeInsets.only(top: 10, bottom: 5),
        itemBuilder: (context, index) {
          return GestureDetector(
              onLongPress: () => _initSelectMode(index),
              onTapDown: (d) => _selectMessage(index),
              child: Container(
                  padding: EdgeInsets.only(top: 5, bottom: 5),
                  color: _selectMode && _selectedMessages.contains(index)
                      ? Color.fromARGB(50, 0, 100, 255)
                      : Colors.transparent,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(width: 5),
                      messages.messages[index].recipientUID != widget.senderUID
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(125)),
                                color: (messages.messages[index].recipientUID ==
                                        widget.senderUID
                                    ? Color(0xFFF2F2F7)
                                    : Color(0x00FFFFFF)),
                              ),
                            )
                          : Container(),
                      Flexible(
                        child: Container(
                          padding: messages.messages[index].recipientUID !=
                                  widget.senderUID
                              ? EdgeInsets.only(bottom: 0, right: 50)
                              : EdgeInsets.only(bottom: 0, left: 50),
                          child: Align(
                            alignment: (messages.messages[index].recipientUID !=
                                    widget.senderUID
                                ? Alignment.topLeft
                                : Alignment.topRight),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Color.fromARGB(255, 207, 207, 207),
                                      spreadRadius: 0,
                                      blurRadius: 1,
                                      offset: Offset(0, 1))
                                ],
                                borderRadius:
                                    messages.messages[index].recipientUID ==
                                            widget.senderUID
                                        ? BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            bottomLeft: Radius.circular(8),
                                            topLeft: Radius.circular(8))
                                        : BorderRadius.only(
                                            topRight: Radius.circular(8),
                                            topLeft: Radius.circular(8),
                                            bottomRight: Radius.circular(8)),
                                color: (messages.messages[index].recipientUID ==
                                        widget.senderUID
                                    ? Color.fromARGB(255, 244, 252, 225)
                                    : Colors.white),
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: _generateTextMessage(
                                          messages.messages[index].message),
                                    ),
                                    Container(
                                        child: Text(
                                      DateFormat('HH:mm').format(messages
                                          .messages[index].time
                                          .toDate()),
                                      style: TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400,
                                        color: (messages.messages[index]
                                                    .recipientUID ==
                                                widget.senderUID
                                            ? Color.fromARGB(255, 136, 136, 136)
                                            : Color.fromARGB(
                                                255, 136, 136, 136)),
                                      ),
                                    )),
                                  ]),
                            ),
                          ),
                        ),
                      ),
                      messages.messages[index].recipientUID == widget.senderUID
                          ? Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(0)),
                                color: (messages.messages[index].recipientUID ==
                                        widget.senderUID
                                    ? Color(0x00F2F2F7)
                                    : kPrimaryColor),
                              ),
                            )
                          : Container()
                    ],
                  )));
        },
      ),
    );
  }

  Widget writeMessageWidget() {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Material(
        elevation: 1.5,
        shadowColor: Color.fromARGB(100, 241, 241, 241),
        borderRadius: new BorderRadius.circular(25),
        child: TextField(
          controller: _textMessageController,
          keyboardType: TextInputType.multiline,
          maxLines: null,
          decoration: InputDecoration(
              hintText: 'Mensagem...',
              filled: true,
              fillColor: Colors.white,
              contentPadding:
                  const EdgeInsets.only(left: 15.0, bottom: 8.0, top: 8.0),
              hintStyle: TextStyle(
                  fontSize: AppConst.chatTextSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
              labelStyle: TextStyle(
                  fontSize: AppConst.chatTextSize,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
              focusedBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: new BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: new BorderSide(color: Colors.white),
                borderRadius: new BorderRadius.circular(25),
              ),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: Icon(Icons.sentiment_satisfied_alt),
                color: textSilver,
              ),
              suffixIcon: Container(
                child: Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween, // added line
                  mainAxisSize: MainAxisSize.min, // added line
                  children: [
                    Container(
                      child: IconButton(
                        onPressed: () {
                          _sendFile();
                        },
                        icon: Icon(Icons.attach_file),
                        color: textSilver,
                      ),
                    ),
                    Container(
                      child: IconButton(
                        onPressed: () {
                          _sendMessage();
                        },
                        icon: Icon(Icons.send),
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }

  void _scrollDown([int duration = 1]) {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: duration),
      curve: Curves.fastOutSlowIn,
    );
  }

  void _selectMessage(int index) {
    if (_selectMode) {
      setState(() {
        if (!_selectedMessages.contains(index))
          _selectedMessages.add(index);
        else {
          _selectedMessages.remove(index);
          if (_selectedMessages.length == 0) _selectMode = false;
        }
      });
    }
  }

  void _initSelectMode(int index) {
    if (!BlocProvider.of<UserCubit>(context).currentUserIsAdmin()) return;
    setState(() {
      _selectMode = true;
      _selectedMessages.add(index);
    });
  }

  Widget _generateTextMessage(String message) {
    List<TextSpan> textMessage = [];
    final searchLinks = RegExp(
        r'(?:(?:https?|ftp|file):\/\/|www\.|ftp\.)(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[-A-Z0-9+&@#\/%=~_|$?!:,.])*(?:\([-A-Z0-9+&@#\/%=~_|$?!:,.]*\)|[A-Z0-9+&@#\/%=~_|$])',
        caseSensitive: false,
        multiLine: true);
    if (searchLinks.hasMatch(message)) {
      int initialPosition = 0;
      searchLinks.allMatches(message).forEach((element) {
        final String linkText = message.substring(element.start, element.end);
        if (element.start > 0) {
          textMessage.add(TextSpan(
              text: message.substring(initialPosition, element.start),
              style: TextStyle(
                  fontSize: AppConst.chatTextSize, color: Colors.black)));
        }

        textMessage.add(TextSpan(
            text: linkText,
            style:
                TextStyle(fontSize: AppConst.chatTextSize, color: Colors.blue),
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final existsHttp = RegExp(r'^https?', caseSensitive: false);

                await launchURL(!existsHttp.hasMatch(linkText)
                    ? "https://" + linkText
                    : linkText);
              }));

        initialPosition = element.end;
      });
      if (initialPosition != message.length) {
        textMessage.add(TextSpan(
            text: message.substring(initialPosition, message.length),
            style: TextStyle(
                fontSize: AppConst.chatTextSize, color: Colors.black)));
      }
    } else {
      textMessage.add(TextSpan(
          text: message,
          style:
              TextStyle(fontSize: AppConst.chatTextSize, color: Colors.black)));
    }

    return RichText(text: TextSpan(children: textMessage));
  }

  Future<void> launchURL(url) async {
    if (!await launch(url)) throw 'Could not launch $url';
  }

  void _deleteMessages() async {
    BlocProvider.of<CommunicationCubit>(context)
        .deleteMessages(
            channelId: widget.canalName, messages: _selectedMessages)
        .then((res) => _endSelectedMode())
        .catchError((e) => {});
  }

  _sendMessage() async {
    if (_textMessageController.text.isNotEmpty) {
      await BlocProvider.of<CommunicationCubit>(context).sendTextMessage(
          senderId: widget.senderUID,
          message: _textMessageController.text,
          canalName: widget.canalName,
          type: 'TEXT',
          element: widget.userInfo);
      //_messaging.subscribeToTopic();
      BlocProvider.of<MyChatCubit>(context).sendPushMessage(
          channelId: widget.canalName,
          title: widget.canalName,
          message: _textMessageController.text);
      _textMessageController.clear();
      Timer(Duration(milliseconds: 500), () {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      });
    }
  }

  void _goScrollDown() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) async {
      if (_scrollController.hasClients) {
        print("vamos ver 2");
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        timer.cancel();

        await Future.delayed(Duration(milliseconds: 200), () {
          if (_scrollController.position.maxScrollExtent !=
              _scrollController.position.pixels) _goScrollDown();
        });
      }
    });
  }

  void _editMessage() {
    String message = BlocProvider.of<CommunicationCubit>(context)
        .getMessage(_selectedMessages[0]);

    _editMessageTextController.text = message;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // retorna um objeto do tipo Dialog
        return AlertDialog(
          title: new Text("Editar mensagem:"),
          content: TextFormField(
            controller: _editMessageTextController,
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () async {
                await BlocProvider.of<CommunicationCubit>(context).editMessage(
                    channelId: widget.canalName,
                    messageIndex: _selectedMessages[0],
                    messageText: _editMessageTextController.text);
                Navigator.pop(context);
                _endSelectedMode();
              },
              child: Text('Salvar'),
            )
            // define os botões na base do dialogo
          ],
        );
      },
    );
  }

  void _endSelectedMode() {
    setState(() {
      _selectedMessages = [];
      _selectMode = false;
    });
  }

  _sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['jpg', 'pdf', 'doc'],
    );
    if (result != null) {
      final name = result.files.first.name;
      _textMessageController.text = name;
      var file = result.files.first.bytes;
      var extension = result.files.first.extension;

      BlocProvider.of<CommunicationCubit>(context).sendFile(
          canalName: widget.canalName,
          file: file!,
          name: '$name.$extension',
          senderId: widget.senderUID,
          type: 'FILE',
          element: widget.userInfo);
    }
  }

  _getUrl(canal, name) {
    return BlocProvider.of<CommunicationCubit>(context)
        .getUrl(canalName: canal, name: name);
  }
}

void _launchURL(url) async {
  if (!await launch(url)) throw 'Could not launch $url';
}
