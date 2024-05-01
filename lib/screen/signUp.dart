import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat/bloc/chat_bloc.dart';
import 'package:group_chat/screen/homepage.dart';
import 'package:group_chat/screen/login.dart';
import 'package:group_chat/widgets/button.dart';
import 'package:group_chat/widgets/wTextFiled.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatelessWidget {
  TextEditingController userCtrl = TextEditingController();

  TextEditingController emailCtrl = TextEditingController();

  TextEditingController passCtrl = TextEditingController();

  // FirebaseFirestore fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign up"),
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
                  textEditingController: userCtrl,
                  label: "Username",
                  textInputType: TextInputType.name),
              SizedBox(
                height: 30,
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
                  listener: (context, state) {
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
                  // if (state is res){

                  // }

                  child: CustomButton(
                    backgroundColor: Theme.of(context).colorScheme.background,
                    text: "Sign Up",
                    onPressed: () {
                      BlocProvider.of<ChatBloc>(context).add(SignUpEvent(
                          username: userCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          password: passCtrl.text.trim()));
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
                  text: "Have an account",
                  onPressed: () {
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
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
