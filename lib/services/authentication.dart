import 'package:ameen/blocs/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Create User Object based on Firebase User.
  UserModel _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserModel() : null;
  }


  Future signInAnonymously() async {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      return user != null ?  user : null;
  }

  Stream<UserModel> get currentUser {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) =>_userFromFirebaseUser(user));
  }
}
