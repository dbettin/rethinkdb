library rethinkdb;

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'src/generated/QL2.pb.dart';
part 'src/connection.dart';
part 'src/exceptions.dart';
part 'src/term.dart';
part 'src/datum.dart';
part 'src/query.dart';
part 'src/response.dart';
part 'src/options.dart';



// Connection Management
Future<Connection> connect({String db, String host: Connection.DEFAULT_HOST, num port: Connection.DEFAULT_PORT,
  String authKey: Connection.DEFAULT_AUTH_KEY}) => Connection.connect(db, host, port, authKey);


// Database Management Queries
RqlQueryRunner dbCreate(String dbName) => new _RqlDBCreate(dbName);
RqlQueryRunner dbDrop(String dbName) => new _RqlDBDrop(dbName);
RqlQueryRunner dbList() => new _RqlDBList();

// Table Management Queries
RqlQueryRunner tableList() => new _RqlTableList();
RqlQueryRunner tableCreate(String tableName, [TableCreateOptions options]) => new _RqlTableCreate(tableName, options);
RqlQueryRunner tableDrop(String tableName) => new _RqlTableDrop(tableName);
RqlTable table(String tableName) => new RqlTable(tableName);



