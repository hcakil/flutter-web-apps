import 'dart:math';

class MyUser {
  final String? UserId;
  String? Email;
  //String? Password;
  String? NameSurname;
  String? IsRole;

  MyUser({required this.UserId, required this.Email});

  MyUser.name({
    this.UserId,
    this.Email,
    this.NameSurname,
   // this.Password,
    this.IsRole,
  });

  Map<String, dynamic> toMap() {
    return {
      'UserId': UserId,
      'Email': Email,
    //  'Password': Password,
      "NameSurname": NameSurname,
      'IsRole': IsRole,
    };
  }

  MyUser.fromMap(Map<String, dynamic> map)
      : UserId = map["UserId"],
        Email = map["Email"],
      //  Password = map["Password"],
        NameSurname = map["NameSurname"],
        IsRole = map["IsRole"];

  @override
  String toString() {
    return 'User{UserId: $UserId, Email: $Email, NameSurname: $NameSurname, IsRole: $IsRole}';
  }
}
