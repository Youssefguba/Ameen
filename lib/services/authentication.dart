import 'package:ameen/blocs/models/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';


class AuthService {
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  // Create User Object based on Firebase User.
  UserModel userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Future signUp(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signIn(String email, String password) async {
    try {
      AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      return user;
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signInAnonymously() async {
      AuthResult result = await _firebaseAuth.signInAnonymously();
      FirebaseUser user = result.user;
      return user != null ?  user : null;
  }

  Future signOut() async {
    try {
      return await _firebaseAuth.signOut();
    } catch(e) {
      print(e.toString());
      return null;
    }
  }

  Stream<UserModel> get currentUser {
    return _firebaseAuth.onAuthStateChanged
        .map((FirebaseUser user) => userFromFirebaseUser(user));
  }
}
