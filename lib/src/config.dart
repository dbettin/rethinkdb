part of rethinkdb;

class ServerConfig{
  String host = '127.0.0.1';
  int port = 27017;
  String userName;
  String password;
  String db = "test";
  String authKey="";
  ServerConfig([this.host='127.0.0.1', this.port=27017,this.db="test",authKey=""]);
}