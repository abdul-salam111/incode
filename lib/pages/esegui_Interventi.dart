import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/controllers/scan_controller.dart';

import 'package:in_code/res/res.dart';

class EseguiInterventoScreen extends StatefulWidget {
  const EseguiInterventoScreen({super.key});

  @override
  _EseguiInterventoScreenState createState() => _EseguiInterventoScreenState();
}

class _EseguiInterventoScreenState extends State<EseguiInterventoScreen> {
  final QRCodeController qrCodecontroller = Get.put(QRCodeController());
  final controller = Get.find<ProjectScreenController>();
  final isLoading = false.obs;
  final isSubmitEnabled = false.obs;

  List<Map<String, dynamic>> interventions = [];

  late Map<int, bool> selected;
  late Map<int, TextEditingController> noteControllers;
  late Map<int, FocusNode> focusNodes;

  // ✅ Track the order of user selection
  List<int> selectionOrder = [];

  @override
  void initState() {
    super.initState();
    final response = controller.getAllSubprojects.value;

    interventions = response.typeInterventionList!.map((item) {
      return {
        'id_type_intervention': item.idTypeIntervention,
        'description_type_intervention': item.descriptionTypeIntervention,
      };
    }).toList();

    selected = {
      for (var item in interventions)
        item['id_type_intervention'] as int: false,
    };

    noteControllers = {
      for (var item in interventions)
        item['id_type_intervention'] as int: TextEditingController(),
    };

    focusNodes = {
      for (var item in interventions)
        item['id_type_intervention'] as int: FocusNode(),
    };
  }

  @override
  void dispose() {
    noteControllers.values.forEach((controller) => controller.dispose());
    focusNodes.values.forEach((node) => node.dispose());
    super.dispose();
  }

  void checkSubmitEligibility() {
    final hasValidInput = selected.entries.any((entry) {
      final isSelected = entry.value;
      final note = noteControllers[entry.key]?.text.trim() ?? '';
      return isSelected || note.isNotEmpty;
    });
    isSubmitEnabled.value = hasValidInput;
  }

  // void sendSelectedInterventions() async {

  // final selectedInterventions = interventions
  //   .where((item) => selected[item['id_type_intervention']] == true)
  //   .map((item) {
  //     final id = item['id_type_intervention'];
  //     final text = (noteControllers[id]?.text ?? '').trim();
  //     return {
  //       "id_type_intervention": id,
  //       "notes": text, // always a String, never null
  //     };
  //   })
  //   .toList();
  //     print('this data ${selectedInterventions} ${qrCodecontroller.scannedImage.value}');
  //   final requestPayload = {
  //     'version': 2.0,
  //     'id_user': box.read(userId),
  //     'code_object': qrCodecontroller.scannedImage.value,
  //     'interventions': selectedInterventions,
  //   };

  //   const String url = 'http://www.in-code.cloud:8888/api/1/object/interventions/set';

  //   try {
  //     isLoading.value = true;

  //     final response = await http.post(
  //       Uri.parse(url),
  //        headers: {'Content-Type': 'multipart/form-data'},
  //       body: jsonEncode(requestPayload),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       print('✅ Interventions submitted successfully: $data');

  //       await showDialog(
  //         context: context,
  //         builder: (context) => AlertDialog(
  //           title: const Text('Interventi completati'),
  //           content: const Text(
  //             'Le modifiche sono state salvate con successo.',
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () {
  //                 Navigator.of(context).pop();
  //                 final navbarController = Get.find<NavbarController>();
  //                 navbarController.goToTab(5);
  //               },
  //               child: const Text('OK'),
  //             ),
  //           ],
  //         ),
  //       );
  //     } else {
  //       print('❌ Failed with status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('❗ Exception while submitting interventions: $e');
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }


void sendSelectedInterventions() async {
  final selectedInterventions = interventions
      .where((item) => selected[item['id_type_intervention']] == true)
      .map((item) {
        final id = item['id_type_intervention'];
        final text = (noteControllers[id]?.text ?? '').trim();
        return {
          "id_type_intervention": id,
          "notes": text, // always a String
        };
      })
      .toList();

  print('this data $selectedInterventions ${qrCodecontroller.scannedImage.value}');

  const String url = 'http://www.in-code.cloud:8888/api/1/object/interventions/set';

  try {
    isLoading.value = true;

    final uri = Uri.parse(url);

    final request = http.MultipartRequest('POST', uri);

    // Add fields (all as strings)
    request.fields['version'] = '2.0';
    request.fields['id_user'] = box.read(userId).toString();
    request.fields['code_object'] = qrCodecontroller.scannedImage.value ?? '';

    // Add the interventions list as JSON string
    request.fields['interventions'] = jsonEncode(selectedInterventions);

    // Send request
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Interventions submitted successfully: $data');

      await showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Interventi completati'),
          content: const Text(
            'Le modifiche sono state salvate con successo.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                final navbarController = Get.find<NavbarController>();
                navbarController.goToTab(7);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      print('❌ Failed with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
    }
  } catch (e) {
    print('❗ Exception while submitting interventions: $e');
  } finally {
    isLoading.value = false;
  }
}

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        title: Text(
          'Esegui Intervento',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: size.width * 0.05,
          ),
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
          child: Column(
            children: [
              Obx(
                () => isLoading.value
                    ? const Center(child: CircularProgressIndicator())
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: interventions.length,
                  itemBuilder: (context, index) {
                    final item = interventions[index];
                    final int id = item['id_type_intervention'];
                    final String title = item['description_type_intervention'];
                    final bool isSelected = selected[id]!;
        
                    // ✅ Get selected index based on order of selection
                    final int selectedIndex = isSelected
                        ? selectionOrder.indexOf(id)
                        : -1;
        
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (selected[id] == true) {
                            selected[id] = false;
                            selectionOrder.remove(id);
                          } else {
                            selected[id] = true;
                            selectionOrder.add(id);
                          }
                          checkSubmitEligibility();
        
                          if (selected[id]!) {
                            FocusScope.of(context).requestFocus(focusNodes[id]);
                          } else {
                            focusNodes[id]!.unfocus();
                          }
                        });
                      },
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primaryColor
                                  : const Color(0xFFEEE9E9),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 6,
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 12),
                                Text(
                                  '$title',
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: size.width * 0.045,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minHeight: 50,
                                    maxHeight: 200,
                                  ),
                                  child: Theme(
                                     data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
        cursorColor: AppColors.primaryColor, // cursor color
        selectionColor: AppColors.primaryColor.withOpacity(0.3), // text highlight
        selectionHandleColor: AppColors.primaryColor, // tear-drop handle color
            ),
          ),
                                    child: TextField(
                                      cursorColor: AppColors.primaryColor,
                                      controller: noteControllers[id],
                                      focusNode: focusNodes[id],
                                      textInputAction: TextInputAction.newline,
                                      enabled: isSelected,
                                      onChanged: (_) => checkSubmitEligibility(),
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                      minLines: 1,
                                      maxLines: null, // ✅ allow dynamic expansion
                                      keyboardType: TextInputType.multiline,
                                      decoration: InputDecoration(
                                        hintText: isSelected
                                            ? 'Note facoltative'
                                            : 'Seleziona per inserire note',
                                        hintStyle: const TextStyle(
                                          color: Colors.black45,
                                          fontSize: 12,
                                        ),
                                        filled: true,
                                        fillColor: Colors.white,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            size.width * 0.02,
                                          ),
                                          borderSide: BorderSide.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              
                              ],
                            ),
                          ),
        
                          // ✅ Top-left red badge with selection index
                          if (isSelected)
                            Positioned(
                              top: -10,
                              left: -10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: Text(
                                  '${selectedIndex + 1}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.only(bottom: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildButton('ANNULLA', AppColors.primaryColor, size, () {
                      final navbarController = Get.find<NavbarController>();
                      navbarController.goToTab(7);
                    }),
                    Obx(() {
                      final enabled = isSubmitEnabled.value;
                      return Opacity(
                        opacity: enabled ? 1 : 0.4,
                        child: _buildButton(
                          'ESEGUI',
                          const Color(0xFF3C8F3D),
                          size,
                          enabled ? sendSelectedInterventions : () {},
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(
    String label,
    Color color,
    Size size,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: size.width * 0.4,
        height: size.height * 0.06,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: size.width * 0.045,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// class EseguiInterventoScreen extends StatefulWidget {
//   EseguiInterventoScreen({super.key});
//   @override
//   _EseguiInterventoScreenState createState() => _EseguiInterventoScreenState();
// }
// class _EseguiInterventoScreenState extends State<EseguiInterventoScreen> {
//   QRCodeController qrCodecontroller = Get.put(QRCodeController());
//   final controller = Get.find<ProjectScreenController>();
//   List<Map<String, dynamic>> interventions = [];
//   RxBool isLoading = false.obs;
//   late Map<int, bool> selected;
//   late Map<int, TextEditingController> noteControllers;
//   late Map<int, FocusNode> focusNodes;
//   @override
//   void initState() {
//     super.initState();

//     final response = controller.getAllSubprojects.value;

//     interventions = response.typeInterventionList!.map((item) {
//       return {
//         'id_type_intervention': item.idTypeIntervention,
//         'description_type_intervention': item.descriptionTypeIntervention,
//       };
//     }).toList();

//     selected = {
//       for (var item in interventions)
//         item['id_type_intervention'] as int: false,
//     };

//     noteControllers = {
//       for (var item in interventions)
//         item['id_type_intervention'] as int: TextEditingController(),
//     };

//     focusNodes = {
//       for (var item in interventions)
//         item['id_type_intervention'] as int: FocusNode(),
//     };
//   }

//   @override
//   void dispose() {
//     noteControllers.values.forEach((controller) => controller.dispose());
//     focusNodes.values.forEach((node) => node.dispose());
//     super.dispose();
//   }

//   void sendSelectedInterventions() async {
//     final selectedInterventions = interventions
//         .where((item) => selected[item['id_type_intervention']] == true)
//         .map(
//           (item) => {
//             'id_type_intervention': item['id_type_intervention'],
//             'notes': noteControllers[item['id_type_intervention']]!.text.trim(),
//           },
//         )
//         .toList();
//     print(
//       "data ${box.read(userId)}, ${qrCodecontroller.scannedImage.value},${selectedInterventions}",
//     );
//     final requestPayload = {
//       'version': 2,
//       'id_user': box.read(userId),
//       'code_object': qrCodecontroller.scannedImage.value,
//       'interventions': selectedInterventions,
//     };

//     const String url = 'https://www.in-code.it/api/1/object/interventions/set';

//     try {
//       isLoading.value = true;

//       final response = await http.post(
//         Uri.parse(url),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(requestPayload),
//       );

//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);

//         print('✅ Interventions submitted successfully: $data');
//       } else {
//         print('❌ Failed with status code: ${response.statusCode}');
//         print('Response body: ${response.body}');
//       }
//     } catch (e) {
//       print('❗ Exception while submitting interventions: $e');
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;

//     List<int> selectedList = selected.entries
//         .where((entry) => entry.value)
//         .map((entry) => entry.key)
//         .toList();

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         title: Text(
//           'Esegui Intervento',
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.bold,
//             fontSize: size.width * 0.05,
//           ),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 40.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 itemCount: interventions.length,
//                 itemBuilder: (context, index) {
//                   final item = interventions[index];
//                   final int id = item['id_type_intervention'];
//                   final String title = item['description_type_intervention'];
//                   final bool isSelected = selected[id]!;
//                   final int selectedIndex = selectedList.indexOf(id);

//                   return GestureDetector(
//                     onTap: () {
//                       setState(() {
//                         selected[id] = !isSelected;
//                         if (selected[id]!) {
//                           FocusScope.of(context).requestFocus(focusNodes[id]);
//                         } else {
//                           focusNodes[id]!.unfocus();
//                         }
//                       });
//                     },
//                     child: Container(
//                       margin: const EdgeInsets.only(bottom: 16),
//                       decoration: BoxDecoration(
//                         color: isSelected
//                             ? AppColors.primaryColor
//                             : const Color(0xFFEEE9E9),
//                         borderRadius: BorderRadius.circular(20),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 6,
//                           ),
//                         ],
//                       ),
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           if (isSelected)
//                             Container(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 12,
//                                 vertical: 6,
//                               ),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                               child: Text(
//                                 '${selectedIndex + 1}',
//                                 style: const TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   color: Colors.red,
//                                 ),
//                               ),
//                             ),
//                           const SizedBox(height: 12),
//                           Text(
//                             '$id - $title',
//                             style: TextStyle(
//                               color: isSelected ? Colors.white : Colors.black,
//                               fontWeight: FontWeight.bold,
//                               fontSize: size.width * 0.045,
//                             ),
//                           ),
//                           const SizedBox(height: 12),
//                           SizedBox(
//                             height: 50,
//                             child: TextField(
//                               controller: noteControllers[id],
//                               focusNode: focusNodes[id],
//                               enabled: isSelected,
//                               style: const TextStyle(
//                                 color: Colors.black,
//                                 fontSize: 12,
//                               ),
//                               minLines: 1,
//                               maxLines: 2,
//                               keyboardType: TextInputType.multiline,
//                               decoration: InputDecoration(
//                                 hintText: isSelected
//                                     ? 'Note facoltative'
//                                     : 'Seleziona prima',
//                                 hintStyle: const TextStyle(
//                                   color: Colors.black45,
//                                   fontSize: 12,
//                                 ),
//                                 filled: true,
//                                 fillColor: Colors.white,
//                                 border: OutlineInputBorder(
//                                   borderRadius: BorderRadius.circular(
//                                     size.width * 0.02,
//                                   ),
//                                   borderSide: BorderSide.none,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             const SizedBox(height: 16),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 0),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _buildButton('ANNULLA', AppColors.primaryColor, size, () {
//                     print('Tapped on anulla');
//                     final navbarController = Get.find<NavbarController>();
//                     navbarController.goToTab(5);
//                   }),
//                   _buildButton('ESEGUI', const Color(0xFF3C8F3D), size, () {
//                     sendSelectedInterventions();
//                   }),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildButton(
//     String label,
//     Color color,
//     Size size,
//     VoidCallback onTap,
//   ) {
//     return GestureDetector(
//       onTap: onTap,
//       child: SizedBox(
//         width: size.width * 0.4,
//         height: size.height * 0.06,
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
//           decoration: BoxDecoration(
//             color: color,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: const [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: Center(
//             child: Text(
//               label,
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: size.width * 0.045,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
