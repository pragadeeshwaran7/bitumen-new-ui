class ApiResponse<T> {
  final bool success;
  final String? message;
  final T? data;
  final String? error;
  
  ApiResponse._({
    required this.success,
    this.message,
    this.data,
    this.error,
  });
  
  factory ApiResponse.success(T data, {String? message}) {
    return ApiResponse._(
      success: true,
      data: data,
      message: message,
    );
  }
  
  factory ApiResponse.error(String error) {
    return ApiResponse._(
      success: false,
      error: error,
    );
  }
  
  @override
  String toString() {
    if (success) {
      return 'Success: $data${message != null ? ' - $message' : ''}';
    } else {
      return 'Error: $error';
    }
  }
}
