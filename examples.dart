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

  /**the use method of the connection can change the working database**/
  conn.use('app_db');

  /**addListener allows you to listen to changes in connection state.  'on' can be used as well.**/
  conn.addListener('close',()=>print("connection closed"));
  conn.on('connect',()=>print("connection opened"));
  conn.addListener('error',(err)=>print("Error occurred: ${err}"));

  /**for more information check out the rethinkdb javascript API.**/

}

