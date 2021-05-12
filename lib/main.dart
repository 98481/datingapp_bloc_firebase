import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:internshipapp/allui/pages/home.dart';
import 'package:internshipapp/bloc/authentication/authentication_bloc.dart';
import 'package:internshipapp/bloc/authentication/authentication_event.dart';
import 'package:internshipapp/bloc/blocDelegate.dart';
import 'package:internshipapp/repositories/userRepository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
//import 'package:shared_preferences/shared_preferences.dart';
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  //final SharedPreferences prefs = await SharedPreferences.getInstance();
 //var isLoggedIn = (prefs.getBool('isLoggedIn') == null) ? false : prefs.getBool('isLoggedIn');
  final UserRepository _userRepository = UserRepository();

  Bloc.observer = SimpleBlocDelegate();

  runApp(BlocProvider<AuthenticationBloc>(
      create: (context) => AuthenticationBloc(userRepository: _userRepository)
        ..add(AppStarted()),
      child: Home(userRepository: _userRepository)));
 // runApp(MaterialApp(debugShowCheckedModeBanner: false, home: MyApp(),));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(),
      home:Container(),
    );
  }
}

