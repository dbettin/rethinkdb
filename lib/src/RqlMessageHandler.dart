part of rethinkdb;

class RqlMessageHandler {

  void handleData(var1, var2){}
  void handleDone(var1){}
  StreamTransformer<List<int>, _RqlQuery> get transformer => new StreamTransformer<List<int>, _RqlQuery>.fromHandlers(
      handleData: handleData,handleDone: handleDone);
}