import 'package:generics/generics.dart';

class Attribute extends TableDefinition<AttributeColumnNames> {
  final String appVersion;
  final String os;
  final String id;

  const Attribute({
    required this.appVersion,
    required this.os,
    required this.id,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      appVersion: json['appVersion'],
      os: json['os'],
      id: json['id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'appVersion': appVersion,
        'os': os,
        'id': id,
      };
}

enum AttributeColumnNames {
  APP_VERSION('USER_NAME'),
  OS('OS'),
  ID('ID');

  const AttributeColumnNames(this.name);
  final String name;
}
