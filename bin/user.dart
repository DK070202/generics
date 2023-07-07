import 'package:generics/generics.dart';

class User extends TableDefinition<UserColumnNames> {
  final String userName;
  final String id;
  final String firstName;
  final String lastName;

  const User({
    this.userName = '',
    this.id = '',
    this.firstName = '',
    this.lastName = '',
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userName: json['userName'],
      id: json['id'],
      firstName: json['nickName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'userName': userName,
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
      };
}

enum UserColumnNames {
  USER_NAME('USER_NAME'),
  FIRST_NAME('FIRST_NAME'),
  LAST_NAME('FIRST_NAME'),
  ID('ID');

  const UserColumnNames(this.name);
  final String name;
}
