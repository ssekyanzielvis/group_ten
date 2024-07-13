class User {
  String uid;
  String name;
  String email;
  String photoUrl;
  String location;
  String phoneNumber;

  User({
    required this.uid,
    required this.name,
    required this.email,
    required this.photoUrl,
    required this.location,
    required this.phoneNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
      location: map['location'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
    );
  }

  toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
      'location': location,
      'phoneNumber': phoneNumber,
    };
  }
}
