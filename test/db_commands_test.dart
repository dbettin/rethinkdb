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
      _test(r.dbCreate("testdb"), (response) => expect(response["created"], 1.0));
    });
    //TODO fix these tests

    test("must list db", () {
      _test(r.dbList(), (response) {
        expect(response.length, 1);

      });
    });

    test("must drop db", () {
      _test(r.dbDrop("testdb"), (response) => expect(response["dropped"], 1));
    });

    test("must complete tests", () {
      completer.complete(conn);
    });


  return completer.future;
}