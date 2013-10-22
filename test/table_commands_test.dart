part of rethinkdb_test;

Future table_command_tests(conn) {
  Completer<Connection> completer = new Completer();
  group("table commands:", () {
    _test(runner, matcher) {
      runner.run(conn).then(expectAsync1((response) {
        matcher(response);
      }));
    }

    _errorTest(runner, matcher) {
      expect(runner.run(conn), throwsA(matcher));
    }

    test("must create table", () {
      _test(tableCreate("test_table",{"primaryKey": "testPk", "cacheSize" : 1024}), (response) => expect(response.created, isTrue));
    });

    test("must list table", () {
      _test(tableList(), (response) {
        expect(response.length, 1);
        expect(response[0].rStr, "test_table");
      });
    });
    test("must add data", () {
      _test(table('test_table').insert([{'test key':'test_val'}]), (response) => expect(response.inserted, isTrue));
    });
    test("must count data", () {
      _test(table('test_table').count(), (response) => expect(response, 1));
    });
    test("must create index", () {
      _test(table("test_table").indexCreate("myindex"), (response) => expect(response.created, isTrue));
    });

    test("must list index", () {
      _test(table("test_table").indexList(), (response) {
        expect(response.length, 1);
        expect(response[0].rStr, "myindex");
      });
    });

    test("must drop index", () {
      _test(table("test_table").indexDrop("myindex"), (response) => expect(response.dropped, isTrue));
    });

    test("must drop table", () {
      _test(tableDrop("test_table"), (response) => expect(response.dropped, isTrue));
    });

    test("must complete tests", () {
      completer.complete(conn);
    });
  });

  return completer.future;
}