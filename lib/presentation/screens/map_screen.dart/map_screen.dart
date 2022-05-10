import 'package:firebase_tracker/domain/entites/user.dart';
import 'package:flutter/material.dart';

import '../../widgets/general/custom_app_bar.dart';

class MapScreen extends StatelessWidget {
  final double lat, long;

  const MapScreen({required this.lat, required this.long, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(title: 'Tracker App'),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(),
      ),
    );
  }
}
