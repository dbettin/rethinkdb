part of rethinkdb;

class CreatedResponse {
  bool created;
  CreatedResponse(Map input){
    if (input["created"].val.rNum == 1) {
      created = true;
    }
  }
}


class DroppedResponse {
  bool dropped;
  DroppedResponse(Map input){
    if (input["dropped"].val.rNum == 1) {
      dropped = true;
    }
  }
}

class InsertedResponse {
  bool inserted;
  InsertedResponse(Map input) {
  if(input["inserted"].val.rNum > 0) {
    inserted = true;
  }
  }
}
