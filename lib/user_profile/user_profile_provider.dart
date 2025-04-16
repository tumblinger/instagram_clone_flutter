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
  String ? get email => _email;

  UserProfileModel ? get userProfile => _userProfile;
  bool get hasSignedUpBefore => _hasSignedUpBefore;

  MyAuthProvider(){
    _initializeSharedPreferences();
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

  //Если регистрация успешна, т.е. firebaseUser не равен null, то возвращаем метод
  // Если регистрация неуспешна, возвращаем false:
  Future<AuthServiceResponse<UserProfileModel>> signupWithEmailAndPassword(String password) async {
    final authServiceResponse = await _authService.signupWithEmailAndPassword(
        _email, password);

    User? firebaseUser = authServiceResponse.data;

    if(firebaseUser != null){
      String defaultUserName = _userProfileService.userIDGenerator();
      String avatarName = firebaseUser.email!.substring(0,3);
      String randomAvatar = 'https://ui-avatars.com/api/?background=random&name=$avatarName';
      await _authService.updateAuthCurrentUser(defaultUserName, randomAvatar);
      
      setHasSignedUpBefore();
      _userProfile = UserProfileModel.fromFirebaseUser(firebaseUser);
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
      return AuthServiceResponse(data: _userProfile);
    }
    return AuthServiceResponse(errorMessage: authServiceResponse.errorMessage);
  }
}
