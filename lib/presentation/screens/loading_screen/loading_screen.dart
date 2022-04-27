import 'dart:async';

import 'package:firebase_tracker/presentation/screens/authorization_screen/authorization_screen.dart';
import 'package:firebase_tracker/presentation/screens/main_screen.dart/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/authorization_bloc/authorization_bloc.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<AuthorizationBloc>(context).add(CheckLocalUser());
  }

  void authorizationBlocListener(
      BuildContext context, AuthorizationState state) {
    if (state is UserAuthorized) {
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainScreen()));
      });
    } else if (state is LocalUserChecked) {
      if (!state.localUserFound) {
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => const AuthorizationScreen()));
        });
      } else if (state.localUserFound) {
        Timer(const Duration(seconds: 3), () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const MainScreen()));
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthorizationBloc, AuthorizationState>(
        listener: authorizationBlocListener,
        child: Container(
          alignment: Alignment.center,
          child: const CircularProgressIndicator.adaptive(),
        ),
      ),
    );
  }
}
