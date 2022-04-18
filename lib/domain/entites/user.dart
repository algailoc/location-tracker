abstract class User {
  final String email, id;
  final double lat, long;
  final List<User> friends;
  final bool apprived, initializer;

  User({
    required this.email,
    required this.id,
    required this.lat,
    required this.long,
    required this.friends,
    this.apprived = false,
    this.initializer = false,
  });
}

// {password: 123, jwt: 1, name: olya, id: 1, lat: 0, friends: [{approved: true, name: qwert, id: 2, lat: 0, long: 0}], long: 0}