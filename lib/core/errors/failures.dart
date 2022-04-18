abstract class Failure {
  final String message;

  Failure(this.message);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Нет доступа к сети');
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}
