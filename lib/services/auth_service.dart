import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Send Phone OTP
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(String verificationId) onCodeSent,
    required Function(String error) onError,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await _auth.signInWithCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          onError(e.message ?? 'Verification failed');
        },
        codeSent: (String verificationId, int? resendToken) {
          onCodeSent(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      onError(e.toString());
    }
  }

  // Verify OTP and Sign In
  Future<UserCredential?> signInWithOTP({
    required String verificationId,
    required String smsCode,
  }) async {
    try {
      final PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      rethrow;
    }
  }

  // Save User Profile to Firestore
  Future<void> saveUserProfile({
    required String uid,
    required String phone,
    required String role, // 'customer' or 'professional'
    required String state,
    required String lga,
    String? profession,
  }) async {
    final Map<String, dynamic> data = {
      'uid': uid,
      'phone': phone,
      'role': role,
      'state': state,
      'lga': lga,
      'createdAt': FieldValue.serverTimestamp(),
    };

    if (role == 'professional' && profession != null) {
      data['profession'] = profession;
      await _firestore
          .collection('professional_profiles')
          .doc(uid)
          .set(data, SetOptions(merge: true));
    } else {
      await _firestore
          .collection('customer_profiles')
          .doc(uid)
          .set(data, SetOptions(merge: true));
    }

    await _firestore.collection('users').doc(uid).set({
      'uid': uid,
      'phone': phone,
      'role': role,
      'status': 'active',
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
