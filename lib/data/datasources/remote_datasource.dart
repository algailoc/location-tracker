import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:firebase_tracker/core/errors/exceptions.dart';
import 'package:firebase_tracker/data/models/user_model.dart';

import '../../domain/entites/user.dart';
import 'package:uuid/uuid.dart';

abstract class RemoteDatasource {
  // Users Bloc
  Future<User> addFriend(String jwt, String friendId);
  Future<User> approveFriend(String jwt, String friendId);
  Future<User> deleteFriend(String jwt, String friendId);
  Future<User> updateCoordinates(String jwt, double lat, double long);

  // Auth Bloc
  Future<String> getUserJwt(String email);
  Future<String> createUser(String email);
  Future<String> registerUser(String email, String password);
  Future<String> authorizeUser(String email, String password);
  Future<String> signOut();

  // Misc
  Future<User> getUser(String jwt);
  Future<List<User>> getAllUsers(String jwt);
}

class RemoteDatacourceImpl extends RemoteDatasource {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebaseAuth.FirebaseAuth auth = firebaseAuth.FirebaseAuth.instance;

  @override
  Future<List<User>> getAllUsers(String jwt) async {
    List<User> result = [];
    if (jwt.isNotEmpty) {
      await users.get().then((value) {
        if (value.docs.isNotEmpty) {
          value.docs.forEach((e) {
            result.add(UserModel.fromJson(e.data() as dynamic));
          });
        }
      });
      return result;
    } else {
      throw ServerException('Отказано в доступе');
    }
  }

  @override
  Future<User> addFriend(String jwt, String friendId) async {
    late String friendPath;
    late UserModel user;
    late UserModel friend;

    // find user with userId(user1)
    await users.doc(jwt).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendId).get().then((value) {
      friendPath = value.docs.first.id;
      friend = UserModel.fromJson(value.docs.first.data() as dynamic);
    });
    bool hasUser = user.friends
        .where((element) => element.email == friend.email)
        .isNotEmpty;
    if (hasUser) {
      // add friend2 to user1's friends
      users.doc(jwt).update({
        'friends': FieldValue.arrayRemove([friend.toJson()]),
      });

      users.doc(jwt).update({
        'friends':
            FieldValue.arrayUnion([friend.copyWith(approved: false).toJson()]),
      });
      // add user1 to user2's friends
      users.doc(friendPath).update({
        'friends': FieldValue.arrayRemove(
            [user.copyWith(approved: false, initializer: true).toJson()]),
      });

      users.doc(friendPath).update({
        'friends':
            FieldValue.arrayUnion([user.copyWith(approved: true).toJson()]),
      });
    }

    late UserModel newUser;

    await users
        .doc(jwt)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> approveFriend(String jwt, String friendId) async {
    // change user's friend with frendId approved to true
    // get all users
    // find user with friendId
    // find friend with userIs
    // change friend approval to true
    late String friendPath;
    late UserModel user;
    late UserModel friend;

    // find user with userId(user1)
    await users.doc(jwt).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendId).get().then((value) {
      friendPath = value.docs.first.id;
      friend = UserModel.fromJson(value.docs.first.data() as dynamic);
    });
    bool hasUser = user.friends
        .where((element) => element.email == friend.email)
        .isNotEmpty;
    if (hasUser) {
      // add friend2 to user1's friends
      users.doc(jwt).update({
        'friends':
            FieldValue.arrayUnion([friend.copyWith(approved: true).toJson()]),
      });
      // add user1 to user2's friends
      users.doc(friendPath).update({
        'friends':
            FieldValue.arrayUnion([user.copyWith(approved: true).toJson()])
      });
    }
    late UserModel newUser;

    await users
        .doc(jwt)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> deleteFriend(String jwt, String friendId) async {
    late String friendPath;
    late UserModel user;
    late UserModel friend;

    // find user with userId(user1)
    await users.doc(jwt).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendId).get().then((value) {
      friendPath = value.docs.first.id;
      friend = UserModel.fromJson(value.docs.first.data() as dynamic);
    });
    bool hasUser = user.friends
        .where((element) => element.email == friend.email)
        .isNotEmpty;
    if (hasUser) {
      // add friend2 to user1's friends
      users.doc(jwt).update({
        'friends': FieldValue.arrayRemove([friend.toJson()]),
      });
      // add user1 to user2's friends
      users.doc(friendPath).update({
        'friends': FieldValue.arrayRemove([user.toJson()])
      });
    }

    late UserModel newUser;

    await users
        .doc(jwt)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> getUser(String jwt) async {
    late UserModel user;
    await users
        .doc(jwt)
        .get()
        .then((value) => user = UserModel.fromJson(value.data() as dynamic));
    return user;
  }

  @override

  /// After logging in
  Future<String> getUserJwt(String email) async {
    late String result;

    await users.where('name', isEqualTo: email).get().then((value) {
      result = value.docs[0].id;
    });
    return result;
  }

  @override

  /// After signing up
  Future<String> createUser(String email) async {
    var uuid = const Uuid();
    String id = uuid.v1();

    final result = await users
        .add({'friends': [], 'id': id, 'name': email, 'lat': 0, 'long': 0});

    return result.id;
  }

  @override
  Future<User> updateCoordinates(String jwt, double lat, double long) async {
    users.doc(jwt).update({'lat': lat, 'long': long});

    late UserModel newUser;

    await users
        .doc(jwt)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<String> authorizeUser(String email, String password) async {
    await firebaseAuth.FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);
    return 'success';
  }

  @override
  Future<String> registerUser(String email, String password) async {
    await firebaseAuth.FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return 'success';
  }

  @override
  Future<String> signOut() async {
    await firebaseAuth.FirebaseAuth.instance.signOut();
    return 'success';
  }
}
