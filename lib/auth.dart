import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

abstract class AuthImplementation {
  Future<String> SignIn(String email, String password);
  Future<String> SignUp(String email, String password);
  Future<String> getCurrentUser();
}

class AuthService implements AuthImplementation{
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Firestore _db = Firestore.instance;

  FirebaseUser user2;

  Observable<FirebaseUser> user;
  Observable<Map<String, dynamic>> profile;
  PublishSubject loading = PublishSubject();

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);

    profile = user.switchMap((FirebaseUser u) {
      if(u != null){
        return _db.collection('users').document(u.uid).snapshots().map((snap) => snap.data);
      }
      else{
        return Observable.just({ });
      }
    });
  }

  //will allow user to sign in
  Future<String> SignIn(String email, String password) async {
    FirebaseUser user = (await _auth.signInWithEmailAndPassword(
      email: email, password: password));
    user2 = user;
    return user.uid;
  }

//will allow user to sign up
  Future<String> SignUp(String email, String password) async {
    FirebaseUser user = (await _auth.createUserWithEmailAndPassword(email: email, password: password));
    return user.uid;
  }

  Future<String> getCurrentUser() async {
    user2 = await _auth.currentUser();
    
    return user2.uid;
  }

  Future<FirebaseUser> googleSignIn() async {
    loading.add(true);
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken
    );
    FirebaseUser user = await _auth.signInWithCredential(credential);
    updateUserData(user);
    print("Signed in " + user.displayName);

    loading.add(false);

    this.user2 = user;
    return user2;
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);

    return ref.setData({
      'uid': user.uid,
      'email': user.email,
      'photoURL': user.photoUrl,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  FirebaseUser currUser() {
    getCurrentUser();
    return user2;
  }

  void signOut() {
    _auth.signOut();
  }

}

final AuthService authService = AuthService();