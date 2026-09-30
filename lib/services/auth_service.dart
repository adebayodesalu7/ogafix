import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/user_profile_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;

  // Check if Email or Phone is already registered in Firestore
  Future<Map<String, bool>> checkExistingUser({
    String? email,
    String? phone,
    String? uid,
  }) async {
    bool emailExists = false;
    bool phoneExists = false;
    bool uidExists = false;

    if (uid != null && uid.isNotEmpty) {
      final uidDoc = await _firestore.collection('users').doc(uid).get();
      uidExists = uidDoc.exists;
    }

    if (email != null && email.isNotEmpty) {
      final emailQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .get();
      emailExists = emailQuery.docs.isNotEmpty;
    }

    if (phone != null && phone.isNotEmpty) {
      final phoneQuery = await _firestore
          .collection('users')
          .where('phone', isEqualTo: phone)
          .get();
      phoneExists = phoneQuery.docs.isNotEmpty;
    }

    return {
      'emailExists': emailExists,
      'phoneExists': phoneExists,
      'uidExists': uidExists,
    };
  }

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

  // Email & Password Signup
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Email & Password Signin
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Google Sign-In with Smart Onboarding routing
  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        return {'userCred': null, 'isNewUser': false};
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCred = await _auth.signInWithCredential(credential);
      final uid = userCred.user!.uid;

      // Check if user already exists in Firestore
      final existing = await checkExistingUser(uid: uid);
      final bool isNewUser = !existing['uidExists']!;

      return {'userCred': userCred, 'isNewUser': isNewUser};
    } catch (e) {
      rethrow;
    }
  }

  // Simulated NIMC NIN Verification API
  Future<Map<String, dynamic>> verifyNinNumber(String nin) async {
    await Future.delayed(
      const Duration(seconds: 1),
    ); // Network latency simulation
    if (nin.length != 11 || !RegExp(r'^[0-9]+$').hasMatch(nin)) {
      throw Exception('Invalid NIN. Must be exactly 11 digits.');
    }
    // Simulated NIMC Database lookup for verified Nigerian identity
    return {
      'success': true,
      'fullName': 'Adebayo Tunde Desalu',
      'stateOfOrigin': 'Lagos State',
      'dob': '1995-06-14',
      'age': 31,
      'gender': 'Male',
    };
  }

  // Save basic User Profile to Firestore
  Future<void> saveUserProfile({
    required String uid,
    required String phone,
    required String role,
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

  // Save User Profile to Firestore with Verification Levels
  Future<void> saveCompleteUserProfile(UserProfile profile) async {
    int calcVerificationLevel = 1; // Phone Verified
    if (profile.emailVerified) {
      calcVerificationLevel = 2; // Email Verified
    }
    if (profile.emailVerified && profile.ninNumber.isNotEmpty) {
      calcVerificationLevel = 3; // NIN & Skill Verified
    }

    final updatedProfile = UserProfile(
      uid: profile.uid,
      email: profile.email,
      phone: profile.phone,
      role: profile.role,
      fullName: profile.fullName,
      state: profile.state,
      lga: profile.lga,
      stateOfOrigin: profile.stateOfOrigin,
      yearsOfExperience: profile.yearsOfExperience,
      profession: profile.profession,
      ninNumber: profile.ninNumber,
      description: profile.description,
      profileImageUrl: profile.profileImageUrl,
      jobStatuses: profile.jobStatuses,
      verificationLevel: calcVerificationLevel,
      emailVerified: profile.emailVerified,
      phoneVerified: profile.phoneVerified,
      ninVerified: profile.ninNumber.isNotEmpty,
    );

    await _firestore
        .collection('users')
        .doc(profile.uid)
        .set(updatedProfile.toMap(), SetOptions(merge: true));

    if (profile.role == 'professional') {
      await _firestore
          .collection('professional_profiles')
          .doc(profile.uid)
          .set(updatedProfile.toMap(), SetOptions(merge: true));
    } else {
      await _firestore
          .collection('customer_profiles')
          .doc(profile.uid)
          .set(updatedProfile.toMap(), SetOptions(merge: true));
    }
  }

  // Fetch User Profile from Firestore
  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return UserProfile.fromMap(doc.data()!);
    }
    return null;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
