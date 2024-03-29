import 'dart:async';

import 'package:firebase_tracker/core/utils/show_custom_snackbar.dart';
import 'package:firebase_tracker/presentation/bloc/authorization_bloc/authorization_bloc.dart';
import 'package:firebase_tracker/presentation/bloc/users_bloc/users_bloc.dart';
import 'package:firebase_tracker/presentation/screens/all_users_list_screen/all_users_list_screen.dart';
import 'package:firebase_tracker/presentation/screens/loading_screen/loading_screen.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/approved_instructions.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/friends_list.dart';
import 'package:firebase_tracker/presentation/widgets/main_screen/user_info_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../widgets/general/custom_app_bar.dart';
import '../../widgets/main_screen/app_settings_menu.dart';
import 'package:background_location/background_location.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Timer updateUsersTimer;
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    super.initState();
    // backgroundLocationService();
    if (BlocProvider.of<UsersBloc>(context).state.user == null) {
      BlocProvider.of<UsersBloc>(context).add(GetUserData());
    }
    updateCoordinatesListener();
    updateUsersTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      if (BlocProvider.of<UsersBloc>(context).state.user != null) {
        BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
      }
    });
  }

  void backgroundLocationService() {
    BackgroundLocation.setAndroidNotification(
      title: "Геолокация",
      message: "Получение геолокации...",
      icon: "@mipmap/ic_launcher",
    );
    BackgroundLocation.startLocationService();

    BackgroundLocation.getLocationUpdates((location) {});
  }

  void authorizationBlocListener(
      BuildContext context, AuthorizationState state) {
    if (state is AuthorizationInitial) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoadingScreen()));
    }
  }

  void usersBlocListener(BuildContext context, UsersState state) {
    if (state.status == UserStatus.loaded && state.users.isEmpty) {
      BlocProvider.of<UsersBloc>(context).add(GetAllUsers());
    } else if (state.status == UserStatus.error) {
      showCustomSnackBar(context, state.message ?? '',
          type: SnackBarType.error);
    }
  }

  void goToAddUserPage() {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const AllUsersListScreen()));
  }

  void updateCoordinatesListener() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100,
    );
    LocationPermission permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showCustomSnackBar(context,
          'Для обновления позиции необходимо разрешить доступ к геолокации',
          type: SnackBarType.error);
    } else {
      positionStream =
          Geolocator.getPositionStream(locationSettings: locationSettings)
              .listen((Position? position) {
        if (position != null &&
            BlocProvider.of<UsersBloc>(context).user != null &&
            BlocProvider.of<UsersBloc>(context).user!.id.isNotEmpty) {
          updateUserCoordinates();
        }
      });
      setState(() {});
    }
  }

  void updateUserCoordinates() async {
    LocationPermission permission;

    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      showCustomSnackBar(context,
          'Для обновления позиции необходимо разрешить доступ к геолокации',
          type: SnackBarType.error);
    } else {
      Position position = await Geolocator.getCurrentPosition();
      BlocProvider.of<UsersBloc>(context)
          .add(UpdateCoordinates(position.latitude, position.longitude));
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (settingsSheetKey.currentState != null) {
          Navigator.of(context).pop();
        }
      },
      child: MultiBlocListener(
        listeners: [
          BlocListener<UsersBloc, UsersState>(
            listener: usersBlocListener,
          ),
          BlocListener<AuthorizationBloc, AuthorizationState>(
            listener: authorizationBlocListener,
          ),
        ],
        child: Scaffold(
          appBar: const CustomAppBar(title: 'Tracker App', hasSettings: true),
          body: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: const [
                UserInfoCard(),
                ApprovedInstructions(),
                FriendsList(),
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: goToAddUserPage,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: Colors.teal,
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    positionStream.cancel();
    updateUsersTimer.cancel();
    super.dispose();
  }
}
