class FirebaseOnError implements Exception {
  final String message;
  FirebaseOnError(this.message);

  @override
  String toString() {
    return message;
  }
}
