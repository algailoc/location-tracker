import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebaseAuth;
import 'package:firebase_tracker/core/errors/exceptions.dart';
import 'package:firebase_tracker/data/models/user_model.dart';

import '../../domain/entites/user.dart';
import 'package:uuid/uuid.dart';

abstract class RemoteDatasource {
  // Users Bloc
  Future<User> addFriend(String userToken, String friendId);
  Future<User> approveFriend(String userToken, Friend friendToApprove);
  Future<User> deleteFriend(String userToken, Friend friendToDelete);
  Future<User> updateCoordinates(String userToken, double lat, double long);

  // Auth Bloc
  Future<String> getUserUserToken(String email);
  Future<String> createUser(String email);
  Future<String> registerUser(String email, String password);
  Future<String> authorizeUser(String email, String password);
  Future<String> signOut();

  // Misc
  Future<User> getUser(String userToken);
  Future<List<User>> getAllUsers(String userToken);
}

class RemoteDatacourceImpl extends RemoteDatasource {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  firebaseAuth.FirebaseAuth auth = firebaseAuth.FirebaseAuth.instance;

  @override
  Future<List<User>> getAllUsers(String userToken) async {
    List<User> result = [];
    if (userToken.isNotEmpty) {
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
  Future<User> addFriend(String userToken, String friendId) async {
    late String friendPath;
    late UserModel user;

    // find user with userId(user1)
    await users.doc(userToken).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendId).get().then((value) {
      friendPath = value.docs.first.id;
    });
    // add friend2 to user1's friends

    await users.doc(userToken).update({
      'friends': FieldValue.arrayUnion([
        // {'id': friendId, 'approved': false, 'initializer': false}
        {'id': friendId, 'approved': false, 'initializer': true}
      ]),
    });
    // add user1 to user2's friends
    await users.doc(friendPath).update({
      'friends': FieldValue.arrayUnion([
        {'id': user.id, 'approved': false, 'initializer': false}
      ]),
    });

    late UserModel newUser;

    await users
        .doc(userToken)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> approveFriend(String userToken, Friend friendToApprove) async {
    // change user's friend with frendId approved to true
    // get all users
    // find user with friendId
    // find friend with userIs
    // change friend approval to true
    late String friendPath;
    late UserModel user;

    // find user with userId(user1)
    await users.doc(userToken).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendToApprove.id).get().then((value) {
      friendPath = value.docs.first.id;
    });
    // add user1 to user2's friends
    // add friend2 to user1's friends
    await users.doc(userToken).update({
      'friends': FieldValue.arrayRemove([
        {
          'id': friendToApprove.id,
          'approved': false,
          'initializer': friendToApprove.initializer
        }
      ]),
    });
    await users.doc(userToken).update({
      'friends': FieldValue.arrayUnion([
        {
          'id': friendToApprove.id,
          'approved': true,
          'initializer': friendToApprove.initializer
        }
      ]),
    });
    // add user1 to user2's friends
    await users.doc(friendPath).update({
      'friends': FieldValue.arrayRemove([
        {
          'id': user.id,
          'approved': false,
          'initializer': !friendToApprove.initializer
        }
      ]),
    });
    await users.doc(friendPath).update({
      'friends': FieldValue.arrayUnion([
        {
          'id': user.id,
          'approved': true,
          'initializer': !friendToApprove.initializer
        }
      ])
    });
    late UserModel newUser;

    await users
        .doc(userToken)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> deleteFriend(String userToken, Friend friendToDelete) async {
    late String friendPath;
    late UserModel user;

    // find user with userId(user1)
    await users.doc(userToken).get().then((value) {
      user = UserModel.fromJson(value.data() as dynamic);
    });
    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendToDelete.id).get().then((value) {
      friendPath = value.docs.first.id;
    });
    // add friend2 to user1's friends
    await users.doc(userToken).update({
      'friends': FieldValue.arrayRemove([
        {
          'id': friendToDelete.id,
          'approved': friendToDelete.approved,
          'initializer': friendToDelete.initializer
        }
      ]),
    });
    // add user1 to user2's friends
    await users.doc(friendPath).update({
      'friends': FieldValue.arrayRemove([
        {
          'id': user.id,
          'approved': friendToDelete.approved,
          'initializer': !friendToDelete.initializer
        }
      ])
    });

    late UserModel newUser;

    await users
        .doc(userToken)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> getUser(String userToken) async {
    late UserModel user;
    await users
        .doc(userToken)
        .get()
        .then((value) => user = UserModel.fromJson(value.data() as dynamic));

    return user;
  }

  @override

  /// After logging in
  Future<String> getUserUserToken(String email) async {
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
  Future<User> updateCoordinates(
      String userToken, double lat, double long) async {
    users.doc(userToken).update({'lat': lat, 'long': long});
    late UserModel newUser;

    await users
        .doc(userToken)
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
