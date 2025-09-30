import 'dart:convert';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';
import 'package:in_code/models/assegnaogetto.dart';
import 'package:in_code/pages/no_internet_screen.dart';
// You must create this model

class NoInternetException implements Exception {
  final String message;
  NoInternetException([this.message = 'No internet connection']);
  @override
  String toString() => message;
}

class AssegnaOggettoController extends GetxController {
  var isLoading = false.obs;
  // var data = <AssegnaOggetto>[].obs;

  final Connectivity _connectivity = Connectivity();
  final GetStorage box = GetStorage();
  var hasInternetConnection = true.obs;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();

    // ✅ List<ConnectivityResult> for version 6.1.4+
    _connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    hasInternetConnection.value = result != ConnectivityResult.none;
    print(
      "🔌 Internet status: ${hasInternetConnection.value ? "Connected" : "Disconnected"}",
    );
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity
          .checkConnectivity();
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      _updateConnectionStatus(result);
    } catch (e) {
      print("⚠️ Error checking connectivity: $e");
    }
  }

  Future<void> checkConnectivityOrThrow() async {
    final List<ConnectivityResult> results = await _connectivity
        .checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      throw NoInternetException();
    }
  }

  /// ✅ Fetch Data
  Future<void> fetchData() async {
    isLoading(true);
    try {
      await checkConnectivityOrThrow();
      print('this is boxread ${box.read('id_user')}');
      final url = Uri.parse('http://www.in-code.cloud:8888/api/1/type_object');
      final response = await http.post(
        url,
        body: jsonEncode({'version': 2.0, 'id_user': box.read('id_user')}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        print('this is json list ${jsonList}');
        final parsed = jsonList
            .map((json) => ObjectTypeModel.fromJson(json))
            .toList();

        var data = <ObjectTypeModel>[].obs;

        // later:
        data.assignAll(parsed);

        // box.write('cached_type_objects', response.body); // ✅ Cache
      } else {
        Get.snackbar("Errore", "Errore dal server: ${response.statusCode}");
      }
    } on NoInternetException {
      isLoading(false);
      await Get.to(() => NoInternetScreen());
    } catch (e) {
      Get.snackbar("Errore", "Errore durante il caricamento: $e");
    } finally {
      isLoading(false);
    }
  }

  /// ✅ Submit Data
  Future<void> submitData(Map<String, dynamic> payload) async {
    isLoading(true);
    try {
      await checkConnectivityOrThrow();

      final url = Uri.parse(
        'http://www.in-code.cloud:8888/api/1/submit_object',
      ); // 🔁 Change to real endpoint
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        Get.snackbar("Successo", "Dati inviati con successo.");
      } else {
        Get.snackbar(
          "Errore",
          "Errore durante l'invio: ${response.statusCode}",
        );
      }
    } on NoInternetException {
      isLoading(false);
      await Get.to(() => NoInternetScreen());
    } catch (e) {
      Get.snackbar("Errore", "Errore durante l'invio: $e");
    } finally {
      isLoading(false);
    }
  }
}
