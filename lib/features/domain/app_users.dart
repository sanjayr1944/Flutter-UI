class AppUsers {
  final String uid;
  final String email;
  final String role;

  AppUsers({required this.uid, required this.email, required this.role});


  factory AppUsers.fromMap(
  {
    required String uid,
    required String email,
    required Map<String, dynamic> data,

})
  {
    return AppUsers(uid: uid,
        email: email,
        role: data["role"] as String? ?? "user");
  }
}
