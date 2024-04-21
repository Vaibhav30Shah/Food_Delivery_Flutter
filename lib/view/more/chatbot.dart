import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final List<String> _messages = [];
  final TextEditingController _textController = TextEditingController();

  void _sendMessage(String message) {
    setState(() {
      _messages.add(message);
      _messages.add(_getChatbotResponse(message));
    });
    _textController.clear();
  }

  String _getChatbotResponse(String message) {
    // Implement your chatbot logic here
    if (message.contains('order')) {
      return 'Sure, what would you like to order?';
    } else if (message.contains('menu')) {
      return 'Here is our menu: \n1. Pizza \n2. Burger \n3. Salad';
    } else {
      return 'I\'m sorry, I didn\'t understand your request. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Food Delivery Chatbot'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(_messages[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText: 'Type your message...',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_textController.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
