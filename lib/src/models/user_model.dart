class User {
  final String uid;
  final String name;
  final String email;
  final String photoUrl;

  User(
      {required this.uid,
      required this.name,
      required this.email,
      required this.photoUrl});

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'photoUrl': photoUrl,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'] ?? '',
    );
  }
}
