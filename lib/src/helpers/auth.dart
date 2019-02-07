import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

class Auth {
  // Create an instance of [FirebaseAuth]
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Sign in to an existing account using an [email] and [password]
  /// and returns a [user]
  Future<FirebaseUser> signIn({
    @required String email,
    @required String password,
  }) async {
    final FirebaseUser user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);
    // Make sure the user exists
    assert(user != null && await user.getIdToken() != null);

    final FirebaseUser currentUser = await _auth.currentUser();
    // Check if the user was signed in successfully
    assert(user.uid == currentUser.uid);

    return user;
  }

  /// Sign up a new account using an [email] and [password]
  /// and returns a [user]
  Future<FirebaseUser> signUp({
    @required String name,
    @required String email,
    @required String password,
    @required String photoUrl,
  }) async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    assert(user != null && await user.getIdToken() != null);

    // Update the name from null to submitted name
    UserUpdateInfo userUpdateInfo = UserUpdateInfo();
    userUpdateInfo.displayName = name;
    userUpdateInfo.photoUrl = photoUrl;
    await user.updateProfile(userUpdateInfo);
    // Get the updated user
    user = await _auth.currentUser();

    return user;
  }

  /// Sign out the current account
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
