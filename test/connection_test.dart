part of rethinkdb_test;

connection_tests() {

  group("connection-tests:", () {
    test("must successfully connect to db", () {
      connect(authKey: "test", db: "testdb").then(expectAsync1((connection) {
        expect(connection, isNotNull);
        connection.close();
      }));
    });

    test("Must not have a response when no reply is true", () {

      connect(authKey: "test").then(expectAsync1((connection) {
        dbList().run(connection, {"noReply":true}).then((response) {
          expect(response, isNull);
          connection.close();
        });
      }));
    });

    test("must not connect to db if given wrong port", () {
      expect(connect(authKey: "test", port: 28016, db: "testdb"), throwsA(new isInstanceOf<RqlConnectionException>()));
    });

    test("must not connect to db if given wrong auth key", () {
        expect(connect(authKey: "asdasd", db: "testdb"), throwsA(new isInstanceOf<RqlConnectionException>()));
    });

    test("must not connect to db if not given auth key", () {
      expect(connect(), throwsA(new isInstanceOf<RqlConnectionException>()));
    });
  });


}