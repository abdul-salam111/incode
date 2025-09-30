// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:excel/excel.dart' hide Border;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/state_manager.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/models/get_all_subprojects.dart';
import 'package:in_code/res/res.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:permission_handler/permission_handler.dart';

class ProjectDetails extends StatefulWidget {
  const ProjectDetails({super.key});

  @override
  State<ProjectDetails> createState() => _ProjectDetailsState();
}

class _ProjectDetailsState extends State<ProjectDetails> {
  final RxString searchQuery = ''.obs;
  final RxString indrizioQuery = ''.obs;
  final RxString datafinevitaQuery = ''.obs;
  final RxString datainiziovitaQuery = ''.obs;
  final RxString selectedDescriptionType = 'Tutti'.obs;
  final _searchController = TextEditingController();
  final _indrizioController = TextEditingController();
  final _datainiziovitaController = TextEditingController();
  final _datafinevitaController = TextEditingController();
  final GetAllSubProjects getAllSubProjects = Get.arguments;

  // Get unique description types from the objects list
  List<String> get descriptionTypes {
    final types = <String>{'Tutti'};
    for (var obj in getAllSubProjects.objectsList ?? []) {
      final objMap = obj as Map<String, dynamic>;
      if (objMap.containsKey('description_type_object')) {
        types.add(objMap['description_type_object'].toString());
      }
    }
    return types.toList();
  }

  // Helper method to search recursively in nested maps
  bool _searchInMap(Map<dynamic, dynamic> map, String query) {
    for (var entry in map.entries) {
      if (entry.key.toString().toLowerCase().contains(query)) {
        return true;
      }
      if (entry.value is Map) {
        if (_searchInMap(entry.value as Map, query)) {
          return true;
        }
      } else if (entry.value.toString().toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  // Get filtered indices
  List<int> _getFilteredIndices() {
    final filteredIndices = <int>[];
    final query = searchQuery.value.toLowerCase();
    final selectedType = selectedDescriptionType.value;
    final indrizioQueryLower = indrizioQuery.value.toLowerCase();
    final dataInizioQueryLower = datainiziovitaQuery.value.toLowerCase();
    final dataFineQueryLower = datafinevitaQuery.value.toLowerCase();

    for (int i = 0; i < (getAllSubProjects.objectsList?.length ?? 0); i++) {
      var objects = getAllSubProjects.objectsList![i] as Map<String, dynamic>;
      var points = getAllSubProjects.pointsList![i].toJson();

      if (selectedType != 'Tutti') {
        final objType = objects['description_type_object']?.toString() ?? '';
        if (objType != selectedType) continue;
      }

      if (query.isNotEmpty) {
        bool objectMatch = _searchInMap(objects, query);
        bool pointMatch = _searchInMap(points, query);
        if (!objectMatch && !pointMatch) continue;
      }

      if (indrizioQueryLower.isNotEmpty) {
        bool indrizioMatch = false;
        if (points['details_point'] != null && points['details_point'] is Map) {
          final detailsPoint = points['details_point'] as Map;
          if (detailsPoint.containsKey('Indirizzo')) {
            final indirizzo = detailsPoint['Indirizzo']
                .toString()
                .toLowerCase();
            if (indirizzo.contains(indrizioQueryLower)) indrizioMatch = true;
          }
        }
        if (!indrizioMatch) continue;
      }

      if (dataInizioQueryLower.isNotEmpty) {
        bool dataInizioMatch = false;
        if (objects['details_object'] != null &&
            objects['details_object'] is Map) {
          final detailsObject = objects['details_object'] as Map;
          if (detailsObject.containsKey('Data Inizio Vita')) {
            final dataInizio = detailsObject['Data Inizio Vita']
                .toString()
                .toLowerCase();
            if (dataInizio.contains(dataInizioQueryLower))
              dataInizioMatch = true;
          }
        }
        if (!dataInizioMatch) continue;
      }

      if (dataFineQueryLower.isNotEmpty) {
        bool dataFineMatch = false;
        if (objects['details_object'] != null &&
            objects['details_object'] is Map) {
          final detailsObject = objects['details_object'] as Map;
          if (detailsObject.containsKey('Data Fine Vita')) {
            final dataFine = detailsObject['Data Fine Vita']
                .toString()
                .toLowerCase();
            if (dataFine.contains(dataFineQueryLower)) dataFineMatch = true;
          }
        }
        if (!dataFineMatch) continue;
      }

      filteredIndices.add(i);
    }
    return filteredIndices;
  }

  // Export to PDF
  Future<void> _exportToPDF() async {
    try {
      final filteredIndices = _getFilteredIndices();
      if (filteredIndices.isEmpty) {
        Get.snackbar('Error', 'No data to export');
        return;
      }

      final pdf = pw.Document();

      for (var index in filteredIndices) {
        var objects =
            getAllSubProjects.objectsList![index] as Map<String, dynamic>;
        var points = getAllSubProjects.pointsList![index].toJson();

        pdf.addPage(
          pw.Page(
            pageFormat: PdfPageFormat.a4,
            build: (pw.Context context) {
              return pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    'Dettagli oggetto',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...objects.entries.map(
                    (entry) => pw.Text('${entry.key}: ${entry.value}'),
                  ),
                  pw.SizedBox(height: 20),
                  pw.Text(
                    'Dettagli punto',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 10),
                  ...points.entries.map(
                    (entry) => pw.Text('${entry.key}: ${entry.value}'),
                  ),
                ],
              );
            },
          ),
        );
      }

      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
      Get.snackbar('Success', 'PDF exported successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to export PDF: $e');
    }
  }

  Future<void> _exportToExcel() async {
    try {
      final filteredIndices = _getFilteredIndices();
      if (filteredIndices.isEmpty) {
        Get.snackbar('Error', 'No data to export');
        return;
      }

      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Objects'];
      Sheet sheetPoint = excel['Points'];

      // Add headers for Objects sheet
      sheetObject.appendRow([
        TextCellValue('id_object'),
        TextCellValue('id_position'),
        TextCellValue('code_object'),
        TextCellValue('id_type_object'),
        TextCellValue('description_type_object'),
        TextCellValue('details_object'),
      ]);

      // Add headers for Points sheet
      sheetPoint.appendRow([
        TextCellValue('id_point'),
        TextCellValue('description_point'),
        TextCellValue('id_type_point'),
        TextCellValue('description_type_point'),
        TextCellValue('id_position'),
        TextCellValue('details_point'),
      ]);

      for (var index in filteredIndices) {
        var objects =
            getAllSubProjects.objectsList![index] as Map<String, dynamic>;
        var points = getAllSubProjects.pointsList![index].toJson();

        // Add object data
        sheetObject.appendRow([
          TextCellValue(objects['id_object']?.toString() ?? ''),
          TextCellValue(objects['id_position']?.toString() ?? ''),
          TextCellValue(objects['code_object']?.toString() ?? ''),
          TextCellValue(objects['id_type_object']?.toString() ?? ''),
          TextCellValue(objects['description_type_object']?.toString() ?? ''),
          TextCellValue(objects['details_object']?.toString() ?? ''),
        ]);

        // Add point data
        sheetPoint.appendRow([
          TextCellValue(points['id_point']?.toString() ?? ''),
          TextCellValue(points['description_point']?.toString() ?? ''),
          TextCellValue(points['id_type_point']?.toString() ?? ''),
          TextCellValue(points['description_type_point']?.toString() ?? ''),
          TextCellValue(points['id_position']?.toString() ?? ''),
          TextCellValue(points['details_point']?.toString() ?? ''),
        ]);
      }

      // Request storage permission
      if (Platform.isAndroid) {
        var status = await Permission.storage.status;
        if (!status.isGranted) {
          await Permission.storage.request();
        }
      }

      // Save in Downloads folder (Android) or Documents (iOS)
      Directory? directory;
      if (Platform.isAndroid) {
        directory = Directory('/storage/emulated/0/Download');
        if (!await directory.exists()) {
          directory = await getExternalStorageDirectory();
        }
      } else {
        directory = await getApplicationDocumentsDirectory();
      }

      final filePath =
          '${directory!.path}/project_details_${DateTime.now().millisecondsSinceEpoch}.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      Get.snackbar('Success', 'Excel exported successfully');

      // Open file automatically
      await OpenFile.open(filePath);
    } catch (e) {
      Get.snackbar('Error', 'Failed to export Excel: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.focusScope.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text("Project Details", style: TextStyle(color: Colors.white)),
          backgroundColor: AppColors.primaryColor,
          actions: [
            PopupMenuButton<String>(
              icon: Icon(Icons.file_download, color: Colors.white),
              onSelected: (value) async {
                if (value == 'pdf') {
                  await _exportToPDF();
                } else if (value == 'excel') {
                  await _exportToExcel();
                }
              },
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: 'pdf',
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf),
                      SizedBox(width: 8),
                      Text('Export PDF'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'excel',
                  child: Row(
                    children: [
                      Icon(Icons.table_chart),
                      SizedBox(width: 8),
                      Text('Export Excel'),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: screenPadding,
          child: Column(
            children: [
              HeightBox(20),
              // Search Field
              SizedBox(
                height: context.screenHeight * 0.06,
                child: Theme(
                  data: Theme.of(context).copyWith(
                    textSelectionTheme: TextSelectionThemeData(
                      cursorColor: AppColors.primaryColor,
                      selectionColor: AppColors.primaryColor.withOpacity(0.3),
                      selectionHandleColor: AppColors.primaryColor,
                    ),
                  ),
                  child: TextField(
                    cursorColor: AppColors.primaryColor,
                    controller: _searchController,
                    onChanged: (value) {
                      searchQuery.value = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Cerca',
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 5,
                        horizontal: 16,
                      ),
                      prefixIcon: const Icon(
                        FontAwesomeIcons.magnifyingGlass,
                        size: 15,
                        color: Color(0xFF80899C),
                      ),
                      suffixIcon: Obx(
                        () => searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF80899C),
                                  size: 20,
                                ),
                                onPressed: () {
                                  searchQuery.value = '';
                                  _searchController.clear();
                                },
                              )
                            : const SizedBox.shrink(),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Color(0xFF80899C)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(color: Color(0xFF80899C)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(50),
                        borderSide: const BorderSide(
                          color: Color(0xFF80899C),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              HeightBox(15),
              // Dropdown Filter
              Row(
                children: [
                  Obx(
                    () => Expanded(
                      child: Container(
                        height: context.screenHeight * 0.06,
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: const Color(0xFF80899C)),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedDescriptionType.value,
                            isExpanded: true,
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF80899C),
                            ),
                            style: context.bodyMedium!.copyWith(
                              color: Colors.black87,
                            ),
                            items: descriptionTypes
                                .map(
                                  (String type) => DropdownMenuItem<String>(
                                    value: type,
                                    child: Text(type),
                                  ),
                                )
                                .toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null)
                                selectedDescriptionType.value = newValue;
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Filters",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildFilterField(
                                _indrizioController,
                                indrizioQuery,
                                'Indirizzo',
                              ),
                              HeightBox(20),
                              _buildFilterField(
                                _datainiziovitaController,
                                datainiziovitaQuery,
                                'Data Inizio Vita',
                              ),
                              HeightBox(20),
                              _buildFilterField(
                                _datafinevitaController,
                                datafinevitaQuery,
                                'Data Fine Vita',
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: Colors.transparent,
                        isScrollControlled: true,
                      );
                    },
                    icon: const Icon(Iconsax.filter5),
                  ),
                ],
              ),
              HeightBox(20),
              Expanded(
                child: Obx(() {
                  final filteredIndices = _getFilteredIndices();

                  if (filteredIndices.isEmpty) {
                    return Center(
                      child: Text(
                        'Nessun risultato trovato',
                        style: context.bodyLarge!.copyWith(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.separated(
                    separatorBuilder: (context, index) => HeightBox(10),
                    itemCount: filteredIndices.length,
                    itemBuilder: (context, index) {
                      final originalIndex = filteredIndices[index];
                      var objects =
                          getAllSubProjects.objectsList![originalIndex]
                              as Map<String, dynamic>;
                      var points = getAllSubProjects.pointsList![originalIndex]
                          .toJson();
                      final objectIdPosition =
                          objects['id_position']?.toString() ?? '';
                      final pointIdPosition =
                          points['id_position']?.toString() ?? '';

                      if (objectIdPosition.isNotEmpty &&
                          objectIdPosition == pointIdPosition) {
                        return _buildCombinedContainer(objects, points);
                      } else {
                        return _buildSeparateContainers(objects, points);
                      }
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterField(
    TextEditingController controller,
    RxString query,
    String hint,
  ) {
    return SizedBox(
      height: Get.context!.screenHeight * 0.06,
      child: Theme(
        data: Theme.of(Get.context!).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: AppColors.primaryColor,
            selectionColor: AppColors.primaryColor.withOpacity(0.3),
            selectionHandleColor: AppColors.primaryColor,
          ),
        ),
        child: TextField(
          cursorColor: AppColors.primaryColor,
          controller: controller,
          onChanged: (value) => query.value = value,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 5,
              horizontal: 16,
            ),
            prefixIcon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
              size: 15,
              color: Color(0xFF80899C),
            ),
            suffixIcon: Obx(
              () => query.isNotEmpty
                  ? IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: Color(0xFF80899C),
                        size: 20,
                      ),
                      onPressed: () {
                        query.value = '';
                        controller.clear();
                      },
                    )
                  : const SizedBox.shrink(),
            ),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Color(0xFF80899C)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(color: Color(0xFF80899C)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(50),
              borderSide: const BorderSide(
                color: Color(0xFF80899C),
                width: 1.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCombinedContainer(
    Map<String, dynamic> objects,
    Map<dynamic, dynamic> points,
  ) {
    return Container(
      padding: defaultPadding,
      decoration: BoxDecoration(
        color: Color(0xFFEEE9E9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: crossAxisStart,
        children: [
          Text(
            "Dettagli oggetto",
            style: Get.context!.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: objects.entries
                .map((entry) => Text("${entry.key} : ${entry.value}"))
                .toList(),
          ),
          HeightBox(10),
          Text(
            "Dettagli punto",
            style: Get.context!.bodyMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: points.entries
                .map((entry) => Text("${entry.key} : ${entry.value}"))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSeparateContainers(
    Map<String, dynamic> objects,
    Map<dynamic, dynamic> points,
  ) {
    return Column(
      crossAxisAlignment: crossAxisStart,
      children: [
        Container(
          width: double.infinity,
          padding: defaultPadding,
          decoration: BoxDecoration(
            color: Color(0xFFEEE9E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: crossAxisStart,
            children: [
              Text(
                "Dettagli oggetto",
                style: Get.context!.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: objects.entries
                    .map((entry) => Text("${entry.key} : ${entry.value}"))
                    .toList(),
              ),
            ],
          ),
        ),
        HeightBox(10),
        Container(
          width: double.infinity,
          padding: defaultPadding,
          decoration: BoxDecoration(
            color: Color(0xFFEEE9E9),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: crossAxisStart,
            children: [
              Text(
                "Dettagli punto",
                style: Get.context!.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: points.entries
                    .map((entry) => Text("${entry.key} : ${entry.value}"))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
