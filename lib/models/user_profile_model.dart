class UserProfile {
  final String uid;
  final String email;
  final String phone;
  final String role; // 'customer' or 'professional'
  final String fullName;
  final String state;
  final String lga;
  final String stateOfOrigin;
  final int age;
  final int yearsOfExperience;
  final String profession;
  final String ninNumber;
  final String description;
  final int verificationLevel; // 1 to 4
  final bool emailVerified;
  final bool phoneVerified;
  final bool ninVerified;

  UserProfile({
    required this.uid,
    required this.email,
    required this.phone,
    required this.role,
    required this.fullName,
    required this.state,
    required this.lga,
    required this.stateOfOrigin,
    required this.age,
    required this.yearsOfExperience,
    required this.profession,
    required this.ninNumber,
    required this.description,
    required this.verificationLevel,
    required this.emailVerified,
    required this.phoneVerified,
    required this.ninVerified,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'phone': phone,
      'role': role,
      'fullName': fullName,
      'state': state,
      'lga': lga,
      'stateOfOrigin': stateOfOrigin,
      'age': age,
      'yearsOfExperience': yearsOfExperience,
      'profession': profession,
      'ninNumber': ninNumber,
      'description': description,
      'verificationLevel': verificationLevel,
      'emailVerified': emailVerified,
      'phoneVerified': phoneVerified,
      'ninVerified': ninVerified,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      role: map['role'] ?? 'customer',
      fullName: map['fullName'] ?? '',
      state: map['state'] ?? 'Lagos State',
      lga: map['lga'] ?? '',
      stateOfOrigin: map['stateOfOrigin'] ?? '',
      age: map['age'] ?? 18,
      yearsOfExperience: map['yearsOfExperience'] ?? 0,
      profession: map['profession'] ?? '',
      ninNumber: map['ninNumber'] ?? '',
      description: map['description'] ?? '',
      verificationLevel: map['verificationLevel'] ?? 1,
      emailVerified: map['emailVerified'] ?? false,
      phoneVerified: map['phoneVerified'] ?? false,
      ninVerified: map['ninVerified'] ?? false,
    );
  }
}
