import 'package:http/http.dart' as http;
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/models/relabel_model.dart';

class RelabelRepository {
  Future<bool> relabelObject(RelabelModel relableModel) async {
    final url = Uri.parse('http://www.in-code.cloud:8888/api/1/object/relabel');

    var request = http.MultipartRequest('POST', url);
     print("------${relableModel.newLabel},${relableModel.oldLabel} ");
    // Add form fields
    request.fields['version'] = '2.0';
    request.fields['id_user'] = box.read(userId).toString();
    request.fields['old_label'] = relableModel.oldLabel;
    request.fields['new_label'] = relableModel.newLabel;
    
    try {
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      print(response.body);
      print("this is response code = ${response.statusCode}");
      if (response.statusCode == 200) {
        print("Success: ${response.statusCode} ${response.body}");
        return true;
      } else if (response.statusCode == 404) {
        print("Bad Request: ${response.statusCode} ${response.body}");
        return false;
      } else if (response.statusCode == 401) {
        print("Unauthorized: ${response.statusCode} ${response.body}");
        return false;
      } else {
        print("Failed: ${response.statusCode} ${response.body}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
