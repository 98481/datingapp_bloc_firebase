
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internshipapp/allui/constants.dart';
import 'package:internshipapp/allui/widgets/sigupForm.dart';
import 'package:internshipapp/bloc/signup/bloc.dart';
import 'package:internshipapp/repositories/userRepository.dart';

class SignUp extends StatelessWidget {
  final UserRepository _userRepository;

  SignUp({@required UserRepository userRepository})
      : assert(userRepository != null),
        _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Sign Up",
          style: TextStyle(fontSize: 36.0),
        ),
        centerTitle: true,
        backgroundColor: backgroundColor,
        elevation: 0,
      ),
      body: BlocProvider<SignUpBloc>(
        create: (context) => SignUpBloc(
          userRepository: _userRepository,
        ),
        child: SignUpForm(
          userRepository: _userRepository,
        ),
      ),
    );
  }
}