import 'package:get_storage/get_storage.dart';
import 'package:in_code/config/network/network_services_api.dart';

import 'package:http/http.dart' as http;
import 'package:in_code/config/storage/sharedpref_keys.dart';

class InterventionsRepository {
  final api = NetworkServicesApi();
  final storage = GetStorage();
  Future<dynamic> fetchAllInterventions(
      {required int offset, required int limit}
      ) async {
    var uri = Uri.parse("http://www.in-code.cloud:8888/api/1/history");

    var request = http.MultipartRequest('POST', uri);

    // Add fields
    request.fields['version'] = '2';
    request.fields['id_user'] = box.read(userId).toString();
    request.fields['offset'] = offset.toString();
    request.fields['limit'] = limit.toString();
    
    try {
      var streamedResponse = await request.send().timeout(const Duration(seconds: 10), onTimeout: () {
        throw Exception('Timeout: The server took too long to respond. Please check your connection and try again.');
      });
      var response = await http.Response.fromStream(streamedResponse);
      print('Response data Intervention: ${response.body}');
      return response.body;
    } catch (e) {
      throw Exception("Multipart request failed: $e");
    }
  }
}
