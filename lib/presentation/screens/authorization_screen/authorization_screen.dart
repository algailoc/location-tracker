import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/screens/main_screen.dart/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthorizationScreen extends StatefulWidget {
  const AuthorizationScreen({Key? key}) : super(key: key);

  @override
  State<AuthorizationScreen> createState() => _AuthorizationScreenState();
}

class _AuthorizationScreenState extends State<AuthorizationScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  void signUp() {
    BlocProvider.of<AuthorizationBloc>(context)
        .add(SignUpUser(emailController.text, passwordController.text));
  }

  void signIn() {
    BlocProvider.of<AuthorizationBloc>(context)
        .add(SignInUser(emailController.text, passwordController.text));
  }

  void authorizationBlocListener(
      BuildContext context, AuthorizationState state) {
    if (state is UserAuthorized) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MainScreen()));
    }
    if (state is AuthorizationError) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(state.error)));
    }
    if (state is AuthorizationInitial) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Разлогинено')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker App'),
      ),
      body: BlocListener<AuthorizationBloc, AuthorizationState>(
        listener: authorizationBlocListener,
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(helperText: 'Почта'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(helperText: 'Пароль'),
              ),
              const Spacer(),
              TextButton(
                  onPressed: signUp, child: const Text('Зарегистрироваться')),
              TextButton(onPressed: signIn, child: const Text('Войти'))
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
