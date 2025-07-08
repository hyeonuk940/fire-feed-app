class AppUser {
  final String uid;
  final String pw;

  AppUser({
    required this.uid,
    required this.pw,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      pw: json['pw'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': pw,
    };
  }
}
