
class ServiceResponse<T> {
  final bool success;
  final T? data;
  final String? error;

  ServiceResponse({required this.success, this.data, this.error});
}
