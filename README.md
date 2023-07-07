# Generics.

- A sample project for learning generics in dart.
- Sample:

  ```dart
  // User table definition.
  final Table<User, UserColumnNames> userTable = Table<User, UserColumnNames>(
    name: 'user',
    decoder: (value) => User.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  // Add user object in user table.
  userTable.addRow(
    User(
        id: '123',
        firstName: 'Dhruvin',
        lastName: 'Vainsh',
        userName: 'DK0702',
    ),
  ); // Logs user object values in `Encoded` format from provided `encoder` argument.

  // User table definition.
  final Table<Attribute, AttributeColumnNames> attributeTable =
    Table<Attribute, AttributeColumnNames>(
    name: 'attributes',
    decoder: (value) => Attribute.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  // Add Attribute object in user table.
  attributeTable.addRow(
    Attribute(
      appVersion: '1.2.4',
      os: 'mac',
      id: '1234',
    ),
  ); // Logs Attribute object values in `Encoded` format.

  // Reference of joined table.
  final joinedTable = userTable.join<JoinedTableColumnNames,
    AttributeColumnNames, JoinedTableAfterOperation>(
    other: attributeTable, // Table on which we are performing join.
    predicate: () => (
        UserColumnNames.ID,
        AttributeColumnNames.ID,
    ), // Condition for joining table.
    decoder: (value) => JoinedTableAfterOperation.fromJson(value),
    encoder: (value) => value.toJson(),
  );

  print('Joined Table: ${joinedTable.name}');
  ```
