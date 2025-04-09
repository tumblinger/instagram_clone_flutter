import 'package:firebase_auth/firebase_auth.dart';

class UserProfileModel {
  final String uid;
  final String email;
  final String avatar;
  final String ? bio;
  final String ? firstName;
  final String ? gender;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.avatar,
    this.bio,
    this.firstName,
    this.gender,
  });
  factory UserProfileModel.fromFirebaseUser(User firebaseUser){
    return UserProfileModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        avatar: '');
  }
}