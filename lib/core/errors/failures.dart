/// Base failure class for repository-level errors.
abstract class Failure {
  const Failure(this.message);
  final String message;

  @override
  String toString() => 'Failure($message)';
}

class StorageFailure extends Failure {
  const StorageFailure(super.message);
}

class AudioFailure extends Failure {
  const AudioFailure(super.message);
}
