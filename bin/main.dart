import 'package:generics/generics.dart';

import 'attributes.dart';
import 'joined.dart';
import 'user.dart';

void main() {
  final Table<User, UserColumnNames> userTable = Table<User, UserColumnNames>(
    name: 'user',
    decoder: (value) => User.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  userTable.addRow(
    User(
      id: '123',
      firstName: 'Dhruvin',
      lastName: 'Vainsh',
      userName: 'DK0702',
    ),
  );

  final Table<Attribute, AttributeColumnNames> attributeTable =
      Table<Attribute, AttributeColumnNames>(
    name: 'attributes',
    decoder: (value) => Attribute.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  attributeTable.addRow(
    Attribute(
      appVersion: '1.2.4',
      os: 'mac',
      id: '1234',
    ),
  );

  final joinedTable = userTable.join<JoinedTableColumnNames,
      AttributeColumnNames, JoinedTableAfterOperation>(
    other: attributeTable,
    predicate: () => (UserColumnNames.ID, AttributeColumnNames.ID),
    decoder: (value) => JoinedTableAfterOperation.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  print('Joined Table: ${joinedTable.name}');
}
