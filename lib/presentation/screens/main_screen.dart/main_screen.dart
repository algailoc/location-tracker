import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/screens/loading_screen/loading_screen.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/friends_list.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../widgets/general/custom_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    super.initState();
    if (BlocProvider.of<UsersBloc>(context).state.user == null) {
      BlocProvider.of<UsersBloc>(context).add(GetUserData());
    }
  }

  void logOut(BuildContext context) {
    BlocProvider.of<AuthorizationBloc>(context).add(SignOutUser());
  }

  void authorizationBlocListener(
      BuildContext context, AuthorizationState state) {
    if (state is AuthorizationInitial) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoadingScreen()));
    }
  }

  void usersBlocListener(BuildContext context, UsersState state) {
    if (state is UsersLoadedState && state.users!.isEmpty) {
      BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
    }
  }

  void goToAddUserPage(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UsersBloc, UsersState>(
          listener: usersBlocListener,
        ),
        BlocListener<AuthorizationBloc, AuthorizationState>(
          listener: authorizationBlocListener,
        ),
      ],
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Tracker App'),
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Column(
            children: const [
              UserInfoCard(),
              FriendsList(),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => goToAddUserPage(context),
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}
