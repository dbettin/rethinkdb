part of rethinkdb;

class RqlException implements Exception {
  String message;
  Exception innerException;
  RqlException(this.message, [this.innerException]);
}

class RqlConnectionException extends RqlException {
  RqlConnectionException(String message, [Exception innerException]) : super(message, innerException);
}

class RqlQueryException extends RqlException {
  RqlQueryException(String message, [Exception innerException]) : super(message, innerException);
}

class RqlDriverException extends RqlException {
  RqlDriverException(String message, [Exception innerException]) : super(message, innerException);
}
