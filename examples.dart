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
  /**dbCreate() takes a string for the name of the database to be created and returns a CreatedResponse**/
  //dbCreate("app_db").run(conn).then((response)=>print(response));



  /**the use method of the connection can change the working database**/
  conn.use('app_db');

  /**addListener allows you to listen to changes in connection state.  'on' can be used as well.**/
  conn.addListener('close',()=>print("connection closed"));
  conn.on('connect',()=>print("connection opened"));
  conn.addListener('error',(err)=>print("Error occurred: ${err}"));
  //conn.reconnect(); (runs conn.close() and then connect())


  /**tableCreate() accepts a string for the name of the table to be created and returns a map
     options include primary key, durability, datacenter, and cache size**/
  //tableCreate("TableName",{'primary_key':'id','durability':'soft','cache_size':1073741824,'datacenter':'beans'}).run(conn).then((response)=>print(response));
  //tableCreate("Users",{'primary_key':'user_id'}).run(conn).then((response)=>print(response));



  /**tableList() returns a list of table names**/
  //tableList().run(conn).then((response)=>print(response));



  /**indexCreate() accepts a string for the name of a secondary index to create and returns a map**/
  //table("Users").indexCreate("Name").run(conn).then((response)=>print(response));



  /**indexList() returns a list of secondary indexes for the table**/
  //table("Users").indexList().run(conn).then((response)=>print(response));




  /**insert accepts either a Map or List of Maps and returns a Map, additional options can be added for durability, return_vals, and upsert**/
  //table("Users").insert([{"Name":"Jane Doe","Age":28, 'user_id':1},{"Name":"Jon Doe","Age":24,"user_id":2},{"Name":"Jon Doe","Age":24,"user_id":3},{"Name":"Jon Doe","Age":24,"user_id":4}]).run(conn).then((response)=>print(response));
  //table("Users").insert({"a test":"item"},{'return_vals':true}).run(conn).then((response)=>print(response));
  //table("Users").insert({"Name":"Jane R. Doe","Age":28,"user_id":127}, {"upsert":true,"return_vals":true}).run(conn).then((response)=>print(response));


  /**Update can be called on a table or selection from a table, only single items may return values**/
  //table("Users").get(127).update({"Name":"Jennifer"},{'return_vals':true}).run(conn).then((response)=>print(response));
  //table("Users").update({"Name":"Pete"}).run(conn).then((response)=>print(response));

  /**updating does not support functions yet**/
  //TODO
  //table("Users").update({"Age" : r.row('Age').add(1) }, {"durability": 'soft'}).run(conn).then((response) => print(response));

  /**Replace can be called on a table or selection from a table, only single items may return values**/
  //table("Users").get(127).replace({"user_id" : 127, "Name" : "Jane"},{"return_vals":true}).run(conn).then((response)=>print(response));


  /**Delete can be called on a table or selection from a table, only single items may return values, options are 'durability' and 'return_vals'**/
  //table("Users").get(127).delete({"return_vals":true}).run(conn).then((response)=>print(response));
  //table("Users").delete().run(conn).then((response)=>print(response));


  /**get accepts a primary key and returns the object**/
  //table("Users").get(127).run(conn).then((response)=>print(response));

  /**getAll accepts a primary or secondary key, which is not guaranteed to be unique, either a single key value or list of values may be passed**/
  //table("Users").getAll("Jon Doe",{"index":"Name"}).run(conn).then((response)=>print(response));
  //table("Users").getAll(["Jon Doe", "Jane Doe"], {"index" : "Name"}).run(conn).then((response)=>print(response));

  /**between gets two documents between two keys.  Accepts options arguments "index","left_bound":open/closed,"right_bound":open.closed
   **by default, left_bound is closed, meaning it will return a records greater than OR EQUAL TO the left key
     and right_bound is opened, meaning it will return records less than BUT NOT EQUAL TO the right key**/
  //table("Users").between(1,3,{"left_bound":"open","right_bound":"open","index":"user_id"}).run(conn).then((response)=>print(response));

  /**you can run a query on a table, it returns a list of all documents in the table**/
  //table("Users").run(conn).then((response)=>print(response));

  /**filter can be called on a sequence, selection or field and returns the same.**/
  //table("Users").filter({"Name":"Jon Doe"}).run(conn).then((response)=>print(response));
  //table("Users").getAll("Jon Doe", {"index":"Name"}).filter({"user_id":21}).run(conn).then((response)=>print(response));

  /**count() returns the number of objects in a table**/
  //table("Users").count().run(conn).then((response)=>print(response));


  /**tableDrop() accepts a string for the name of the table to be dropped and returns a map**/
  //tableDrop("Users").run(conn).then((response)=>print(response));


  /**dbDrop() accepts a string for the name of the database to be dropped  and returns a map**/
  //dbDrop("app_db").run(conn).then((response)=>print(response));



  /**dbList() returns a list of database names**/
  //dbList().run(conn).then((response)=>print(response);conn.close(););


}

