class ResponseModel {

  ResponseModel(this._message, this._isSuccess);
  final String _message;
  final bool _isSuccess;

  bool get isSuccess => _isSuccess;
  String get message => _message;
}
