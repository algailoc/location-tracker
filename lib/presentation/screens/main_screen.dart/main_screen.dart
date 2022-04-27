import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/screens/loading_screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  void logOut(BuildContext context) {
    BlocProvider.of<AuthorizationBloc>(context).add(SignOutUser());
  }

  void authorizationBlocListener(
      BuildContext context, AuthorizationState state) {
    print(state);
    if (state is AuthorizationInitial) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoadingScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthorizationBloc, AuthorizationState>(
        listener: authorizationBlocListener,
        child: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Это главная станица приложения'),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () => logOut(context),
                    child: const Text('Выйти из аккаунта'))
              ],
            )),
      ),
    );
  }
}
