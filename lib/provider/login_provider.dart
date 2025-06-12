import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<String?> signInWithEmail(String email, String password) async {
    setLoading(true);
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      setLoading(false);
      return null;
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }

  Future<String?> signInWithGoogle() async {
    setLoading(true);
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        setLoading(false);
        return 'Google ile giriş iptal edildi';
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      // FirebaseAuth signInWithCredential otomatik olarak yeni kullanıcıyı kaydeder
      await FirebaseAuth.instance.signInWithCredential(credential);
      // Eğer yeni kullanıcı ise, burada ek işlemler yapılabilir (ör. Firestore'a profil ekleme)
      setLoading(false);
      return null;
    } catch (e) {
      setLoading(false);
      return e.toString();
    }
  }
}
