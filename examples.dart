import 'lib/rethinkdb.dart' as r;
import 'dart:async';

main() {
  /**start the connection that returns a future
   * You may specify the database, host, port, and authkey if you wish:
   * connect(db: "Website_DB", port: 8000, host: "127.0.0.1", authKey: "some key").then(...)
   */
  r.connect(db: "app_db",port: 28015).then((connection)=>exampleCommands(connection));
}
Future exampleCommands(conn)
{
  /**dbCreate() takes a string for the name of the database to be created and returns a CreatedResponse**/
  //r.dbCreate("app_db").run(conn).then((response)=>print(response));
  r.dbDrop("testdb").run(conn).then((response)=>print(response));
  /**the use method of the connection can change the working database**/
  r.dbList().run(conn).then((response)=>print(response));
  //r.dbList().run(conn).then((response)=>print(response[0]));
  //r.table('Users').count().run(conn).then((response)=>print(response));
  //r.db("testdb").tableList().run(conn).then((response)=>print(response));
  //r.db("testdb").table("test_table").indexList().run(conn).then((response)=>print(response));
  //r.dbCreate("testdb").run(conn).then((response)=>print(response));
  /**addListener allows you to listen to changes in connection state.  'on' can be used as well.**/

  /**for more information check out the rethinkdb javascript API.**/

}

