import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService2 {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? get currentUser => _firebaseAuth.currentUser;

  Future<User?> getOrCreateCurrentUser(String email, String password) async {
    if (currentUser == null) {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      initializeAccount();
    }
    return currentUser;
  }

  initializeAccount() {
    DocumentReference document =
        FirebaseFirestore.instance.collection('users').doc(currentUser?.uid);
    document.get().then((DocumentSnapshot) => {
          if (!DocumentSnapshot.exists)
            {
              print('initialize bank'),
              document.set({
                'humidity': 0,
                'ph': 7,
                'ppm': 1008,
                'tankLevel': 88,
                'temperature': 19.0,
              }),
            }
        });
  }
}
