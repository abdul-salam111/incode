// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:in_code/config/storage/sharedpref_keys.dart';
// import 'package:in_code/controllers/scan_controller.dart';
// import 'package:in_code/controllers/navbar_controller.dart';
// import 'package:in_code/pages/navbar.dart';
// import 'package:in_code/res/res.dart';
// import 'package:in_code/widgets/success_popup.dart';
// import 'package:intl/intl.dart';
// import 'package:syncfusion_flutter_datepicker/datepicker.dart';
// class AssegnaOggetto extends StatefulWidget {
//   const AssegnaOggetto({Key? key}) : super(key: key);
//   @override
//   _AssegnaOggettoState createState() => _AssegnaOggettoState();
// }
// class _AssegnaOggettoState extends State<AssegnaOggetto> {
//   QRCodeController qrCodecontroller = Get.put(QRCodeController());
//   final _formKey = GlobalKey<FormState>();
//   List<dynamic> objectTypes = [];
//   List<dynamic> currentAttributes = [];
//   Map<String, dynamic> formValues = {};
//   int? selectedObjectTypeId;
//   bool loading = false;
//   @override
//   void initState() {
//     super.initState();
//     fetchObjectTypes();
//   }
//   Future<void> fetchObjectTypes() async {
//     setState(() => loading = true);
//     final response = await http.post(
//       Uri.parse('http://www.in-code.cloud:8888/api/1/type_object'),
//       headers: {
//         'Content-Type': 'application/x-www-form-urlencoded',
//         'Accept': 'application/json',
//       },
//       body: {'version': '2', 'id_user': box.read(userId).toString()},
//     );
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       setState(() => objectTypes = data);
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Failed to load object types')),
//       );
//     }
//     setState(() => loading = false);
//   }
//   void submitForm() async {
//     if (!_formKey.currentState!.validate()) return;
//     _formKey.currentState!.save();
//     final detailsObject = formValues.map(
//       (key, value) => MapEntry(key, value.toString()),
//     );
//     final uri = Uri.parse('http://www.in-code.cloud:8888/api/1/object/set');
//     final request = http.MultipartRequest('POST', uri);
//     // Standard fields
//     request.fields['version'] = '2.0';
//     request.fields['id_user'] = box.read(userId).toString();
//     request.fields['code_object'] = qrCodecontroller.scannedImage.value;
//     request.fields['id_type_object'] = selectedObjectTypeId.toString();
//     // Flatten details_object
//     detailsObject.forEach((key, value) {
//       request.fields['details_object[$key]'] = value;
//     });
//     try {
//       final streamedResponse = await request.send();
//       final response = await http.Response.fromStream(streamedResponse);
//       final dialog = response.statusCode == 200
//           ? CustomScanDialog(
//               oneButtonOnPressed: () => Get.back(),
//               isOneButton: true,
//               titleColor: Colors.green,
//               icon: Icons.check_circle,
//               iconBackgroundColor: Colors.green,
//               continueButtonColor: Colors.green,
//               title: "Successo",
//               description: "Data posted successfully!",
//               onCancel: () => Get.back(),
//               onContinue: () => Get.back(),
//             )
//           : CustomScanDialog(
//               onCancel: () => Get.back(),
//               onContinue: () => Get.back(),
//               oneButtonOnPressed: () => Get.back(),
//               isOneButton: true,
//               titleColor: AppColors.secondaryColor,
//               icon: Icons.close,
//               iconBackgroundColor: AppColors.secondaryColor,
//               continueButtonColor: AppColors.secondaryColor,
//               title: "Errore",
//               description:
//                   "Stiamo riscontrando problemi di connessione al server",
//             );
//       showDialog(
//         context: Get.context!,
//         barrierDismissible: false,
//         builder: (_) => dialog,
//       );
//     } catch (e) {
//       showDialog(
//         context: Get.context!,
//         barrierDismissible: false,
//         builder: (_) => CustomScanDialog(
//           onCancel: () => Get.back(),
//           onContinue: () => Get.back(),
//           oneButtonOnPressed: () => Get.back(),
//           isOneButton: true,
//           titleColor: AppColors.secondaryColor,
//           icon: Icons.close,
//           iconBackgroundColor: AppColors.secondaryColor,
//           continueButtonColor: AppColors.secondaryColor,
//           title: "Errore",
//           description: "Si è verificato un errore: ${e.toString()}",
//         ),
//       );
//     }
//   }
//   InputDecoration getInputDecoration(String label) {
//     return InputDecoration(
//       labelText: label,
//       labelStyle: const TextStyle(color: Colors.black),
//       floatingLabelBehavior: FloatingLabelBehavior.always,
//       contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//       errorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: const BorderSide(color: Colors.grey), // grey instead of red
//       ),
//       focusedErrorBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(50),
//         borderSide: const BorderSide(color: Colors.grey),
//       ),
//     );
//   }
//   Widget decoratedField(Widget field) {
//     return Container(
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(50),
//         boxShadow: const [
//           BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
//         ],
//       ),
//       child: field,
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       onWillPop: () async {
//         // Initialize navbar controller and navigate to project screen
//         final navbarController = Get.put(NavbarController());
//         navbarController.selectedIndex.value = 0; // Project screen index
//         Get.offAll(() => const Navbar());
//         return false; // Prevent default back behavior
//       },
//       child: Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primaryColor,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back, color: Colors.white),
//           onPressed: () {
//             // Initialize navbar controller and navigate to project screen
//             final navbarController = Get.put(NavbarController());
//             navbarController.selectedIndex.value = 0; // Project screen index
//             Get.offAll(() => const Navbar());
//           },
//         ),
//         title: const Text(
//           'Assegna Oggetto',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: loading
//           ? const Center(
//               child: CircularProgressIndicator(color: AppColors.primaryColor),
//             )
//           : Padding(
//               padding: const EdgeInsets.all(16),
//               child: Form(
//                 key: _formKey,
//                 child: SingleChildScrollView(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       decoratedField(
//                         DropdownButtonFormField<int>(
//                           hint: const Text('Tipologia Oggetto'),
//                           value: selectedObjectTypeId,
//                           isExpanded: true,
//                           icon: const Icon(
//                             Icons.keyboard_arrow_down_rounded,
//                             color: AppColors.primaryColor,
//                           ),
//                           decoration: getInputDecoration('Tipologia Oggetto'),
//                           onChanged: (value) {
//                             setState(() {
//                               selectedObjectTypeId = value;
//                               currentAttributes = objectTypes.firstWhere(
//                                 (e) => e['id_type_object'] == value,
//                               )['attributes'];
//                               formValues.clear();
//                             });
//                           },
//                           validator: (value) =>
//                               value == null ? 'Campo obbligatorio' : null,
//                           items: objectTypes.map<DropdownMenuItem<int>>((obj) {
//                             return DropdownMenuItem<int>(
//                               value: obj['id_type_object'],
//                               child: Text(obj['description_type_object']),
//                             );
//                           }).toList(),
//                           dropdownColor: Colors.white,
//                           menuMaxHeight: 400,
//                         ),
//                       ),
//                       // const SizedBox(height: 16),
//                    ...currentAttributes.map<Widget>((attr) {
//   final label = attr['description_attribute'] ?? '';
//   final defaultValues = attr['default_values'] as List<dynamic>;
//   final isRequired = attr['required'] == 1;
//   final type = attr['type_attribute'];
//   final hasDefaults = defaultValues.isNotEmpty;
//   final isNumberField = type == 1;
//   final isDropdownField = hasDefaults;
//   final isTextField = type == 2 && !hasDefaults;
//   final isDatePicker = type == 4 && !hasDefaults;
//   final isDateDropdown = type == 4 && hasDefaults;
//   if (isDropdownField) {
//     print('Field "$label" uses widget: Dropdown');
//     final dropdownItems = defaultValues
//         .cast<String>()
//         .toSet()
//         .map(
//           (val) => DropdownMenuItem<String>(
//             value: val,
//             child: Text(val),
//           ),
//         )
//         .toList();
//     final currentValue =
//         dropdownItems.any((item) => item.value == formValues[label])
//             ? formValues[label]
//             : null;
//     return decoratedField(
//       DropdownButtonFormField<String>(
//         isExpanded: true,
//         icon: const Icon(
//           Icons.keyboard_arrow_down_rounded,
//           color: AppColors.primaryColor,
//         ),
//         decoration: getInputDecoration(label),
//         value: currentValue,
//         items: dropdownItems,
//         onChanged: (val) => setState(() => formValues[label] = val),
//         validator: (val) => isRequired && (val == null || val.isEmpty)
//             ? 'Campo obbligatorio'
//             : null,
//       ),
//     );
//   } else if (isNumberField) {
//     print('Field "$label" uses widget: Number');
//     return decoratedField(
//       TextFormField(
//         cursorColor: AppColors.primaryColor,
//         decoration: getInputDecoration(label),
//         keyboardType: TextInputType.number,
//         validator: (val) {
//           if (isRequired && (val == null || val.isEmpty)) {
//             return 'Campo obbligatorio';
//           }
//           if (val != null && val.isNotEmpty &&
//               double.tryParse(val) == null) {
//             return 'Inserisci un numero valido';
//           }
//           return null;
//         },
//         onSaved: (val) => formValues[label] = val,
//       ),
//     );
//   } else if (isTextField) {
//     print('Field "$label" uses widget: Text');
//     return decoratedField(
//       TextFormField(
//         cursorColor: AppColors.primaryColor,
//         decoration: getInputDecoration(label),
//         keyboardType: TextInputType.text,
//         validator: (val) => isRequired && (val == null || val.isEmpty)
//             ? 'Campo obbligatorio'
//             : null,
//         onSaved: (val) => formValues[label] = val,
//       ),
//     );
//   } else if (isDatePicker) {
//     print('Field "$label" uses widget: Date Picker');
//     return decoratedField(
//   GestureDetector(
//   onTap: () async {
//     DateTime? selectedDate;
//     await showDialog(
//       context: context,
//       builder: (ctx) {
//         return AlertDialog(
//           shadowColor:  AppColors.primaryColor,
//           title: Text('Seleziona la data'),
//           content: SizedBox(
//             height: 300,
//             child: 
//      SfDateRangePicker(
//   view: DateRangePickerView.month,
//   selectionMode: DateRangePickerSelectionMode.single,
//   showTodayButton: true,
//   selectionColor: AppColors.primaryColor, // Red background for selected date
//   backgroundColor: Colors.white, // Popup background
//   todayHighlightColor: AppColors.primaryColor, // Today’s date ring
//   selectionTextStyle: const TextStyle(
//     color: Colors.white, // Text inside selected date (white)
//     fontWeight: FontWeight.bold,
//   ),
//   headerStyle: DateRangePickerHeaderStyle(
//     textAlign: TextAlign.center,
//     backgroundColor: Colors.white,
//     textStyle: const TextStyle(
//       color: AppColors.primaryColor,
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//     ),
//   ),
//   monthCellStyle: DateRangePickerMonthCellStyle(
//     textStyle: const TextStyle(
//       color: Colors.black, // Regular day text
//     ),
//     // todayTextStyle: const TextStyle(
//     //   color: Colors.black,
//     //   fontWeight: FontWeight.bold,
//     // ),
//     // todayCellDecoration: BoxDecoration(
//     //   color: AppColors.primaryColor,
//     //   shape: BoxShape.circle,
//     // ),
//     disabledDatesTextStyle: const TextStyle(
//       color: Colors.grey,
//     ),
//   ),
//   onSelectionChanged: (DateRangePickerSelectionChangedArgs args) {
//   if (args.value is DateTime) {
//     var selectedDate = args.value;
//     String formattedDate = DateFormat('dd/MM/yyyy').format(selectedDate);
//     print('Selected date: $formattedDate');
//     // Assign the formatted date to formValues
//     setState(() {
//       formValues[label] = formattedDate;
//     });
//   }
// }
// )
//           ),
//           actions: [
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.red,
//         foregroundColor: Colors.white,
//       ),
//       onPressed: () => Navigator.of(ctx).pop(),
//       child: const Text('Annulla'),
//     ),
//    // spacing between buttons
//     ElevatedButton(
//       style: ElevatedButton.styleFrom(
//         backgroundColor: Colors.green,
//         foregroundColor: Colors.white,
//       ),
//       onPressed: () {
//         Navigator.of(ctx).pop();
//       },
//       child: const Text('Conferma'),
//     ),
//   ],     
//         );
//       },
//     );
//     if (selectedDate != null) {
//       setState(() {
//         formValues[label] = selectedDate!.toIso8601String();
//       });
//     }
//   },
//   child: AbsorbPointer(
//     child: TextFormField(
//       controller: TextEditingController(
//         text: formValues[label] != null
//             ? formValues[label].toString().split('T').first
//             : '',
//       ),
//       decoration: getInputDecoration(label).copyWith(
//         suffixIcon: const Icon(Icons.calendar_today),
//       ),
//       validator: (val) => isRequired && (val == null || val.isEmpty)
//           ? 'Campo obbligatorio'
//           : null,
//     ),
//   ),
// )
//     );
//   } else {
//     print('Field "$label" uses widget: Skipped');
//     return const SizedBox.shrink();
//   }
// }).toList(),
//                       const SizedBox(height: 32),
//                       SizedBox(
//                         width: double.infinity,
//                         height: 48,
//                         child: ElevatedButton(
//                           onPressed: submitForm,
//                           style: ElevatedButton.styleFrom(
//                             backgroundColor: AppColors.primaryColor,
//                             shape: RoundedRectangleBorder(
//                               borderRadius: BorderRadius.circular(32),
//                             ),
//                             padding: const EdgeInsets.symmetric(vertical: 12),
//                           ),
//                           child: const Text(
//                             "ASSEGNA",
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                               color: Colors.white,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/scan_controller.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/pages/navbar.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/success_popup.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class AssegnaOggetto extends StatefulWidget {
  const AssegnaOggetto({Key? key}) : super(key: key);

  @override
  _AssegnaOggettoState createState() => _AssegnaOggettoState();
}

class _AssegnaOggettoState extends State<AssegnaOggetto> {
  QRCodeController qrCodecontroller = Get.put(QRCodeController());
  List<dynamic> objectTypes = [];
  List<dynamic> currentAttributes = [];
  Map<String, dynamic> formValues = {};
  Map<String, String?> fieldErrors = {}; // manual errors
  int? selectedObjectTypeId;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchObjectTypes();
  }

  Future<void> fetchObjectTypes() async {
    setState(() => loading = true);
    final response = await http.post(
      Uri.parse('http://www.in-code.cloud:8888/api/1/type_object'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
      },
      body: {'version': '2', 'id_user': box.read(userId).toString()},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() => objectTypes = data);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load object types')),
      );
    }

    setState(() => loading = false);
  }

  bool validateFields() {
    fieldErrors.clear();

    if (selectedObjectTypeId == null) {
      fieldErrors['Tipologia Oggetto'] = 'Campo obbligatorio';
    }

    for (var attr in currentAttributes) {
      final label = attr['description_attribute'] ?? '';
      final isRequired = attr['required'] == 1;
      final defaultValues = attr['default_values'] as List<dynamic>;
      final type = attr['type_attribute'];

      final hasDefaults = defaultValues.isNotEmpty;
      final isNumberField = type == 1;
      final isDropdownField = hasDefaults;
      final isTextField = type == 2 && !hasDefaults;
      final isDatePicker = type == 4 && !hasDefaults;
      final isDateDropdown = type == 4 && hasDefaults;

      final value = formValues[label];

      if (isRequired) {
        if (isDropdownField || isTextField || isNumberField) {
          if (value == null || (value is String && value.trim().isEmpty)) {
            fieldErrors[label] = 'Campo obbligatorio';
          }
        } else if (isDatePicker || isDateDropdown) {
          if (value == null || (value is String && value.trim().isEmpty)) {
            fieldErrors[label] = 'Campo obbligatorio';
          }
        }
      }

      if (isNumberField && value != null && value.toString().isNotEmpty) {
        if (double.tryParse(value.toString()) == null) {
          fieldErrors[label] = 'Inserisci un numero valido';
        }
      }
    }

    setState(() {}); // refresh UI
    return fieldErrors.isEmpty;
  }

  void submitForm() async {
    if (!validateFields()) return;

    final detailsObject = formValues.map(
      (key, value) => MapEntry(key, value.toString()),
    );

    final uri = Uri.parse('http://www.in-code.cloud:8888/api/1/object/set');
    final request = http.MultipartRequest('POST', uri);

    // Standard fields
    request.fields['version'] = '2.0';
    request.fields['id_user'] = box.read(userId).toString();
    request.fields['code_object'] = qrCodecontroller.scannedImage.value;
    request.fields['id_type_object'] = selectedObjectTypeId.toString();

    // Flatten details_object
    detailsObject.forEach((key, value) {
      request.fields['details_object[$key]'] = value;
    });

    try {
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      final dialog = response.statusCode == 200
          ? CustomScanDialog(
              oneButtonOnPressed: () => Get.back(),
              isOneButton: true,
              titleColor: Colors.green,
              icon: Icons.check_circle,
              iconBackgroundColor: Colors.green,
              continueButtonColor: Colors.green,
              title: "Successo",
              description: "Data posted successfully!",
              onCancel: () => Get.back(),
              onContinue: () => Get.back(),
            )
          : CustomScanDialog(
              onCancel: () => Get.back(),
              onContinue: () => Get.back(),
              oneButtonOnPressed: () => Get.back(),
              isOneButton: true,
              titleColor: AppColors.secondaryColor,
              icon: Icons.close,
              iconBackgroundColor: AppColors.secondaryColor,
              continueButtonColor: AppColors.secondaryColor,
              title: "Errore",
              description:
                  "Stiamo riscontrando problemi di connessione al server",
            );

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => dialog,
      );
    } catch (e) {
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          onCancel: () => Get.back(),
          onContinue: () => Get.back(),
          oneButtonOnPressed: () => Get.back(),
          isOneButton: true,
          titleColor: AppColors.secondaryColor,
          icon: Icons.close,
          iconBackgroundColor: AppColors.secondaryColor,
          continueButtonColor: AppColors.secondaryColor,
          title: "Errore",
          description: "Si è verificato un errore: ${e.toString()}",
        ),
      );
    }
  }

  InputDecoration getInputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.black),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
    );
  }

  Widget decoratedField(Widget field) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
        boxShadow: const [
          BoxShadow(color: Colors.grey, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: field,
    );
  }

  Widget buildDropdownField({
    required String label,
    required List<DropdownMenuItem<String>> items,
    String? currentValue,
    required bool isRequired,
    required void Function(String?) onChanged,
  }) {
    final error = fieldErrors[label];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        decoratedField(
          DropdownButtonFormField<String>(
            isExpanded: true,
            icon: const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.primaryColor,
            ),
            decoration: getInputDecoration(label),
            value: currentValue,
            items: items,
            onChanged: (val) {
              onChanged(val);
              setState(() {
                // clear error for this field on change
                fieldErrors.remove(label);
              });
            },
            dropdownColor: Colors.white,
            menuMaxHeight: 400,
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (error == null)
          const SizedBox(height: 8),
      ],
    );
  }

  Widget buildTextField({
    required String label,
    required bool isRequired,
    TextInputType keyboardType = TextInputType.text,
  }) {
    final error = fieldErrors[label];
    final value = formValues[label]?.toString() ?? '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        decoratedField(
          TextField(
            cursorColor: AppColors.primaryColor,
            keyboardType: keyboardType,
            onChanged: (val) {
              formValues[label] = val;
              fieldErrors.remove(label);
              setState(() {});
            },
            controller: TextEditingController.fromValue(
              TextEditingValue(
                text: value,
                selection: TextSelection.collapsed(offset: value.length),
              ),
            ),
            decoration: getInputDecoration(label),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (error == null)
          const SizedBox(height: 8),
      ],
    );
  }

  Widget buildDateField(String label, bool isRequired) {
    final error = fieldErrors[label];
    final displayText = formValues[label] != null
        ? formValues[label].toString().split('T').first
        : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        decoratedField(
          GestureDetector(
            onTap: () async {
              DateTime? selectedDate;
              await showDialog(
                context: context,
                builder: (ctx) {
                  return AlertDialog(
                    shadowColor: AppColors.primaryColor,
                    title: Text('Seleziona la data'),
                    content: SizedBox(
                      height: 300,
                      child: SfDateRangePicker(
                        view: DateRangePickerView.month,
                        selectionMode: DateRangePickerSelectionMode.single,
                        showTodayButton: true,
                        selectionColor: AppColors.primaryColor,
                        backgroundColor: Colors.white,
                        todayHighlightColor: AppColors.primaryColor,
                        selectionTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        headerStyle: DateRangePickerHeaderStyle(
                          textAlign: TextAlign.center,
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        monthCellStyle: DateRangePickerMonthCellStyle(
                          textStyle: const TextStyle(
                            color: Colors.black,
                          ),
                          disabledDatesTextStyle: const TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        onSelectionChanged:
                            (DateRangePickerSelectionChangedArgs args) {
                          if (args.value is DateTime) {
                            var sel = args.value as DateTime;
                            String formattedDate =
                                DateFormat('dd/MM/yyyy').format(sel);
                            setState(() {
                              formValues[label] = formattedDate;
                              fieldErrors.remove(label);
                            });
                          }
                        },
                      ),
                    ),
                    actions: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Annulla'),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(ctx).pop();
                        },
                        child: const Text('Conferma'),
                      ),
                    ],
                  );
                },
              );
            },
            child: AbsorbPointer(
              child: TextField(
                cursorColor: AppColors.primaryColor,
                decoration: getInputDecoration(label).copyWith(
                  suffixIcon: const Icon(Icons.calendar_today),
                ),
                controller: TextEditingController.fromValue(
                  TextEditingValue(
                    text: displayText,
                    selection:
                        TextSelection.collapsed(offset: displayText.length),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(left: 16, top: 4, bottom: 8),
            child: Text(
              error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        if (error == null)
          const SizedBox(height: 8),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final navbarController = Get.put(NavbarController());
        navbarController.selectedIndex.value = 0;
        Get.offAll(() => const Navbar());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.primaryColor,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              final navbarController = Get.put(NavbarController());
              navbarController.selectedIndex.value = 0;
              Get.offAll(() => const Navbar());
            },
          ),
          title: const Text(
            'Assegna Oggetto',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: loading
            ? const Center(
                child:
                    CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildDropdownField(
                        label: 'Tipologia Oggetto',
                        items: objectTypes
                            .map<DropdownMenuItem<String>>((obj) {
                          return DropdownMenuItem<String>(
                            value: obj['id_type_object'].toString(),
                            child:
                                Text(obj['description_type_object'] ?? ''),
                          );
                        }).toList(),
                        currentValue: selectedObjectTypeId?.toString(),
                        isRequired: true,
                        onChanged: (val) {
                          setState(() {
                            selectedObjectTypeId =
                                val != null ? int.tryParse(val) : null;
                            currentAttributes = objectTypes.firstWhere(
                              (e) =>
                                  e['id_type_object'].toString() == val,
                            )['attributes'];
                            formValues.clear();
                          });
                        },
                      ),
                      ...currentAttributes.map<Widget>((attr) {
                        final label = attr['description_attribute'] ?? '';
                        final defaultValues =
                            attr['default_values'] as List<dynamic>;
                        final isRequired = attr['required'] == 1;
                        final type = attr['type_attribute'];

                        final hasDefaults = defaultValues.isNotEmpty;
                        final isNumberField = type == 1;
                        final isDropdownField = hasDefaults;
                        final isTextField = type == 2 && !hasDefaults;
                        final isDatePicker = type == 4 && !hasDefaults;
                        final isDateDropdown = type == 4 && hasDefaults;

                        if (isDropdownField) {
                          final dropdownItems = defaultValues
                              .cast<String>()
                              .toSet()
                              .map(
                                (val) => DropdownMenuItem<String>(
                                  value: val,
                                  child: Text(val),
                                ),
                              )
                              .toList();

                          final currentValue =
                              dropdownItems.any((item) =>
                                      item.value == formValues[label])
                                  ? formValues[label]
                                  : null;

                          return buildDropdownField(
                            label: label,
                            items: dropdownItems,
                            currentValue: currentValue,
                            isRequired: isRequired,
                            onChanged: (val) =>
                                formValues[label] = val ?? '',
                          );
                        } else if (isNumberField) {
                          return buildTextField(
                            label: label,
                            isRequired: isRequired,
                            keyboardType: TextInputType.number,
                          );
                        } else if (isTextField) {
                          return buildTextField(
                            label: label,
                            isRequired: isRequired,
                          );
                        } else if (isDatePicker || isDateDropdown) {
                          return buildDateField(label, isRequired);
                        } else {
                          return const SizedBox.shrink();
                        }
                      }).toList(),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          child: const Text(
                            "ASSEGNA",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
