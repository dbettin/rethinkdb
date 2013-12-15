import 'lib/rethinkdb.dart' as r;
import 'dart:async';

main() {
  /**start the connection that returns a future
   * You may specify the database, host, port, and authkey if you wish:
   * connect(db: "Website_DB", port: 8000, host: "127.0.0.1", authKey: "some key").then(...)
   */
  r.connect(db: "app_db",port: 28015).then((c)=>exampleCommands(c));
  DateTime now =new DateTime.now();
  print(now);
}
Future exampleCommands(conn)
{
  /**dbCreate() takes a string for the name of the database to be created and returns a CreatedResponse**/
  //dbCreate("app_db").run(conn).then((response)=>print(response));


  print(conn);
  /**the use method of the connection can change the working database**/
  conn.use('app_db');
  /**addListener allows you to listen to changes in connection state.  'on' can be used as well.**/
  conn.addListener('close',()=>print("connection closed"));
  conn.on('connect',()=>print("connection opened"));
  conn.addListener('error',(err)=>print("Error occurred: ${err}"));
  //r.table("Users").indexCreate("Name").run(conn).then((response)=>print(response));
  r.table('Users').getAll("Roblol",{"index":"Name"})('Name').run(conn).then((response)=>print(response));

  //conn.reconnect(); //(runs conn.close() and then connect())
  //r.table("Users").run(conn).then((response)=>print(response));
  //r.table("Users").get("45c743ef-ff5e-4987-b797-4960bc6fe10b").update({"Age":r.row("Age").add(1)}).run(conn).then((response)=>print(response));
  //r.table('Users').update((row)=>{"Age":row('Age').sub(45)}).run(conn).then((response)=>print(response));
  //conn.reconnect({"noreplyWait":false}).then((response)=>print(response));
  //r.nativeTime(new DateTime.now()).run(conn).then((response)=>print(response));
  //r.time().run(conn).then((response)=>print(response));
  //r.tableList().run(conn).then((response)=>print(response));
  //r.table("Users").update((row)=>{"Age":row["Age"].add(1)}).run(conn).then((response)=>print(response));
  //dbList().run(conn).then((response)=>print(response));
  //db("test").tableCreate("Feet").run(conn).then((response)=>print(response));
  //table("Users").indexStatus(["Name","occupation"]).run(conn).then((response)=>print(response));
  //TODO fix 'do'
  //doIt(table('marvel').get('IronMan'),lambda ironman: ironman['name']);
  //doIt("bee",4,"dags").run(conn).then((response)=>print(response));
  //table("Users").insert({"Name":"Tim"}).run(conn).then((response)=>print(response));
  //r.db("app_db").tableCreate("Users2").run(conn).then((response)=>print(response));
  //r.db("app_db").tableList().run(conn).then((response)=>print(response));
  //table("Users").filter(table("Users")).run(conn).then((response)=>print(response));
  //table("Users").getAll("Name")["Age"].run(conn).then((response)=>print(response));
  //expr(3).le(2).run(conn).then((response)=>print(response));
  //row("dogs").run(conn).then((response)=>print(response));
  //table("Users").run(conn).then((response)=>print(response));
  //table("Users",{'use_outdated':true}).run(conn).then((response)=>print(response));
  //dbCreate("farts").run(conn).then((response)=>print(response));
  //dbDrop("farts").run(conn).then((response)=>print(response));
  //dbList().run(conn).then((response)=>print(response));
  //tableCreate("Farts2",{"primary_key":"beans"}).run(conn).then((response)=>print(response));
  //tableDrop("Farts1").run(conn).then((response)=>print(response));
  //tableDrop("Farts2").run(conn).then((response)=>print(response));
  //tableList().run(conn).then((response)=>print(response));
  //branch("head","feet","legs").run(conn).then((response)=>print(response));
  //tableList().count().run(conn).then((response)=>print(response));
  //table('Users').groupBy(['age','location'],avg('Age')).run(conn).then((response)=>print(response));
  //table('Users').orderBy(asc('user_id')).run(conn).then((response)=>print(response));
  //expr('thing').eq('thing2').run(conn).then((response)=>print(response));
  //expr('thing').ne('thing2').run(conn).then((response)=>print(response));
  //expr(["a","cool"]).add(["dog"]).run(conn).then((response)=>print(response));
  //expr(4).sub(23).run(conn).then((response)=>print(response));
  //expr([4,5]).mul(2).run(conn).then((response)=>print(response));
  //expr(7).div(2).run(conn).then((response)=>print(response));
  //expr(7).mod(2).run(conn).then((response)=>print(response));
  //table("Users").info().run(conn).then((response)=>print(response));
  //time(1986, 11, 3, 'M').run(conn).then((response)=>print(response));
  //ISO8601('1986-11-03T08:30:00-07:00','Z').run(conn).then((response)=>print(response));
  //epochTime(531360000).run(conn).then((response)=>print(response));
  //now().run(conn).then((response)=>print(response));
  //now().inTimezone('-08:00').run(conn).then((response)=>print(response));
  //table("Users").info().run(conn).then((response)=>print(response));
  //table("Users").indexCreate("aAge").run(conn).then((response)=>print(response));
  //table("Users").info().run(conn).then((response)=>print(response));
  //table("Users").info().run(conn).then((response)=>print(response));
  //table("Users").indexDrop("aAge").run(conn).then((response)=>print(response));
  //table("Users").info().run(conn).then((response)=>print(response));

  //TODO fix indexStatus and indexWait
  //table("Users").indexStatus("Name").run(conn).then((response)=>print(response));
  //table("Users").indexWait().run(conn).then((response)=>print(response));

  //table("Users").insert({"Name":"Face","occupation":"party"},{"durability": 'soft', "return_vals": true, "upsert":true}).run(conn).then((response)=>print(response));



}

