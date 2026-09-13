class AppException implements Exception {
  final String message;
  final dynamic details;

  AppException(this.message, [this.details]);

  @override
  String toString() => 'AppException: $message ${details != null ? "($details)" : ""}';
}

class SSHConnectionException extends AppException {
  SSHConnectionException(super.message, [super.details]);
}

class SSHAuthenticationException extends AppException {
  SSHAuthenticationException(super.message, [super.details]);
}

class SSHExecutionException extends AppException {
  final int? exitCode;
  SSHExecutionException(String message, {this.exitCode, dynamic details})
      : super(message, details);
}

class StorageException extends AppException {
  StorageException(super.message, [super.details]);
}

class DatabaseException extends AppException {
  DatabaseException(super.message, [super.details]);
}
