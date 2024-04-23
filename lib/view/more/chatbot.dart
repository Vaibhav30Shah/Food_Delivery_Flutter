import 'package:flutter/material.dart';

class ChatbotScreen extends StatefulWidget {
  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  List<Map<String, dynamic>> messages = [];
  TextEditingController inputController = TextEditingController();

  void handleSendMessage(String question) {
    String botReply = getBotReply(question);
    Map<String, dynamic> newUserMessage = {'type': 'user', 'content': question};
    Map<String, dynamic> newBotMessage = {'type': 'bot', 'content': botReply};
    setState(() {
      messages.add(newUserMessage);
      messages.add(newBotMessage);
    });
  }

  String getBotReply(String input) {
    if (input.toLowerCase().contains("popular food delivery services")) {
      return "Delivery times can vary depending on the restaurant and the time of day, but it typically takes around 30 to 45 minutes.";
    } else if (input.toLowerCase().contains("delivery time")) {
      return "Delivery times can vary depending on the restaurant and the time of day, but it typically takes around 30 to 45 minutes.";
    } else if (input.toLowerCase().contains("safety measures")) {
      return "We have implemented various safety measures such as contactless delivery and regular sanitization to ensure safe delivery.";
    } else if (input.toLowerCase().contains("payment methods")) {
      return "We usually accept various payment methods including credit/debit cards, online payment platforms, and sometimes cash on delivery.";
    } else if (input.toLowerCase().contains("delivery charges")) {
      return "Delivery charges may vary depending on the distance from the restaurant to your location.";
    } else if (input.toLowerCase().contains("order cancellation")) {
      return "You can cancel your order within a certain time frame after placing it. Policies may vary, so it's best to check with the specific service.";
    } else if (input.toLowerCase().contains("customer support")) {
      return "Please call our customer care number at 9737928685.";
    } else {
      return "I'm not sure I understand. Could you please ask another question?";
    }
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
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (context, index) {
                  final message = messages[messages.length - 1 - index];
                  final isUserMessage = message['type'] == 'user';
                  return Align(
                    alignment: isUserMessage ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                      margin: EdgeInsets.only(bottom: 8.0),
                      decoration: BoxDecoration(
                        color: isUserMessage ? Colors.purple.withOpacity(0.5) : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12.0),
                          topRight: Radius.circular(12.0),
                          bottomLeft: isUserMessage ? Radius.circular(12.0) : Radius.circular(0.0),
                          bottomRight: isUserMessage ? Radius.circular(0.0) : Radius.circular(12.0),
                        ),
                      ),
                      child: Text(
                        message['content'],
                        style: TextStyle(color: isUserMessage ? Colors.white : Colors.black),
                      ),
                    ),
                  );
                },
              ),
            ),
            TextField(
              controller: inputController,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                suffixIcon: IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (inputController.text.trim().isNotEmpty) {
                      handleSendMessage(inputController.text);
                      inputController.clear();
                    }
                  }
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
