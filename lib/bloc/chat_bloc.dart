import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatState()) {
    on<SignUpEvent>(_signUpEvent);
    on<LoginEvent>(_loginEvent);
    on<SharedPrefEvent>(_sharedPreff);
    on<LogoutEvent>(_logout);
  }

  void _signUpEvent(SignUpEvent event, Emitter<ChatState> emit) async {
    String user = event.username;
    String mail = event.email;
    String pass = event.password;
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore store = FirebaseFirestore.instance;
    SharedPreferences sp = await SharedPreferences.getInstance();

    if (mail.isNotEmpty && pass.isNotEmpty && user.isNotEmpty) {
      try {
        UserCredential cred = await auth.createUserWithEmailAndPassword(
            email: mail, password: pass);
        await store.collection("users").doc(cred.user!.uid).set({
          'username': user,
          'Email': mail,
          'Password': pass,
          'uid': cred.user!.uid,
          'groups': [],
        });
        emit(state.copyWith(res: "success"));
        sp.setBool("login", true);
        sp.setString("userName", user);
        sp.setString("email", mail);
        // sp.getBool("login");

        log(" ${event.username}  account Successfully created");

        // });

        // await store.collection('user')
      } on FirebaseAuthException catch (e) {
        emit(state.copyWith(res: "Error : ${e.toString()} "));
      }
    } else {
      emit(state.copyWith(res: "Fields Can not be Empty "));
    }
  }

  void _loginEvent(LoginEvent event, Emitter<ChatState> emit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    String mail = event.email;
    String pass = event.password;
    if (mail.isNotEmpty && pass.isNotEmpty) {
      try {
        log("HI i am running log in login bloc");
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: mail, password: pass)
            .then((value) {
          sp.setBool("login", true);
          emit(state.copyWith(res: "success"));
          log("Successfully created");
        });
      } on FirebaseAuthException catch (e) {
        log(" Not Successfully created");
        emit(state.copyWith(res: "Error : ${e.toString()} "));
      }
    } else {
      emit(state.copyWith(res: "Fields Can not be Empty "));
    }
  }

  _sharedPreff(SharedPrefEvent event, Emitter<ChatState> emit) {
    emit(state.copyWith(isLogin: event.isLogin));
  }

  void _logout(LogoutEvent event, Emitter<ChatState> emit) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    try {
      sp.setBool("login", false);
      sp.remove("userName");
      sp.remove("email");

      FirebaseAuth.instance.signOut();
      emit(state.copyWith(res: "logout"));
    } on FirebaseAuthException catch (e) {
      emit(state.copyWith(res: "Error $e"));
    }
  }
}
