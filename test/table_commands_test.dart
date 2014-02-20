part of rethinkdb_test;

Future table_command_tests(conn) {
  Completer completer = new Completer();
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
      _test(r.tableCreate("test_table",{"primary_key": "testPk", "cache_size" : 1024}), (response) => expect(response["created"], 1.0));
    });

    test("must list table", () {
      _test(r.tableList(), (response) {
        expect(response.length, 1);
        expect(response[0], "test_table");
      });
    });

    test("must add data", () {
      _test(r.table('test_table').insert([{'test key':'test_val'}]), (response) => expect(response["inserted"], 1.0));
    });
    test("must count data", () {
      _test(r.table('test_table').count(), (response) => expect(response, 1));
    });
    test("must create index", () {
      _test(r.table("test_table").indexCreate("myindex"), (response) => expect(response["created"], 1.0));
    });

    test("must list index", () {
      _test(r.table("test_table").indexList(), (response) {
        expect(response.length, 1);
        expect(response[0], "myindex");
      });
    });

    test("must drop index", () {
      _test(r.table("test_table").indexDrop("myindex"), (response) => expect(response["dropped"], 1.0));
    });

    test("must drop table", () {
      _test(r.tableDrop("test_table"), (response) => expect(response["dropped"], 1.0));
    });

    test("must complete tests", () {
      completer.complete(conn);
    });
  });

  return completer.future;
}