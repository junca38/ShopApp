class HttpException implements Exception {
  final String errorMsg;
  HttpException({this.errorMsg});
  @override
  String toString() {
    return errorMsg;
    //return super.toString();
  }
}
