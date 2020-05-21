class APIResponse<T> {
  T data;
  bool error;
  String errorMessage;
  int statusCode;

  APIResponse({this.data, this.errorMessage,this.error = false, this.statusCode});
}