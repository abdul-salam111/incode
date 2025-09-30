import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:in_code/config/exceptions/app_exceptions.dart';
import 'package:in_code/config/network/base_api_services.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';

class NetworkServicesApi implements BaseApiServices {
  @override
  Future<dynamic> getApi(String url) async {
    dynamic apiResponse;
    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${box.read(usertoken)}'
        },
      ).timeout(const Duration(seconds: 10));

      apiResponse = handleError(response);
    } on SocketException {
      throw NoInternetException('No internet connection.');
    } on RequestTimeoutException {
      throw RequestTimeoutException('Request timed out.');
    } catch (e) {
      throw FetchDataException('Failed to fetch data: $e');
    }
    return apiResponse;
  }

  @override
  Future postApi(String url, data) async {
    dynamic apiResponse;
    print('data: $data');
    print('url: $url');
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/x-www-form-urlencoded',
              'Accept': 'application/json',
              // 'Authorization': 'Bearer ${box.read(usertoken)}'
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));
      print(response.body);
      print(response.statusCode);
      apiResponse = handleError(response);
    } on SocketException {
      throw NoInternetException('No internet connection.');
    } on RequestTimeoutException {
      throw RequestTimeoutException('Request timed out.');
    }
    return apiResponse;
  }

  @override
  Future updateApi(String url, data) async {
    dynamic apiResponse;
    try {
      final response = await http
          .put(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${box.read(usertoken)}'
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      apiResponse = handleError(response);
    } on SocketException {
      throw NoInternetException('No internet connection.');
    } on RequestTimeoutException {
      throw RequestTimeoutException('Request timed out.');
    }
    return apiResponse;
  }

  @override
  Future deleteApi(String url, data) async {
    dynamic apiResponse;
    try {
      final response = await http
          .delete(
            Uri.parse(url),
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer ${box.read(usertoken)}'
            },
            body: jsonEncode(data),
          )
          .timeout(const Duration(seconds: 10));

      apiResponse = handleError(response);
    } on SocketException {
      throw NoInternetException('No internet connection.');
    } on RequestTimeoutException {
      throw RequestTimeoutException('Request timed out.');
    }
    return apiResponse;
  }

  dynamic handleError(http.Response response) {
    switch (response.statusCode) {
      case 200:
        return jsonDecode(response.body);
      case 400:
        throw BadRequestException(response.body);
      case 401:
        throw UnauthorizedException('Unauthorized access.');
      case 403:
        throw ForbiddenException('Access forbidden.');
      case 404:
        throw NotFoundException(response.body);
      case 429:
        throw TooManyRequestsException('Too many requests.');
      case 500:
        throw InternalServerErrorException('Internal server error.');
      case 503:
        throw ServiceUnavailableException('Service unavailable.');
      default:
        throw FetchDataException(
            'Failed to fetch data. Status code: ${response.statusCode}');
    }
  }
}
