import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_tracker/dependencies_injection.dart' as di;

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void _getFirebaseData(BuildContext context) async {
    // BlocProvider.of<UsersBloc>(context).add(event)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker App'),
      ),
      body: Container(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _getFirebaseData(context),
        tooltip: 'TEST',
        child: const Text('TEST'),
      ),
    );
  }
}
