import '../../domain/entites/user.dart';

class FriendModel extends Friend {
  FriendModel(
      {required String id, required bool approved, required bool initializer})
      : super(approved: approved, id: id, initializer: initializer);

  factory FriendModel.fromJson(Map<String, dynamic> json) {
    return FriendModel(
        id: json['id'],
        approved: json['approved'],
        initializer: json['initializer']);
  }
}

class UserModel extends User {
  UserModel({
    required String id,
    required String email,
    required double lat,
    required double long,
    required List<Friend> friends,
    bool approved = false,
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
    List<Friend> friends = [];

    if (json['friends'] != null) {
      json['friends'].forEach((el) => friends.add(FriendModel.fromJson(el)));
    }

    return UserModel(
        id: json['id'],
        email: json['name'],
        lat: json['lat'].toDouble(),
        long: json['long'].toDouble(),
        approved: json['approved'] ?? false,
        initializer: json['initializer'] ?? false,
        friends: friends);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': email,
      'lat': lat,
      'long': long,
      'approved': approved,
      'initializer': initializer
    };
  }

  UserModel copyWith(
      {bool? approved,
      bool? initializer,
      double? lat,
      double? long,
      List<Friend>? friends}) {
    return UserModel(
        id: id,
        email: email,
        lat: lat ?? this.lat,
        long: long ?? this.long,
        friends: friends ?? this.friends,
        approved: approved ?? this.approved,
        initializer: initializer ?? this.initializer);
  }
}
