import 'lib/rethinkdb_driver.dart' as r;
import 'dart:async';

main() {
  /**start the connection that returns a future
* You may specify the database, host, port, and authkey if you wish:
* connect(db: "Website_DB", port: 8000, host: "127.0.0.1", authKey: "some key").then(...)
*/
  r.connect(db: "test",port: 28015).then((connection)=>exampleCommands(connection));
}
Future exampleCommands(conn)
{

  /**dbCreate() takes a string for the name of the database to be created and returns a CreatedResponse**/

  //r.dbCreate("app_db").run(conn).then((response)=>print(response));

  //r.dbCreate("bad_db").run(conn).then((response)=>print(response));



  /**dbList() lists the databases in the system**/

  //r.dbList().run(conn).then((response)=>print(response));



  /**dbDrop() drops the speficied database**/

  //r.dbDrop("bad_db").run(conn).then((response)=>print(response));



  /**use() changes the default database on the connection**/
  //conn.use("app_db");



  /** noreplyWait() waits for any queries with the noreply option to run**/

  //conn.noreplyWait();



  /**addListener allows you to listen to changes in connection state. 'on' can be used as well.**/

  //conn.addListener("error",(err)=>print(err));

  //conn.on("close",()=>print("Connection Closed!"));



  /**table() selects a table for the given database**/

  //r.table("animals").run(conn).then((response)=>print(response));

  //r.db("test").table("users").run(conn).then((response)=>print(response));


  /**table can be chained with other commands to select data**/
  //r.table("animals").get("cheetah").pluck("number_in_wild").run(conn).then((response)=>print(response));



  /**for more information check out the rethinkdb javascript API.**/

}