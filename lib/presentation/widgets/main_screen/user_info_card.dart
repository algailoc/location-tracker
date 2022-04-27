import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UserInfoCard extends StatelessWidget {
  const UserInfoCard({Key? key}) : super(key: key);

  void openMap(BuildContext context, double lat, double long) {}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: BlocBuilder<UsersBloc, UsersState>(builder: (context, state) {
        if (state.user == null) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return Card(
            elevation: 10,
            child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          state.user!.email,
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Ваши координаты: ${state.user!.lat}  ${state.user!.long}',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: () =>
                          openMap(context, state.user!.lat, state.user!.long),
                      icon: const Icon(Icons.map),
                      tooltip: 'Открыть карту',
                    ),
                  ],
                )),
          );
        }
      }),
    );
  }
}
