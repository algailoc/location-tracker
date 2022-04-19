import 'dart:convert';

import '../../domain/entites/user.dart';

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required double lat,
    required double long,
    required List<User> friends,
    bool approved = true,
    bool initializer = false,
  }) : super(
          id: id,
          email: email,
          lat: lat,
          long: long,
          friends: friends,
          approved: approved,
          initializer: initializer,
        );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    List<User> friends = [];

    if (json['friends'] != null) {
      json['friends'].forEach((el) => friends.add(UserModel.fromJson(el)));
    }

    return UserModel(
        id: json['id'],
        email: json['name'],
        lat: json['lat'].toDouble(),
        long: json['long'].toDouble(),
        approved: json['approved'] ?? true,
        initializer: json['initializer'] ?? false,
        friends: friends);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': email,
      'lat': lat,
      'long': long,
    };
  }

  UserModel copyWith({bool? approved, bool? initializer}) {
    return UserModel(
        id: id,
        email: email,
        lat: lat,
        long: long,
        friends: friends,
        approved: approved ?? this.approved,
        initializer: initializer ?? this.initializer);
  }
}
