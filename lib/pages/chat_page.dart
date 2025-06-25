import 'package:chat/models/messages_response.dart';
import 'package:chat/services/auth_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import 'package:chat/services/chat_service.dart';
import 'package:chat/services/socket_service.dart';
import 'package:chat/widgets/widgets.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  List<ChatMessage> _messages = [];

  bool _isTyping = false;

  @override
  void initState() {
    super.initState();
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('personal-message', _listenMessage);

    _loadHistory(chatService.userTo.uid);
  }

  void _loadHistory(String userID) async {
    List<Message> chat = await chatService.getChat(userID);
    final history = chat.map(
      (m) => ChatMessage(
        text: m.message,
        uid: m.from,
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 0))
          ..forward(),
      ),
    );
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _listenMessage(dynamic payload) {
    // print('Tengo mensaje$payload!');
    ChatMessage message = ChatMessage(
        text: payload['message'],
        uid: payload['from'],
        animationController: AnimationController(
            vsync: this, duration: Duration(milliseconds: 300)));
    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    final userFor = chatService.userTo;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 2,
        title: Column(
          children: [
            CircleAvatar(
              backgroundColor: Colors.blueAccent[100],
              maxRadius: 17,
              child: Text(
                userFor.name.substring(0, 2),
                style: TextStyle(fontSize: 11),
              ),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              userFor.name,
              style: TextStyle(color: Colors.black87, fontSize: 12),
            )
          ],
        ),
      ),
      body: Container(
        child: Column(
          children: [
            Flexible(
                child: ListView.builder(
              physics: BouncingScrollPhysics(),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _messages[index];
              },
              reverse: true,
            )),
            Divider(
              height: 1,
            ),
            //TODO: BOX test
            Container(
              color: Colors.white,
              // height: 100,
              child: _inputChat(),
            )
          ],
        ),
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
        child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Flexible(
            child: TextField(
              controller: _textController,
              onSubmitted: _handleSubmit,
              onChanged: (text) {
                //TODO: Cuando hay un valor para poder postear
                setState(() {
                  if (text.trim().isNotEmpty) {
                    _isTyping = true;
                  } else {
                    _isTyping = false;
                  }
                });
              },
              decoration: InputDecoration.collapsed(hintText: 'Send message'),
              focusNode: _focusNode,
            ),
          ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _isTyping
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: Text('Send'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            onPressed: _isTyping
                                ? () =>
                                    _handleSubmit(_textController.text.trim())
                                : null,
                            icon: Icon(Icons.send)),
                      ),
                    ))
        ],
      ),
    ));
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;
    _textController.clear();
    _focusNode.requestFocus();

    final newMessage = ChatMessage(
      text: text,
      uid: authService.user!.uid,
      animationController: AnimationController(
          vsync: this, duration: Duration(milliseconds: 400)),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isTyping = false;
    });
    socketService.emit('personal-message', {
      'from': authService.user?.uid,
      'to': chatService.userTo.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket.off('personal-message');
    super.dispose();
  }
}
