part of rethinkdb_test;

Future db_command_tests(conn) {
  Completer completer = new Completer();

  /// Database command tests

    _test(runner, matcher) {
      runner.run(conn).then(expectAsync1((response) {
        matcher(response);
      }));
    }

    _errorTest(runner, matcher) {
      expect(runner.run(conn), throwsA(matcher));
    }

    test("must create database", () {
      _test(r.dbCreate("testdb"), (response) => expect(response.created, isTrue));
    });

    test("must throw exception when db exists", () {
      _errorTest(r.dbCreate("testdb"), predicate((x) => x.message == "Database `testdb` already exists."));
    });

    test("must list db", () {
      _test(r.dbList(), (response) {
        expect(response.length, 1);
        expect(response[0].rStr, "testdb");
      });
    });

    test("must drop db", () {
      _test(r.dbDrop("testdb"), (response) => expect(response.dropped, isTrue));
    });

    test("must complete tests", () {
      completer.complete(conn);
    });


  return completer.future;
}