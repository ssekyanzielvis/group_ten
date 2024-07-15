class User {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;
  final String dob;
  final String location;
  final String phoneNumber;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.dob,
    required this.location,
    required this.phoneNumber,
  });

  factory User.fromMap(Map<String, dynamic> data) {
    return User(
      uid: data['uid'] as String,
      name: data['name'] as String,
      email: data['email'] as String,
      photoUrl: data['photoUrl'] as String,
      dob: data['dob'] as String,
      location: data['location'] as String,
      phoneNumber: data['phoneNumber'] as String,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'dob': dob,
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }

  Map<String, dynamic> toJson() {
    return toMap();
  }
}
