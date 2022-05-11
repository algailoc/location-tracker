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
