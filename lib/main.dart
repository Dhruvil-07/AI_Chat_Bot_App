import 'package:chat_bot/chat_page.dart';
import 'package:flutter/material.dart';

void main()
{
  runApp(my_chat_bot());
}

class my_chat_bot extends StatelessWidget {
  const my_chat_bot({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Chat Bot",
      home: chat_page(),
      debugShowCheckedModeBanner: false,
    );
  }
}
