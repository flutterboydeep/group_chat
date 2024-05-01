// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'chat_bloc.dart';

@immutable
class ChatState {
  final String res;
  final bool isLogin;

  ChatState(
      {this.res = 'Wellcome in Chat group application', this.isLogin = false});

  ChatState copyWith({String? res, bool? isLogin}) {
    return ChatState(
      res: res ?? this.res,
      isLogin: isLogin ?? this.isLogin,
    );
  }

  // @override
  // List<Object?> get props => [res];
}
