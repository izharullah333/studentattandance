class UserModel{
  late String uid;
  late String name;
  late String email;
  late String profileImage;
  late int dt;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.dt,
  });
  factory UserModel.fromJson(Map<String, dynamic> map){//convert local jason to std
    return UserModel(
        uid:map ['uid'],
        name:map ['name'],
        email:map ['email'],
      profileImage:map ['profileImage'],
        dt:map ['dt'],
    );
  }
}