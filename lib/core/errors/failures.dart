abstract class Failure {
  final String message;
  final dynamic details;

  const Failure(this.message, [this.details]);

  @override
  String toString() => '$runtimeType: $message';
}

class SSHFailure extends Failure {
  const SSHFailure(super.message, [super.details]);
}

class AuthFailure extends Failure {
  const AuthFailure(super.message, [super.details]);
}

class StorageFailure extends Failure {
  const StorageFailure(super.message, [super.details]);
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message, [super.details]);
}
