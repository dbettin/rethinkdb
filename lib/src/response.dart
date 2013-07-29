part of rethinkdb;

class CreatedResponse {
  bool created;
  CreatedResponse(Map input){
    if (input["created"] == 1) {
      created = true;
    }
  }
}


class DroppedResponse {
  bool dropped;
  DroppedResponse(Map input){
    if (input["dropped"] == 1) {
      dropped = true;
    }
  }
}

