import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ia_bet/presentation/bloc/my_chat/my_chat_cubit.dart';
import 'package:ia_bet/presentation/bloc/user/user_cubit.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../app_const.dart';
import '../../constants/cores_constants.dart';
import '../../domain/entities/text_message_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../bloc/communication/communication_cubit.dart';

TextEditingController _textMessageController = TextEditingController();
TextEditingController _editMessageTextController = TextEditingController();

FocusNode myFocusNode = FocusNode();

class FileLoaded {
  File? file;
  bool loaded = false;
  String? type;
  String? name;

  FileLoaded({this.file, bool? loaded, String? type, String? name}) {
    this.loaded = loaded == null ? false : true;
    this.type = type ?? '';
    this.name = name ?? '';
  }
}

Map<String, FileLoaded> cachedFiles = {};

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
  final ScrollController scrollController = ScrollController();
  var _isVisible = false;
  bool _selectMode = false;
  bool _isReply = false;
  bool _isFile = false;
  late FileEntity _file;
  String replyText = "";
  String replySender = "";
  bool _isSendingFile = false;
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
    scrollController.addListener(() {
      if (scrollController.position.pixels <
          scrollController.position.maxScrollExtent - 100) {
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

    /*WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _goScrollDown();
    });*/
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          if (_selectMode || _isReply || _isFile) {
            _cancelReply();
            _isFile = false;
            _endSelectedMode();
            return false;
          } else {
            return true;
          }
        },
        child: Scaffold(
          floatingActionButton: Visibility(
            visible: _isVisible,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 60.0),
              child: FloatingActionButton.small(
                elevation: 0,
                backgroundColor: const Color(0xA1333333),
                onPressed: _goScrollDown,
                tooltip: 'Increment',
                child: const Icon(Icons.arrow_downward),
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
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(48),
                            ),
                            image: DecorationImage(
                              fit: BoxFit.contain,
                              alignment: Alignment.center,
                              image:
                                  AssetImage("assets/images/canal-image.png"),
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: Text(widget.canalName,
                              style: const TextStyle(
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            actions: [
              _selectMode
                  ? IconButton(
                      onPressed: _deleteMessages,
                      icon: const Icon(Icons.delete),
                    )
                  : Container(),
              _selectMode && _selectedMessages.length == 1
                  ? IconButton(
                      onPressed: _editMessage,
                      icon: const Icon(Icons.edit),
                    )
                  : Container(),
              _selectMode && _selectedMessages.length == 1
                  ? IconButton(
                      onPressed: _replyMessage,
                      icon: const Icon(Icons.reply),
                    )
                  : Container()
            ],
          ),
          body: BlocBuilder<CommunicationCubit, CommunicationState>(
              buildWhen: (context, state) {
            debugPrint('wgeb....');
            return state is CommunicationLoaded;
          }, builder: (_, communicationState) {
            debugPrint('estou no Comunication');
            if (!_keyBoardIsOpen &&
                MediaQuery.of(context).viewInsets.bottom > 0) {
              _goScrollDown();
              if (scrollController.position.pixels >=
                  scrollController.position.maxScrollExtent) {
                _keyBoardIsOpen = true;
              }
            }
            if (_keyBoardIsOpen &&
                MediaQuery.of(context).viewInsets.bottom == 0) {
              _keyBoardIsOpen = false;
            }

            if (communicationState is CommunicationLoaded) {
              if (totalMessages < communicationState.messages.length) {
                _goScrollDown();
              }
              totalMessages = communicationState.messages.length;
            }

            return BlocBuilder<UserCubit, UserState>(
                builder: (context, userState) {
              debugPrint('ChatPage: Estou no userState');

              return Stack(clipBehavior: Clip.none, children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
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
                          child: mensagesChatWidget(
                              communicationState,
                              userState is CurrentUserChanged
                                  ? userState.user.isAdmin
                                  : false))),
                if (communicationState is! CommunicationLoaded)
                  const Center(
                    child: CircularProgressIndicator(),
                  ),
                userState is CurrentUserChanged &&
                        userState.user.isAdmin &&
                        communicationState is CommunicationLoaded
                    ? Positioned(
                        bottom: 10,
                        left: 10,
                        right: 10,
                        child: writeMessageWidget(communicationState))
                    : Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 45,
                          alignment: Alignment.center,
                          color: Colors.white,
                          child: const Text(
                            "Esse canal é somente leitura",
                            style: TextStyle(color: Colors.black45),
                          ),
                        ))
              ]);
            });
          }),
        ));
  }

  Widget mensagesChatWidget(CommunicationLoaded messages, bool isAdmin) {
    return ListView.builder(
      controller: scrollController,
      itemCount: messages.messages.length,
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      itemBuilder: (context, index) {
        return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onLongPress: () => _initSelectMode(
                index,
                messages.messages[index].message,
                messages.messages[index].senderName),
            onTapDown: (d) => _selectMessage(index),
            child: Container(
                padding: const EdgeInsets.only(top: 5, bottom: 5),
                color: _selectMode && _selectedMessages.contains(index)
                    ? const Color.fromARGB(50, 0, 100, 255)
                    : Colors.transparent,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(width: 10),
                    Flexible(
                      child: Container(
                        padding: messages.messages[index].recipientUID !=
                                widget.senderUID
                            ? const EdgeInsets.only(bottom: 0, right: 50)
                            : const EdgeInsets.only(bottom: 0, left: 50),
                        child: Align(
                          alignment: (messages.messages[index].recipientUID !=
                                  widget.senderUID
                              ? Alignment.topLeft
                              : Alignment.topRight),
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(
                                    color: messages.messages[index].file
                                                    ?.name !=
                                                null &&
                                            messages.messages[index].file!.name
                                                .contains(RegExp(r".gif$"))
                                        ? Colors.transparent
                                        : const Color.fromARGB(
                                            255, 207, 207, 207),
                                    spreadRadius: 0,
                                    blurRadius: 1,
                                    offset: const Offset(0, 1))
                              ],
                              borderRadius:
                                  messages.messages[index].recipientUID ==
                                          widget.senderUID
                                      ? const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                          topLeft: Radius.circular(8))
                                      : const BorderRadius.only(
                                          topRight: Radius.circular(8),
                                          topLeft: Radius.circular(8),
                                          bottomRight: Radius.circular(8)),
                              color: (messages.messages[index].recipientUID ==
                                      widget.senderUID
                                  ? messages.messages[index].file?.name !=
                                              null &&
                                          messages.messages[index].file!.name
                                              .contains(RegExp(r".gif$"))
                                      ? Colors.transparent
                                      : const Color.fromARGB(255, 244, 252, 225)
                                  : Colors.white),
                            ),
                            child: Stack(children: [
                              Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (messages.messages[index].isResponse !=
                                            null &&
                                        messages.messages[index].isResponse ==
                                            true)
                                      Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          padding: const EdgeInsets.only(
                                              right: 7,
                                              left: 7,
                                              bottom: 7,
                                              top: 7),
                                          decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5)),
                                            color: Color.fromARGB(15, 0, 0, 0),
                                          ),
                                          child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  (isAdmin
                                                      ? () {
                                                          String? name = messages
                                                              .messages[index]
                                                              .responseSenderName;

                                                          return name != null &&
                                                                  name.isNotEmpty
                                                              ? name
                                                              : 'IA Bets';
                                                        }()
                                                      : 'IA Bets'),
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.blue[900],
                                                  ),
                                                ),
                                                Text(() {
                                                  String? response = messages
                                                      .messages[index]
                                                      .responseText;

                                                  return response != null &&
                                                          response.isNotEmpty
                                                      ? response
                                                      : 'Anexo';
                                                }())
                                              ])),
                                    if (messages.messages[index].recipientUID !=
                                        widget.senderUID)
                                      Container(
                                        margin:
                                            const EdgeInsets.only(bottom: 5),
                                        child: Text(
                                          isAdmin &&
                                                  messages.messages[index]
                                                      .senderName.isNotEmpty
                                              ? messages
                                                  .messages[index].senderName
                                              : 'IA Bets',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.blue[900]),
                                        ),
                                      ),
                                    if (messages.messages[index].messsageType ==
                                            "FILE" &&
                                        messages.messages[index].file != null &&
                                        messages.messages[index].file!.url !=
                                            null &&
                                        messages.messages[index].file!.id !=
                                            null)
                                      fileMessageWidget(
                                          messages.messages[index],
                                          messages.messages[index].file!.id!),
                                    if (messages
                                        .messages[index].message.isNotEmpty)
                                      Container(
                                        constraints:
                                            const BoxConstraints(minWidth: 30),
                                        margin:
                                            const EdgeInsets.only(bottom: 20),
                                        child: _generateTextMessage(
                                            messages.messages[index].message),
                                      ),
                                  ]),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Text(
                                    DateFormat('HH:mm').format(
                                        messages.messages[index].time.toDate()),
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: (messages.messages[index]
                                                  .recipientUID ==
                                              widget.senderUID
                                          ? const Color.fromARGB(
                                              255, 136, 136, 136)
                                          : const Color.fromARGB(
                                              255, 136, 136, 136)),
                                    ),
                                  ))
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
                              borderRadius: const BorderRadius.only(
                                  bottomRight: Radius.circular(0)),
                              color: (messages.messages[index].recipientUID ==
                                      widget.senderUID
                                  ? const Color(0x00F2F2F7)
                                  : kPrimaryColor),
                            ),
                          )
                        : Container()
                  ],
                )));
      },
    );
  }

  Widget fileBox(FileLoaded file) {
    return IgnorePointer(
        ignoring: _selectMode ? true : false,
        child: GestureDetector(
            onTap: () {
              if (!_selectMode) OpenFile.open(file.file!.path, type: file.type);
            },
            child: file.type!.contains('image') && file.file != null
                ? Container(
                    width: file.type!.contains('gif') ? 160 : double.maxFinite,
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.file(file.file!)))
                : Container(
                    margin: const EdgeInsets.only(
                      bottom: 20,
                    ),
                    padding: const EdgeInsets.all(10),
                    decoration: const BoxDecoration(
                        color: Color.fromARGB(15, 0, 0, 0),
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            file.type!.contains('video')
                                ? Icons.video_file
                                : file.type!.contains('pdf')
                                    ? Icons.insert_drive_file
                                    : Icons.insert_drive_file,
                            size: 50,
                          ),
                          Flexible(
                              child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, right: 10),
                                  child: Text(
                                    file.name == null || file.name!.isEmpty
                                        ? ('Arquivo do tipo ${file.type!.toString().toUpperCase()}')
                                        : file.name!,
                                    //overflow: TextOverflow.ellipsis
                                  )))
                        ]))));
  }

  Widget fileMessageWidget(TextMessageEntity message, String id) {
    return cachedFiles.keys.contains(id) && cachedFiles[id]!.loaded
        ? fileBox(cachedFiles[id]!)
        : FutureBuilder(
            future: getLocalFileOrDownload(message.file!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                File file = snapshot.data as File;
                cachedFiles[id] = FileLoaded(
                    file: file,
                    loaded: true,
                    type: message.file!.mime,
                    name: message.file!.name);
                return fileBox(cachedFiles[id]!);
              } else {
                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      SpinKitCircle(
                          color: Color.fromARGB(255, 19, 2, 46), size: 40),
                      Flexible(
                        child: Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: Text('Carregando arquivo...',
                              overflow: TextOverflow.ellipsis),
                        ),
                      )
                    ],
                  ),
                );
              }
            },
          );
  }

  Widget writeMessageWidget(CommunicationLoaded messages) {
    return SizedBox(
      width: MediaQuery.of(context).size.width - 20,
      child: Material(
        elevation: 1.5,
        shadowColor: const Color.fromARGB(100, 241, 241, 241),
        borderRadius: BorderRadius.circular(25),
        color: Colors.white,
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          if (_isReply || _isFile)
            Stack(children: [
              Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(15),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Color.fromARGB(15, 0, 0, 0),
                ),
                child: _isReply
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Row(children: [
                              Expanded(
                                  child: Padding(
                                      padding: const EdgeInsets.only(bottom: 5),
                                      child: Text(
                                        (replySender.isNotEmpty
                                            ? replySender
                                            : 'Responder'),
                                        style: TextStyle(
                                            color: Colors.blue[900],
                                            fontWeight: FontWeight.bold),
                                      )))
                            ]),
                            Text(_replayFormatText(replyText))
                          ])
                    : Row(children: [
                        Container(
                            height: 50,
                            alignment: Alignment.topLeft,
                            child: Align(
                                alignment: Alignment.topLeft,
                                child: Container(
                                  width: 50,
                                  decoration: BoxDecoration(
                                    color: Colors.black12,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: Image.memory(
                                        _file.bytes != null
                                            ? _file.bytes!
                                            : Uint8List.fromList(List.empty()),
                                      ).image,
                                    ),
                                  ),
                                ))),
                        Flexible(
                            child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Text(_file.name,
                                    overflow: TextOverflow.ellipsis)))
                      ]),
              ),
              Positioned(
                  right: 0,
                  top: 18,
                  child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: _cancelReply,
                      child: Container(
                          width: 70,
                          alignment: Alignment.topRight,
                          padding: const EdgeInsets.only(right: 20),
                          child: Icon(Icons.close,
                              size: 17,
                              color: _isSendingFile
                                  ? Colors.black12
                                  : Colors.black)))),
              if (_isSendingFile)
                const Positioned.fill(
                    top: 0,
                    child: Align(
                        alignment: Alignment.centerRight,
                        child: SpinKitCircle(size: 50, color: Colors.black)))
            ]),
          TextField(
            enabled: _isSendingFile ? false : true,
            controller: _textMessageController,
            focusNode: myFocusNode,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            style: TextStyle(
                color: _isSendingFile ? Colors.black12 : Colors.black),
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
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white),
                borderRadius: BorderRadius.circular(25),
              ),
              prefixIcon: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sentiment_satisfied_alt),
                color: _isSendingFile ? Colors.black12 : Colors.black,
              ),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min, // added line
                children: [
                  IconButton(
                    onPressed: () {
                      _sendFile();
                    },
                    icon: const Icon(Icons.attach_file),
                    color: _isSendingFile ? Colors.black12 : Colors.black,
                  ),
                  IconButton(
                    onPressed: () {
                      _sendMessage();
                    },
                    icon: const Icon(Icons.send),
                    color: _isSendingFile ? Colors.black12 : Colors.black,
                  )
                ],
              ),
            ),
          )
        ]),
      ),
    );
  }

/*
  void _scrollDown([int duration = 1]) {
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: Duration(seconds: duration),
      curve: Curves.fastOutSlowIn,
    );
  }
*/
  void _selectMessage(int index) {
    if (_selectMode) {
      setState(() {
        if (!_selectedMessages.contains(index)) {
          _selectedMessages.add(index);
        } else {
          _selectedMessages.remove(index);
          if (_selectedMessages.isEmpty) _selectMode = false;
        }
      });
    }
  }

  void _initSelectMode(int index, String message, String senderName) {
    if (!BlocProvider.of<UserCubit>(context).currentUserIsAdmin()) return;
    setState(() {
      replyText = message;
      replySender = senderName;
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
                    ? "https://$linkText"
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

  Future<void> launchURL(String url) async {
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }

  void _deleteMessages() async {
    BlocProvider.of<CommunicationCubit>(context)
        .deleteMessages(
            channelId: widget.canalName, messages: _selectedMessages)
        .then((res) => _endSelectedMode())
        .catchError((e) => {});
  }

  String _replayFormatText(String text) {
    List<String> results = text.split('\n');

    String finalString = '';

    if (results.length > 3) {
      finalString += "${results[0]}\n${results[1]}\n${results[2]}...";
    } else {
      finalString = text.length > 90 ? '${text.substring(1, 90)}...' : text;
    }

    return finalString;
  }

  void _sendMessage() {
    if (_textMessageController.text.isNotEmpty || _isFile) {
      setState(() {
        _isSendingFile = true;
      });

      BlocProvider.of<CommunicationCubit>(context)
          .sendTextMessage(
              senderId: widget.senderUID,
              senderName: widget.userInfo.name,
              message: _textMessageController.text,
              canalName: widget.canalName,
              type: _isFile ? 'FILE' : 'TEXT',
              file: _isFile ? _file : null,
              isResponse: _isReply,
              responseText: _isReply ? _replayFormatText(replyText) : '',
              responseSenderName: _isReply ? replySender : '',
              element: widget.userInfo)
          .whenComplete(() => BlocProvider.of<MyChatCubit>(context)
              .sendPushMessage(
                  channelId: widget.canalName,
                  title: widget.canalName,
                  message: _textMessageController.text));
      //_messaging.subscribeToTopic();

      _textMessageController.clear();
      setState(() {
        _isSendingFile = false;
      });
      _cancelReply();
      Timer(const Duration(milliseconds: 500), () {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      });
    }
  }

  void _goScrollDown() {
    Timer.periodic(const Duration(milliseconds: 1), (timer) async {
      if (scrollController.hasClients) {
        debugPrint("vamos ver 2");
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
        timer.cancel();

        await Future.delayed(const Duration(milliseconds: 200), () {
          if (scrollController.position.maxScrollExtent !=
              scrollController.position.pixels) _goScrollDown();
        });
      }
    });
  }

  void _cancelReply() {
    setState(() {
      _isReply = false;
      _isFile = false;
      replySender = '';
      replyText = '';
    });
  }

  void _replyMessage() {
    _endSelectedMode();
    setState(() {
      _isReply = true;
    });

    myFocusNode.unfocus();
    Timer(const Duration(milliseconds: 100), () {
      myFocusNode.requestFocus();
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
          title: const Text("Editar mensagem:"),
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
              child: const Text('Cancelar'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                primary: Colors.blue,
              ),
              onPressed: () => BlocProvider.of<CommunicationCubit>(context)
                  .editMessage(
                      channelId: widget.canalName,
                      messageIndex: _selectedMessages[0],
                      messageText: _editMessageTextController.text)
                  .whenComplete(() {
                Navigator.pop(context);
                _endSelectedMode();
              }),
              child: const Text('Salvar'),
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

  void _sendFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'pdf',
        'doc',
        'avi',
        'mp4',
        'mov',
        'xls',
        'xlsx',
        'docx',
        'gif'
      ],
    );
    if (result != null) {
      final name = result.files.first.name;
      var file = result.files.first.bytes;

      setState(() {
        _file = FileEntity(
            bytes: file ?? Uint8List.fromList(List.empty()),
            name: name,
            mime: '');
        _isFile = true;
      });

      /*BlocProvider.of<CommunicationCubit>(context).sendFile(
          canalName: widget.canalName,
          file: file!,
          name: '$name.$extension',
          senderId: widget.senderUID,
          type: 'FILE',
          element: widget.userInfo);*/
    }
  }

  /*_getFromGallery() async {
    PickedFile pickedFile = await ImagePicker().getImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
    );
    if (pickedFile != null) {
        File imageFile = File(pickedFile.path);
    }
  }

  Future<String> _getUrl(canal, name) {
    return BlocProvider.of<CommunicationCubit>(context)
        .getUrl(canalName: canal, name: name);
  }*/
}

Future<String> getFilePath({required String fileName}) async {
  Directory appDocumentsDirectory =
      await getApplicationDocumentsDirectory(); // 1
  String appDocumentsPath = appDocumentsDirectory.path; // 2
  String filePath = '$appDocumentsPath/$fileName'; // 3
  return filePath;
}

Future<File> downloadFile(String url, File file) async {
  HttpClient httpClient = HttpClient();

  try {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    if (response.statusCode == 200) {
      var bytes = await consolidateHttpClientResponseBytes(response);
      file = await file.writeAsBytes(bytes);
    }
  } catch (ex) {
    debugPrint(ex.toString());
  }

  return file;
}

Future<File> getLocalFileOrDownload(FileEntity fileEntity) async {
  RegExp exp = RegExp(r"\.\w+$");
  String? extension = exp.stringMatch(fileEntity.name);

  File file = File(await getFilePath(
      fileName: fileEntity.id!.toString() + extension.toString())); // 1
  bool fileExists = await file.exists();

  //await Future.delayed(Duration(seconds: 5), () {});

  if (!fileExists) file = await downloadFile(fileEntity.url!, file);

  return file;
}
