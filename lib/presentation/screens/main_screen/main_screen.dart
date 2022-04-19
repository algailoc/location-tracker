import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  void _getFirebaseData(BuildContext context) async {
    BlocProvider.of<UsersBloc>(context).add(AddFriend('2'));
  }

  @override
  void initState() {
    BlocProvider.of<UsersBloc>(context).add(GetUserData());
    if (BlocProvider.of<UsersBloc>(context).users.isEmpty) {
      BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
    }
    super.initState();
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
