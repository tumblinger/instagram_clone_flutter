import 'package:firebase_auth/firebase_auth.dart';
import 'package:instagram_clone/user_profile/user_profile_enums.dart';

//Этот импорт нужен в методе toMap(), где используется Timestamp:
// Тип Timestamp — это класс из Cloud Firestore, а не из стандартного Dart. Он нужен для правильного сохранения времени в формате, который понимает Firestore.
import  'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String email;
  final String avatar;
  final String userName;
  final String ? bio;
  final String ? website;
  final String ? firstName;
  final int ? totalPosts;
  final int ? totalFollowers;
  final int ? totalFollowing;
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
    this.totalPosts,
    this.totalFollowers,
    this.totalFollowing,
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
    int ? totalPosts,
    int ? totalFollowers,
    int ? totalFollowing,
    Gender? gender,
    int? phoneNumber,
    DateTime? createdAt,
    DateTime? updatedAt,
}) {
    return UserProfileModel(
      uid: uid,
      email: email ?? this.email,
      avatar: avatar ?? this.avatar,
      userName: userName ?? this.userName,
      bio: bio ?? this.bio,
      website: website ?? this.website,
      firstName: firstName ?? this.firstName,
      totalPosts: totalPosts ?? this.totalPosts ?? 0,
      totalFollowers: totalFollowers ?? this.totalFollowers ?? 0,
      totalFollowing: totalFollowing ?? this.totalFollowing ?? 0,
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
        totalPosts: firestoreUserProfileData['totalPosts'],
        totalFollowers: firestoreUserProfileData['totalFollowers'],
        totalFollowing: firestoreUserProfileData['totalFollowing'],
        firstName: firestoreUserProfileData['firstName'] ?? '',
        gender: firestoreUserProfileData['gender'],
        phoneNumber: firestoreUserProfileData['phoneNumber'],
      createdAt: firestoreUserProfileData['createdAt'] is Timestamp
          ? (firestoreUserProfileData['createdAt'] as Timestamp).toDate()
          : null,

      updatedAt: firestoreUserProfileData['updatedAt'] is Timestamp
          ? (firestoreUserProfileData['updatedAt'] as Timestamp).toDate()
          : null,
        // createdAt: (firestoreUserProfileData['createdAt'] as Timestamp).toDate(),
        // updatedAt: (firestoreUserProfileData['updatedAt'] as Timestamp).toDate(),
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
