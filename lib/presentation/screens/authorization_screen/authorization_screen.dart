import 'package:firebase_tracker/core/utils/show_custom_snackbar.dart';
import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/screens/main_screen.dart/main_screen.dart';
import 'package:firebase_tracker/presentation/widgets/general/custom_app_bar.dart';
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
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const MainScreen()));
      BlocProvider.of<UsersBloc>(context).add(GetUserData());
    }
    if (state is AuthorizationError) {
      showCustomSnackBar(context, state.error, type: SnackBarType.error);
    }
    if (state is AuthorizationInitial) {}
  }

  bool isButtonDisabled() {
    return emailController.text.isEmpty || passwordController.text.isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: const CustomAppBar(title: 'Tracker App'),
        body: BlocListener<AuthorizationBloc, AuthorizationState>(
          listener: authorizationBlocListener,
          child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: BlocBuilder<AuthorizationBloc, AuthorizationState>(
                  builder: (context, state) {
                if (state is AuthorizationPending) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  children: [
                    TextField(
                      controller: emailController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(helperText: 'Почта'),
                    ),
                    TextField(
                      controller: passwordController,
                      onChanged: (_) => setState(() {}),
                      decoration: const InputDecoration(helperText: 'Пароль'),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: isButtonDisabled() ? null : signUp,
                      child: const Text('Зарегистрироваться'),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                            isButtonDisabled()
                                ? Colors.grey
                                : Theme.of(context).colorScheme.primary),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: isButtonDisabled() ? null : signIn,
                      child: const Text('Войти'),
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                        isButtonDisabled()
                            ? Colors.grey
                            : Theme.of(context).colorScheme.primary,
                      )),
                    )
                  ],
                );
              })),
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
