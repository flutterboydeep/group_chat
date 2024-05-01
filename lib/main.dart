import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat/bloc/chat_bloc.dart';
import 'package:group_chat/screen/homepage.dart';
import 'package:group_chat/screen/login.dart';
import 'package:group_chat/screen/signUp.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyArpR9TJeuCYunr6zPddA1rLIVwt1iVap0",
            appId: "1:428387108052:web:20609b5a3f4e63ad3ba741",
            messagingSenderId: "428387108052",
            projectId: "chat-5673b",
            storageBucket: "chat-5673b.appspot.com"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});
  // final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  showScreen(context) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    bool? isAuth = sp.getBool("login");
    BlocProvider.of<ChatBloc>(context)
        .add(SharedPrefEvent(isLogin: isAuth ?? false));
  }

  @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //       future: _initialization,
  //       builder: (context, snapshot) {
  //         if (snapshot.hasError) {
  //           print("Somethings is Error");
  //         }
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           print("i am in Waiting");
  //           return Center(
  //             child: CupertinoActivityIndicator(
  //               radius: 20,
  //               color: Colors.white,
  //             ),
  //           );
  //         }

  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => ChatBloc()),
      ],
      child: MaterialApp(
        title: 'Chat app',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
              seedColor: Color.fromARGB(255, 0, 0, 0),
              primary: Color.fromARGB(255, 207, 191, 234),
              background: Color.fromARGB(255, 221, 187, 251)),
          scaffoldBackgroundColor: Color.fromARGB(255, 255, 255, 255),
          useMaterial3: true,
        ),
        home: BlocBuilder<ChatBloc, ChatState>(
          buildWhen: (previous, current) => previous.isLogin != current.isLogin,
          builder: (context, state) {
            showScreen(context);
            if (state.isLogin == true && state.isLogin != null) {
              return Homepage();
            } else {
              return SignUp();
            }
          },
        ),

        //  FirebaseAuth.instance.currentUser != null
        //     ? Homepage()
        //     : LoginPage(),
      ),
    );
  }
}
