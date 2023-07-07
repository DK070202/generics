import 'dart:developer' as dev;

typedef Decoder<T extends TableDefinition, S> = T Function(S);

typedef Encoder<S, T extends TableDefinition> = S Function(T);

typedef JoinPredicate<T extends Value, S extends Value> = (T, S) Function();

typedef ColumnTargetPredicate<TargetedColumn extends Value, TargetedValue>
    = (TargetedColumn, TargetedValue) Function();

typedef Mutator<T extends TableDefinition> = T Function(T);

class InvalidOperationException implements Exception {
  final String message;
  const InvalidOperationException(this.message);

  @override
  String toString() => message;
}

class Value<T extends Enum> {
  const Value(this.name);
  final String name;
}

class TableDefinition<T extends Value> {
  const TableDefinition();
}

class Table<T extends TableDefinition<Type>, Type extends Value> {
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

  Table<TD, J>
      join<J extends Value, T2 extends Value, TD extends TableDefinition<J>>({
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

class Query<T extends TableDefinition<Type>, Type extends Value> {}

class QueryResult<T extends TableDefinition<Type>, Type extends Value> {
  final List<TableDefinition<Type>> result;
  const QueryResult(this.result);
}
