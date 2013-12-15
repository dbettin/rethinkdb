library rethinkdb_test;

import 'dart:async';
import 'package:unittest/unittest.dart';
import 'package:rethinkdb/rethinkdb.dart' as r;

part 'connection_test.dart';
part 'db_commands_test.dart';
part 'table_commands_test.dart';

main() {

  // connection_tests();
  r.connect(authKey: "", db: "testdb")
    .then((conn) => db_command_tests(conn))
    .then((conn) => setup_db(conn))
    .then((conn) => table_command_tests(conn))
    .then((conn) => drop_db(conn))
    .then((conn) => conn.close());
}

Future setup_db(conn) {
  // must disable db command tests (I believe it is a bug within unitest)
  testCases.forEach((tc) => tc.enabled = false);

  Completer completer = new Completer();
  r.dbCreate("testdb").run(conn)
    .then((response) => completer.complete(conn));
  return completer.future;
}

Future drop_db(conn) {
  Completer completer = new Completer();
  r.dbDrop("testdb").run(conn)
    .then((response) => completer.complete(conn));
  return completer.future;
}