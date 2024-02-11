import 'dart:convert';

import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class chat_page extends StatefulWidget {
  const chat_page({super.key});

  @override
  State<chat_page> createState() => _chat_pageState();
}

class _chat_pageState extends State<chat_page> {

  //declare 2 user
  ChatUser myself =ChatUser(id: 1.toString() , firstName: "Me");
  ChatUser bot = ChatUser(id: 2.toString() , firstName: "Google");

  //messege list
  List<ChatMessage> messeges = [];


  //api url link with end point
  String url = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=AIzaSyDEsJIdQWuYOHb5p82jgbCEJijdFfBLIHk';

  //api header
  var header =
  {
    'Content-Type': 'application/json',
  };


  //method to get response of user messge
  Future<void> get_response(ChatMessage m) async
  {
     messeges.insert(0, m);
     setState(() {});

     var data = {"contents":[{"parts":[{"text":m.text}]}]};

     await http.post(
       Uri.parse(url),
       headers: header,
       body: jsonEncode(data),
     ).then((value){
       if(value.statusCode == 200)
       {
           //json response
           var response_data = jsonDecode(value.body);

           //filter our response ans from full jason
           var response_messege = response_data["candidates"][0]["content"]["parts"][0]["text"];


             //create chatmessege obj for our response
             ChatMessage bot_messege = ChatMessage(
                 user: bot,
                 text: response_messege != null ? response_messege : "I don't have information of your question...",
                 createdAt: DateTime.now(),
             );

             //add chatmesseges response to messege list
             messeges.insert(0, bot_messege);

       }
       else
       {
         print("Error");
       }
     }).catchError((e){ print(e); });

     setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("AI Chat Bot"),
      ),

      body: DashChat(
        currentUser:  myself,
        messages: messeges,
        onSend: (message) {
          get_response(message);
        },
        inputOptions: InputOptions(
          alwaysShowSend: true,
        ),
      ),
    );
  }
}
