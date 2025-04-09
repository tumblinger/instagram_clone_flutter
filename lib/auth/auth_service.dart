import 'package:firebase_auth/firebase_auth.dart';

class AuthService{
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _genericErrorMessage = 'An unexpected error occurred';
  Stream<User?> get firebaseUser => _auth.authStateChanges();

  Future<AuthServiceResponse<User>> signupWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      User ? firebaseUser = userCredential.user;
      return AuthServiceResponse(data: firebaseUser);
        } on FirebaseAuthException catch(e){
        final signupErrorMessage = _handleFirebaseAuthException(e);
        return AuthServiceResponse(errorMessage: signupErrorMessage);
    } catch(e) {
      return AuthServiceResponse(errorMessage: _genericErrorMessage);
    }
  }

  Future<AuthServiceResponse<User>> loginWithEmailAndPassword(String email, String password) async {
    try {
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      User ? firebaseUser = userCredential.user;
      return AuthServiceResponse(data: firebaseUser);
    } on FirebaseAuthException catch(e){
      print(e);
      final loginErrorMessage = _handleFirebaseAuthException(e);
      return AuthServiceResponse(errorMessage: loginErrorMessage);
    } catch(e) {
        return AuthServiceResponse(errorMessage: _genericErrorMessage);
    }
  }

  String _handleFirebaseAuthException (FirebaseAuthException e){
    switch (e.code){
      case 'weak-password':
        return 'The password is too weak';
      case 'email-already-in-use':
        return 'The account already exists';
      case 'invalid-email':
        return 'Email or password is invalid';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Email or password is invalid';
      case 'too-many-requests':
        return 'Too many attempts. Wait one minute';
      default:
        return 'Error: ${_genericErrorMessage}';
    }
  }

  Future<void> logout() async{
    await _auth.signOut();
  }
}

class AuthServiceResponse <T>{
  T? data;
  String? errorMessage;
  AuthServiceResponse({
    this.data, this.errorMessage
});
}