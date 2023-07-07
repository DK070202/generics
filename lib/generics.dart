import 'dart:developer' as dev;

/// Signature callback for decoding value of row.
///
/// example:
/// ```dart
/// decoder: (Map<String,dynamic> value)=>UserTableSchema.fromJson(value);
/// ```
///
/// See also:
///   - [Encoder]
typedef Decoder<T extends TableDefinition, S> = T Function(S);

/// Signature callback for encoding value of row.
///
/// example:
/// ```dart
/// encoder: (UserEntity user)=>user.toJson();
/// ```
///
/// See also:
///   - [Decoder]
typedef Encoder<S, T extends TableDefinition> = S Function(T);

/// A signature callback for predicting join, base on the column names.
///
/// Here [T] and [S] both represent the defined column of current table and
/// targeted table on which join operation would be done.
typedef JoinPredicate<T extends Enum, S extends Enum> = (T, S) Function();

/// A signature callback for predicting the targeted row for operation.
///
/// Here [TargetedColumn] is the column of schema which will be considered when
///  doing prediction and [TargetedValue] is expected value to be of
/// [TargetedColumn].
typedef ColumnTargetPredicate<TargetedColumn extends Enum, TargetedValue>
    = (TargetedColumn, TargetedValue) Function();

/// A signature callback for mutation of any row.
///
/// Here [T] represent the row of the table.
typedef Mutator<T extends TableDefinition> = T Function(T);

/// Exception for invalid operation.
class InvalidOperationException implements Exception {
  final String message;
  const InvalidOperationException(this.message);

  @override
  String toString() => message;
}

/// Represents the base table, with schema as [T].
abstract class TableDefinition<T extends Enum> {
  const TableDefinition();
}

/// Represents the table.
///
/// example:
///
/// ```dart
///   final Table<User, UserColumnNames> userTable = Table<User, UserColumnNames>(
///     name: 'user',
///     decoder: (value) => User.fromJson(value),
///     encoder: (value) => value.toJson(),
///   );
/// ```
///
class Table<T extends TableDefinition<Type>, Type extends Enum> {
  final String name;
  final Decoder<T, dynamic> decoder;
  final Encoder<dynamic, T> encoder;
  final bool joined;

  const Table({
    required this.name,
    required this.decoder,
    required this.encoder,
  }) : joined = false;

  const Table._joined({
    required this.name,
    required this.decoder,
    required this.encoder,
  }) : joined = true;

  /// Joins this table with [other] based on the join [predicate] condition.
  Table<TD, J>
      join<J extends Enum, T2 extends Enum, TD extends TableDefinition<J>>({
    required Table<TableDefinition<T2>, T2> other,
    required JoinPredicate<Type, T2> predicate,
    required Decoder<TD, dynamic> decoder,
    required Encoder<dynamic, TD> encoder,
  }) {
    final tableName = 'joined $name on ${other.name}';
    dev.log('Created tabled: $tableName');
    return Table<TD, J>._joined(
      name: tableName,
      decoder: decoder,
      encoder: encoder,
    );
  }

  Future<void> drop() async {
    dev.log('Dropped table $name');
  }

  Future<void> addRow(T value) async {
    if (joined) {
      throw InvalidOperationException(
        'Row can not be inserted in joined table',
      );
    }
    final valueToBeInserted = encoder(value);
    dev.log('Inserted value: $valueToBeInserted in to table $name');
  }

  Future<void> deleteRow<ValueType>(
      ColumnTargetPredicate<Type, ValueType> predicate) async {
    final targetCondition = predicate();
    dev.log(
      'Deleted row from table where column ${targetCondition.$1} and value ${targetCondition.$2}',
    );
  }

  Future<void> updateTable<ValueType>(
      ColumnTargetPredicate<Type, ValueType> predicate,
      Mutator<T> mutator) async {
    if (joined) {
      throw InvalidOperationException(
        'Row can updated in joined table',
      );
    }
    final targetCondition = predicate();
    dev.log(
      'Retrieved row from db where column name ${targetCondition.$1} and value ${targetCondition.$2}',
    );
  }

  Future<QueryResult<T, Type>> query(Query<T, Type> query) async {
    throw UnimplementedError();
  }
}

class Query<T extends TableDefinition<Type>, Type extends Enum> {}

class QueryResult<T extends TableDefinition<Type>, Type extends Enum> {
  final List<TableDefinition<Type>> result;
  const QueryResult(this.result);
}
