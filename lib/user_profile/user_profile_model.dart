import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/user_profile/user_profile_enums.dart';

import  'package:cloud_firestore/cloud_firestore.dart';

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
  final DateTime? createdAt;
  final DateTime? updatedAt;

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
    this.createdAt,
    this.updatedAt,
  });

  factory UserProfileModel.fromFirebaseUser(User firebaseUser){
    return UserProfileModel(
        uid: firebaseUser.uid,
        email: firebaseUser.email!,
        avatar: firebaseUser.photoURL!,
        // createdAt: DateTime.now(),
        // updatedAt: DateTime.now(),
        userName: firebaseUser.displayName!);
  }

  //method to update the specific fields:
  UserProfileModel copyWith({
    String? email,
    String? avatar,
    String? userName,
    String? bio,
    String? website,
    String? firstName,
    Gender? gender,
    int? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
}) {
    return UserProfileModel(
      uid: this.uid,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      userName: userName ?? this.userName,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      firstName: firstName ?? this.firstName,
      gender: gender ?? this.gender,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory UserProfileModel.fromFirestore( DocumentSnapshot firestoreUserProfileDoc){
    Map<String, dynamic> firestoreUserProfileData = firestoreUserProfileDoc.data() as Map<String, dynamic>;

    return UserProfileModel(
        uid: firestoreUserProfileDoc.id,
        email: firestoreUserProfileData['email'],
        avatar: firestoreUserProfileData['avatar'],
        userName: firestoreUserProfileData['userName'],
        bio: firestoreUserProfileData['bio'] ?? '',
        website: firestoreUserProfileData['website'] ?? '',
        firstName: firestoreUserProfileData['firstName'] ?? '',
        gender: firestoreUserProfileData['gender'],
        phoneNumber: firestoreUserProfileData['phoneNumber'],
        createdAt: (firestoreUserProfileData['createdAt'] as Timestamp).toDate(),
        updatedAt: (firestoreUserProfileData['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap(){
    return{
      'uid': uid,
      'email': email,
      'avatar': avatar,
      'userName': userName,
      'bio': bio ?? '',
      'website': website ?? '',
      'firstName': firstName ?? '',
      'gender': gender?.toString(),
      'phoneNumber': phoneNumber,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : null,
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      // 'createdAt': createdAt?.toIso8601String(),
      // 'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}
