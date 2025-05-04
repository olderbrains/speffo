class UserRegisterModel {
  final String uid;
  final String token;

  UserRegisterModel({required this.uid, required this.token});

  factory UserRegisterModel.fromJson(Map<String, dynamic> json) {
    return UserRegisterModel(uid: json['uid'], token: json['token']);
  }
}
