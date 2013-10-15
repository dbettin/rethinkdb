import 'lib/rethinkdb.dart';
import 'dart:async';

main() {
  /**start the connection that returns a future
   * You may specify the database, host, port, and authkey if you wish:
   * connect(db: "Website_DB", port: 8000, host: "127.0.0.1", authKey: "some key").then(...)
   */
  connect().then((connection)=>exampleCommands(connection));




}
Future exampleCommands(conn)
{
  //dbCreate() takes a string for the name of the database to be created and returns a CreatedResponse
  //dbCreate("app_db").run(conn).then((response)=>print(response));

  //the use method of the connection can change the working database
  conn.use("app_db");

  //tableCreate() accepts a string for the name of the table to be created and returns a CreatedResponse
  tableCreate("Users",{'primary_key':'Name'}).run(conn).then((response)=>print(response));

  //tableList() returns a list of table names
  //tableList().run(conn).then((response)=>print(response));

  //indexCreate() accepts a string for the name of a secondary index to create and returns a CreatedResponse
  //table("Users").indexCreate("Name").run(conn).then((response)=>print(response));

  //indexList() returns a list of indexes for the table
  table("Users").indexList().run(conn).then((response)=>print(response));

  //insert accepts a list of Maps and returns an InsertedResponse
  table("Users").insert([{"Name":"Jane Doe","Age":28},{"Name":"Jon Doe","Age":22}]).run(conn).then((response)=>print(response));

  //count() returns the number of objects in a table
  //table("Users").count().run(conn).then((response)=>print(response));

  //tableDrop() accepts a string for the name of the table to be dropped and returns a DroppedResponse
  //tableDrop("Users").run(conn).then((response)=>print(response));

  //dbDrop() accepts a string for the name of the database to be dropped  and returns a DroppedResponse
  //dbDrop("app_db").run(conn).then((response)=>print(response));

  //dbList() returns a list of database names
  //dbList().run(conn).then((response)=>print(response));

}
