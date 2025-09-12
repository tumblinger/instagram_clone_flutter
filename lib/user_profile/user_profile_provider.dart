import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagram_clone/auth/auth_service.dart';
import 'package:instagram_clone/user_profile/user_profile_model.dart';
import 'package:instagram_clone/user_profile/user_profile_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyAuthProvider extends ChangeNotifier{
  final AuthService _authService = AuthService();
  final UserProfileService _userProfileService = UserProfileService();

  UserProfileModel ? _userProfile;
  late SharedPreferences _sharedPreferences;
  String hasSignedUpBeforeStatusKey = 'has-signed-up-before';
  String _email = '';

  bool _hasSignedUpBefore = false;
  StreamSubscription<User?>? _authStateSubscription;

  String get email => _email;
  UserProfileModel ? get userProfile => _userProfile;
  bool get hasSignedUpBefore => _hasSignedUpBefore;

  MyAuthProvider(){
    _initializeSharedPreferences();
    _initializeAuthStateListener();
  }

  void _initializeAuthStateListener(){
    _authStateSubscription = _authService.firebaseUser.listen((User? firebaseUser) async {
      if(firebaseUser != null) {
        try{
           _userProfile = await _userProfileService.getUserProfile(firebaseUser.uid);
        } catch(error){
          print(error);
          }
      } else {
        _userProfile = null;
        }
      notifyListeners();
    });
  }

  Future<void> _initializeSharedPreferences() async{
    _sharedPreferences = await SharedPreferences.getInstance();
    await _loadingHasSignedUpBeforeStatus();
  }

  Future<void> setHasSignedUpBefore() async{
    await _sharedPreferences.setBool(hasSignedUpBeforeStatusKey, true);
    notifyListeners();
  }

  Future<void> _loadingHasSignedUpBeforeStatus() async{
    final  bool hasSignedUpBeforeStatus = _sharedPreferences.getBool(hasSignedUpBeforeStatusKey) ?? false;
    _hasSignedUpBefore = hasSignedUpBeforeStatus;
    notifyListeners();
  }

  Stream<UserProfileModel ?> get userProfileStream => _authService.firebaseUser.map((firebaseUser) => firebaseUser != null ? UserProfileModel.fromFirebaseUser(firebaseUser) : null);

  void setEmail(String email){
    _email = email;
    notifyListeners();
  }

  Future<AuthServiceResponse<UserProfileModel>> signupWithEmailAndPassword(String password) async {
    final authServiceResponse = await _authService.signupWithEmailAndPassword(
        _email, password);

    User? firebaseUser = authServiceResponse.data;

    if(firebaseUser != null){
      String defaultUserName = _userProfileService.userIDGenerator();
      String avatarName = firebaseUser.email!.substring(0,4);
      String randomAvatar = 'https://ui-avatars.com/api/?background=0D8ABC&color=001&name=$avatarName';
      User? updatedFirebaseUser = await _authService.updateAuthCurrentUser(defaultUserName, randomAvatar);

      setHasSignedUpBefore();
      _userProfile = UserProfileModel.fromFirebaseUser(updatedFirebaseUser ?? firebaseUser);

      await _userProfileService.createUserProfile(_userProfile!);
      _userProfile = await _userProfileService.getUserProfile(firebaseUser.uid);
      notifyListeners();

      return AuthServiceResponse(data: _userProfile);
    }
    return AuthServiceResponse(errorMessage: authServiceResponse.errorMessage);
  }

  Future<AuthServiceResponse<UserProfileModel>> loginWithEmailAndPassword(String email, String password) async {
    final authServiceResponse = await _authService.loginWithEmailAndPassword(
        email, password);
    User? firebaseUser = authServiceResponse.data;

    if(firebaseUser != null){
      _userProfile = UserProfileModel.fromFirebaseUser(firebaseUser);
      notifyListeners();
      return AuthServiceResponse(data: _userProfile);
    }

    return AuthServiceResponse(errorMessage: authServiceResponse.errorMessage);
  }
  void setUserProfile(UserProfileModel userProfile) {
    _userProfile = userProfile;
    notifyListeners();
  }

  void dispose() {
    _authStateSubscription?.cancel();
    super.dispose();
  }
}
