import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat/bloc/chat_bloc.dart';
import 'package:group_chat/screen/homepage.dart';
import 'package:group_chat/screen/signUp.dart';
import 'package:group_chat/widgets/button.dart';
import 'package:group_chat/widgets/wTextFiled.dart';

class LoginPage extends StatelessWidget {
  // TextEditingController userNameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passCtrl = TextEditingController();

  // FirebaseFirestore fireStore = FirebaseFirestore.instance;
  // String res = "Some Error Occured";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 35),
        // height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Center(
          child: Column(
            children: [
              Flexible(
                child: Container(),
                flex: 1,
              ),
              TextFieldWidget(
                  filled: false,
                  maxnum: 50,
                  textEditingController: emailCtrl,
                  label: "Email",
                  textInputType: TextInputType.name),
              SizedBox(
                height: 30,
              ),
              TextFieldWidget(
                  filled: false,
                  // readOnly: true,
                  // TextFieldEnable: false,
                  maxnum: 16,
                  textEditingController: passCtrl,
                  label: "Password",
                  // hintText: verifidInfo,
                  textInputType: TextInputType.text),
              SizedBox(
                height: 40,
              ),
              SizedBox(
                width: double.infinity,
                child: BlocListener<ChatBloc, ChatState>(
                  listenWhen: (previous, current) =>
                      previous.res != current.res,
                  listener: (context, state) {
                    //      BlocListener<ChatBloc, ChatState>(
                    if (state.res == "success") {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(state.res.toString()),
                        backgroundColor: Colors.green,
                      ));
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) => Homepage()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(state.res.toString())));
                    }
                  },
                  child: CustomButton(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    text: "Login",
                    onPressed: () {
                      context.read<ChatBloc>().add(LoginEvent(
                          password: passCtrl.text.trim(),
                          email: emailCtrl.text.trim()));
                    },
                  ),
                ),
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  backgroundColor: Colors.transparent,
                  text: "Don't have an account",
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
