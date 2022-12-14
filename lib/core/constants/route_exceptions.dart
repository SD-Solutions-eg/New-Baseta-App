class RouteExceptions implements Exception {
  final String message;

  RouteExceptions(this.message);

  @override
  String toString() {
    return message;
  }
}
