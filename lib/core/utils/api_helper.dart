import 'dart:async';
// http dependency was used previously; ApiHelper is now transport-agnostic

class ApiHelper {
  static const int maxRetries = 3;
  static const Duration initialTimeout = Duration(seconds: 10);
  static const Duration retryDelay = Duration(seconds: 2);

  /// Makes an HTTP request with retry logic
  static Future<dynamic> retryableRequest(
    Future<dynamic> Function() request, {
    int maxAttempts = maxRetries,
    Duration timeout = initialTimeout,
  }) async {
    int attempts = 0;
    dynamic response;
    late Object lastError;

    while (attempts < maxAttempts) {
      attempts++;
      try {
        response = await request().timeout(timeout);

        // Try to read statusCode where available
        final statusCode = response?.statusCode is int ? response.statusCode as int : null;

        // If response is successful, return it
        if (statusCode != null && statusCode >= 200 && statusCode < 300) {
          return response;
        }

        // If it's a server error (5xx), retry
        if (statusCode != null && statusCode >= 500) {
          if (attempts < maxAttempts) {
            await Future.delayed(retryDelay * attempts);
            continue;
          }
        }

        // For other status codes or if statusCode missing, return the response without retrying
        return response;
      } catch (e) {
        lastError = e;
        // Only retry on timeout or network errors
        if (e is TimeoutException || e.toString().contains('SocketException')) {
          if (attempts < maxAttempts) {
            await Future.delayed(retryDelay * attempts);
            continue;
          }
        }
        rethrow;
      }
    }

    // If we get here, all retries failed
    throw lastError;
  }

  /// Checks if the error is retryable
  static bool isRetryableError(Object error) {
    return error is TimeoutException || 
           error.toString().contains('SocketException') ||
           error.toString().contains('Connection refused');
  }

  /// Checks if the status code indicates a retryable error
  static bool isRetryableStatusCode(int statusCode) {
    return statusCode >= 500 || statusCode == 429; // Server errors or rate limiting
  }
}
