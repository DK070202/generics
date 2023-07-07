import 'package:generics/generics.dart';

class JoinedTableAfterOperation
    extends TableDefinition<JoinedTableColumnNames> {
  final String userName;
  final String id;
  final String firstName;
  final String lastName;
  final String appVersion;
  final String os;

  const JoinedTableAfterOperation({
    required this.userName,
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.appVersion,
    required this.os,
  });

  factory JoinedTableAfterOperation.fromJson(Map<String, dynamic> json) {
    return JoinedTableAfterOperation(
      appVersion: json['appVersion'],
      os: json['os'],
      id: json['id'],
      userName: json['userName'],
      firstName: json['nickName'],
      lastName: json['lastName'],
    );
  }

  Map<String, dynamic> toJson() => {
        'appVersion': appVersion,
        'os': os,
        'id': id,
        'userName': userName,
        'firstName': firstName,
        'lastName': lastName,
      };
}

enum JoinedTableColumnNames {
  USER_NAME('USER_NAME'),
  FIRST_NAME('FIRST_NAME'),
  LAST_NAME('FIRST_NAME'),
  APP_VERSION('USER_NAME'),
  OS('OS'),
  ID('ID');

  const JoinedTableColumnNames(this.name);
  final String name;
}
