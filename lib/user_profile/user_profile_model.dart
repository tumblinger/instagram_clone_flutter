import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/user_profile/user_profile_enums.dart';

class UserProfileModel {
  final String uid;
  final String email;
  final String avatar;
  final String userName;
  final String ? bio;
  final String ? website;
  final String ? firstName;
  final Gender ? gender;
  final int ? phoneNumber;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.avatar,
    required this.userName,
    this.bio,
    this.website,
    this.firstName,
    this.gender,
    this.phoneNumber,
    required this.createdAt,
    required this.updatedAt,
  });
  factory UserProfileModel.fromFirebaseUser(User firebaseUser){
    return UserProfileModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        avatar: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        userName: '');
  }
}