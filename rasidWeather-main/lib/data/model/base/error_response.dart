class ErrorResponse {
  ErrorResponse({
    required this.success,
    required this.message,
  });

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        success: json['success'] as bool,
        message: json['message'].toString(),
      );

  bool success;
  String message;

  Map<String, dynamic> toJson() => <String, dynamic>{
        'success': success,
        'message': message,
      };
}
