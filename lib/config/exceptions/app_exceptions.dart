class AppException implements Exception {
  final String? _message;
  final String? _prefix;

  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_prefix$_message";
  }
}

// No Internet Exception
class NoInternetException extends AppException {
  NoInternetException([String? message])
      : super(message, "No Internet Connection: ");
}

// Unauthorized Exception
class UnauthorizedException extends AppException {
  UnauthorizedException([String? message])
      : super(message, "Unauthorized Request: ");
}

// Request Timeout Exception
class RequestTimeoutException extends AppException {
  RequestTimeoutException([String? message])
      : super(message, "Request Timeout: ");
}

// Fetch Data Exception
class FetchDataException extends AppException {
  FetchDataException([String? message])
      : super(message, "Error Fetching Data: ");
}

// Bad Request Exception
class BadRequestException extends AppException {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");
}

// Resource Not Found Exception
class NotFoundException extends AppException {
  NotFoundException([String? message]) : super(message, "Resource Not Found: ");
}

class WrongCredentialsException extends AppException {
  WrongCredentialsException([String? message])
      : super(message, "User name or password is incorrect");
}

// Internal Server Error Exception
class InternalServerErrorException extends AppException {
  InternalServerErrorException([String? message])
      : super(message, "Internal Server Error: ");
}

// Service Unavailable Exception
class ServiceUnavailableException extends AppException {
  ServiceUnavailableException([String? message])
      : super(message, "Service Unavailable: ");
}

// Invalid Input Exception
class InvalidInputException extends AppException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

// Forbidden Exception
class ForbiddenException extends AppException {
  ForbiddenException([String? message]) : super(message, "Forbidden Access: ");
}

// Too Many Requests Exception
class TooManyRequestsException extends AppException {
  TooManyRequestsException([String? message])
      : super(message, "Too Many Requests: ");
}

// Method Not Allowed Exception
class MethodNotAllowedException extends AppException {
  MethodNotAllowedException([String? message])
      : super(message, "Method Not Allowed: ");
}
