import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

// http dependency was used previously; ApiHelper is transport-agnostic and
// provides helpers for retrying requests and normalizing responses from
// either `http` or `dio` clients.

class ApiHelper {
  static const int maxRetries = 3;
  static const Duration initialTimeout = Duration(seconds: 10);
  static const Duration retryDelay = Duration(seconds: 2);

  /// Create a configured Dio instance (local callers can still create their
  /// own if they need different options).
  static Dio createDio() {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    dio.options.headers = {'Accept': 'application/json'};
    return dio;
  }

  /// Makes an HTTP request with retry logic. The request closure may return
  /// either an `http.Response` or a `dio.Response` — callers should use
  /// [normalizeResponse] to interpret the result.
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

  /// Normalize a response returned by either the `http` package or `dio`.
  /// Returns a map with keys: `statusCode`, `data`, `text`.
  static Map<String, dynamic> normalizeResponse(dynamic resp) {
    final result = <String, dynamic>{'statusCode': -1, 'data': null, 'text': ''};
    if (resp == null) return result;

    try {
      if (resp is Response) {
        result['statusCode'] = resp.statusCode ?? -1;
        result['data'] = resp.data;
        if (resp.data is String) {
          result['text'] = resp.data ?? '';
        } else {
          result['text'] = jsonEncode(resp.data ?? '');
        }
        return result;
      }
    } catch (_) {}

    try {
      // http.Response-like
      if (resp?.body != null) {
        result['statusCode'] = resp.statusCode ?? -1;
        result['text'] = resp.body ?? '';
        try {
          result['data'] = jsonDecode(resp.body ?? '');
        } catch (_) {
          result['data'] = null;
        }
        return result;
      }
    } catch (_) {}

    try {
      result['text'] = resp.toString();
      return result;
    } catch (_) {
      return result;
    }
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

