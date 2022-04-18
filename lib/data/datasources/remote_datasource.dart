import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_tracker/data/models/user_model.dart';

import '../../domain/entites/user.dart';

abstract class RemoteDatasource {
  Future<List<User>> getUsers(String jwt);
  Future<User> getUser(String jwt);
  Future<User> addFriend(String jwt, String userId, String friendId);
  Future<User> approveFriend(String jwt, String userId, String friendId);
  Future<User> deleteFriend(String jwt, String userId, String friendId);
}

class RemoteDatacourceImpl extends RemoteDatasource {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  @override
  Future<List<User>> getUsers(String jwt) async {
    return [];
  }

  @override
  Future<User> addFriend(String jwt, String userId, String friendId) async {
    late String userPath;
    late String friendPath;
    late UserModel user;
    late UserModel friend;

    // find user with userId(user1)
    await users.where('id', isEqualTo: userId).get().then((value) {
      userPath = value.docs.first.id;
      user = UserModel.fromJson(value.docs.first.data() as dynamic);
    });

    // find user with friendId(user2)
    await users.where('id', isEqualTo: friendId).get().then((value) {
      friendPath = value.docs.first.id;
      friend = UserModel.fromJson(value.docs.first.data() as dynamic);
    });

    bool hasUser = user.friends
        .where((element) => element.email == friend.email)
        .isNotEmpty;

    if (!hasUser) {
      // add friend2 to user1's friends
      users.doc(userPath).update({'friends': friend.toJson()});
      // add user1 to user2's friends
      users.doc(friendPath).update({'friends': user.toJson()});
    }

    late UserModel newUser;

    users
        .doc(userPath)
        .get()
        .then((value) => newUser = UserModel.fromJson(value.data() as dynamic));

    return newUser;
  }

  @override
  Future<User> approveFriend(String jwt, String userId, String friendId) async {
    // change user's friend with frendId approved to true
    // get all users
    // find user with friendId
    // find friend with userIs
    // change friend approval to true
    return UserModel.fromJson({'': ''});
  }

  @override
  Future<User> deleteFriend(String jwt, String userId, String friendId) async {
    // get all users
    // find user with userId(user1)
    // find user with friendId(user2)
    // delete friend2 from user1's friends
    // delete user1 from user2's friends
    return UserModel.fromJson({'': ''});
  }

  @override
  Future<User> getUser(String jwt) async {
    return UserModel.fromJson({'': ''});
  }
}


      // final res = await users.add(
      //     {'name': 'qwert123', 'id': '3', 'long': 0, 'friends': [], 'lat': 0});
