abstract class Friend {
  final String id;
  final bool approved, initializer;

  Friend({required this.id, required this.approved, required this.initializer});
}

abstract class User {
  final String email, id;
  final double lat, long;
  final List<Friend> friends;
  final bool approved, initializer;

  User({
    required this.email,
    required this.id,
    required this.lat,
    required this.long,
    required this.friends,
    this.approved = false,
    this.initializer = false,
  });
}

// {password: 123, jwt: 1, name: olya, id: 1, lat: 0, friends: [{approved: true, name: qwert, id: 2, lat: 0, long: 0}], long: 0}