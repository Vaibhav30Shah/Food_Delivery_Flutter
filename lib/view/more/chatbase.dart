import 'package:flutter/material.dart';
import 'dart:math';

class MyWebView extends StatefulWidget {
  @override
  _MyWebViewState createState() => _MyWebViewState();
}

class _MyWebViewState extends State<MyWebView> {
  List<Map<String, String>> messages = [];
  TextEditingController textEditingController = TextEditingController();

  void handleSendMessage() {
    String inputValue = textEditingController.text.trim();
    if (inputValue.isNotEmpty) {
      setState(() {
        messages.add({'type': 'user', 'content': inputValue});
        messages.add({'type': 'bot', 'content': getBotReply(inputValue)});
        textEditingController.clear(); // Clear the text field after sending message
      });
    }
  }

  String getBotReply(String input) {
    final List<String> replies = [
      "That's interesting!",
      "Tell me more.",
      "I'm not sure I understand.",
      "Could you elaborate?",
      "Interesting point.",
      "I see.",
      "Fascinating!"
    ];

    final randomIndex = Random().nextInt(replies.length);
    return replies[randomIndex];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.withOpacity(0.5),
        title: Text('Chatbot'),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[index];
                  final isUserMessage = message['type'] == 'user';
                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: EdgeInsets.symmetric(vertical: 4.0),
                      padding: EdgeInsets.all(12.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.purple.withOpacity(0.5) : Colors.grey[200],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          topRight: Radius.circular(16.0),
                          bottomLeft: isUserMessage ? Radius.circular(16.0) : Radius.circular(0.0),
                          bottomRight: isUserMessage ? Radius.circular(0.0) : Radius.circular(16.0),
                        ),
                      ),
                      child: Text(
                        message['content'] ?? '',
                        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textEditingController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith((states) => Colors.purple.withOpacity(0.5))
                  ),
                  onPressed: handleSendMessage,
                  child: Text('Send'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
