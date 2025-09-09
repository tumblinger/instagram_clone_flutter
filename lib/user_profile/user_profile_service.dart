import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:uuid/uuid.dart';

class UserProfileService {
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance; 
  final uuid = Uuid();

  // 0. Create a function
  String userIDGenerator(){
    // 1. Generate cryptographically strong random number
    Random random = Random.secure();

    // 2. Create a string of random characters
    String randomString = base64Url.encode(
        List<int>.generate(16, (_) => random.nextInt(256)));

    // 3. Create a hash of the randomString using SHA-256
    List<int> bytes = utf8.encode(randomString);
    Digest digest = sha256.convert(bytes);
    String shortHash = digest.toString().substring(0,8);
    return 'user_$shortHash';
  }

  Future<UserProfileModel?> getUserProfile(String uid) async {
    final firestoreUserProfileDoc = await _firebaseFirestore.collection('user-profiles').doc(uid).get();
    if(firestoreUserProfileDoc.exists) {
      return UserProfileModel.fromFirestore(firestoreUserProfileDoc);
    }
    return null;
  }

  Future<bool> createUserProfile(UserProfileModel userProfileData) async{

    try{
      await _firebaseFirestore
          .collection('user-profiles')
          .doc(userProfileData.uid)
          .set(userProfileData.toMap());
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<List<UserProfileModel>> getUsersByUserNameSearch(String searchText) async {
    if(searchText.isEmpty) return [];

    //make it case-insensitive:
    final lowerCaseSearchText = searchText.toLowerCase();

    try{
      final querySnapshot = await _firebaseFirestore
          .collection('user-profiles')
          .orderBy('userName')
          .where('userName', isGreaterThanOrEqualTo: lowerCaseSearchText) 
          .where('userName', isLessThan: '${lowerCaseSearchText}z') 
          .get();

      List<DocumentSnapshot> userProfileDocs = querySnapshot.docs; //getting docs
      List<UserProfileModel> userProfiles = userProfileDocs.map((userProfileDoc) => UserProfileModel.fromFirestore(userProfileDoc)).toList(); 
      return userProfiles;

    }
    catch (error){
      print('Firestore error: $error');
      return [];
    }
  }
  
  Future<bool> updateUserProfile(UserProfileModel userProfileToUpdate, File? newUserAvatarFile) async{

    String userAvatar = userProfileToUpdate.avatar;

    try{
      if(newUserAvatarFile != null){
        String? newUserAvatarUrl = await uploadUserAvatarToStorage(newUserAvatarFile);
        if(newUserAvatarUrl != null){
          userAvatar = newUserAvatarUrl;
        }
      }
      await _firebaseFirestore.collection('user-profiles').doc(userProfileToUpdate.uid).update(userProfileToUpdate.toMap());
      return true;
    }
    catch(e){
      print(e);
      return false;
    }
  }

  Future<String?> uploadUserAvatarToStorage(File newUserAvatarFile) async{
    try{
      final String newUserAvatarFileExt = newUserAvatarFile.path.split('.').last.toLowerCase();
      final String newUserAvatarFileName = '${uuid.v4()}.$newUserAvatarFileExt';
      final newUserAvatarFileRef = _firebaseStorage.ref().child('user-avatars').child(newUserAvatarFileName);

      final TaskSnapshot newUserAvatarFileSnapshot = await newUserAvatarFileRef.putFile(newUserAvatarFile);
      final String newUserAvatarUrl = await newUserAvatarFileSnapshot.ref.getDownloadURL();

      return newUserAvatarUrl;

    } catch(e){
      print(e);
      return null;
    }
  }
  
}

