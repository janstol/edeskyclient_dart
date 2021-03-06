class EdeskyClientException implements Exception {
  final String message;

  final int? statusCode;

  EdeskyClientException(this.message, [this.statusCode]);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is EdeskyClientException &&
            message == other.message &&
            statusCode == other.statusCode;
  }

  @override
  int get hashCode => message.hashCode ^ statusCode.hashCode;

  @override
  String toString() {
    return 'EdeskyClientException: $message, $statusCode';
  }
}
