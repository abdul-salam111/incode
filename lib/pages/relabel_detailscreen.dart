// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/dettaglioggetto_controller.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/controllers/utiliti_screen_controller.dart';
import 'package:in_code/pages/relabel_scanner.dart';
import 'package:in_code/res/colors.dart';

class DetailRelabelScreen extends StatefulWidget {
  @override
  _DetailRelabelScreenState createState() => _DetailRelabelScreenState();
}

class _DetailRelabelScreenState extends State<DetailRelabelScreen> {
  bool _objectMatchesSearch(Map<String, dynamic> obj, String term) {
  bool matchInText(String? text) =>
      text?.toLowerCase().contains(term) ?? false;

  bool matchInMap(Map<String, dynamic>? map) {
    if (map == null) return false;
    return map.entries.any((entry) =>
        entry.key.toLowerCase().contains(term) ||
        entry.value.toString().toLowerCase().contains(term));
  }

  return matchInText(obj['code_object']) ||
      matchInText(obj['description_type_object']) ||
      matchInText(obj['description_point']) ||
      matchInText(obj['description_type_point']) ||
      matchInMap(obj['details_object']) ||
      matchInMap(obj['details_point']);
}

  List<Widget> _buildKeyValueList(Map<String, dynamic>? dataMap) {
    if (dataMap == null || dataMap.isEmpty) return [];

    return dataMap.entries.map((entry) {
      final key = entry.key;
      final value = entry.value;

      String displayValue;
      try {
        final date = DateTime.parse(value.toString());
        displayValue =
            '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
      } catch (_) {
        displayValue = value.toString();
      }

      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 2),
        child: Text('$key: $displayValue'),
      );
    }).toList();
  }

  String selectedTipologia = '';
  int? selectedObjectId;
  List<Map<String, dynamic>> objectsList = [];
  List<String> tipologie = [];
  bool showTipologie = false;
  bool isLoading = false;
  bool isSearching = false;
  String searchTerm = '';
  late TextEditingController _searchController; // Add persistent controller

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // Initialize controller
    fetchObjects();
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose controller
    super.dispose();
  }

  void fetchObjects() async {
    final utilitiScreenController = Get.find<UtilitiScreenController>();
    final response = utilitiScreenController.oldProjectMap;

    final List<Map<String, dynamic>> rawObjects =
        List<Map<String, dynamic>>.from(response['objects_list'] ?? []);
    final List<Map<String, dynamic>> pointsList =
        List<Map<String, dynamic>>.from(response['points_list'] ?? []);

    final List<Map<String, dynamic>> mergedObjects = [];

    for (var object in rawObjects) {
      final matchingPoint = pointsList.firstWhere(
        (point) => point['id_position'] == object['id_position'],
        orElse: () => {},
      );

      mergedObjects.add({
        'id_object': object['id_object'],
        'code_object': object['code_object'],
        'description_type_object': object['description_type_object'],
        'details_object': object['details_object'] ?? {},
        'description_point': matchingPoint['description_point'] ?? '',
        'description_type_point': matchingPoint['description_type_point'] ?? '',
        'details_point': matchingPoint['details_point'] ?? {},
      });
    }

    setState(() {
      objectsList = mergedObjects;
      tipologie = [
        'Tutte', // Add "Tutte" as first option
        ...{...mergedObjects.map((e) => e['description_type_object'] as String)},
      ];
      selectedTipologia = 'Tutte'; // Set "Tutte" as default
      isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    // First filter by tipologia if selected
    List<Map<String, dynamic>> filteredObjects = selectedTipologia.isEmpty || selectedTipologia == 'Tutte'
        ? objectsList
        : objectsList
            .where((obj) =>
                obj['description_type_object'] == selectedTipologia)
            .toList();

    // Then filter by search term - only show matching items
    if (isSearching && searchTerm.isNotEmpty) {
      filteredObjects = filteredObjects
          .where((obj) => _objectMatchesSearch(obj, searchTerm))
          .toList();
    }


    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        title: const Text(
          'Sostituisci etichetta',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: size.height * 0.06,
                  child: Theme(
                    data: Theme.of(context).copyWith(
                      textSelectionTheme: TextSelectionThemeData(
                        cursorColor: AppColors.primaryColor, // cursor color
                        selectionColor: AppColors.primaryColor.withOpacity(
                          0.3,
                        ), // text highlight
                        selectionHandleColor:
                            AppColors.primaryColor, // tear-drop handle color
                      ),
                    ),
                    child: TextField(
                      cursorColor: AppColors.primaryColor,
                      controller: _searchController, // Use persistent controller
                      onChanged: (value) {
                        setState(() {
                          searchTerm = value.toLowerCase();
                          isSearching = searchTerm.isNotEmpty;
                        });
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
                        suffixIcon: searchTerm.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF80899C),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchTerm = '';
                                    isSearching = false;
                                    _searchController.clear(); // Clear controller text
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Color(0xFF80899C),
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: const BorderSide(
                            color: Color(0xFF80899C),
                          ),
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
                
                const SizedBox(height: 16),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          showTipologie = !showTipologie;
                        });
                      },
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width * 0.84,
                        padding: const EdgeInsets.symmetric(
                          vertical: 2,
                          horizontal: 12,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: const Color(0xFF80899C)),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              selectedTipologia.isEmpty
                                  ? 'Tipologia oggetto'
                                  : selectedTipologia,
                              style: const TextStyle(fontSize: 16),
                            ),
                            const FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 16,
                              color: Color(0xFF80899C),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(
                      FontAwesomeIcons.filter,
                      size: 17,
                      color: Color(0xFF80899C),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (showTipologie)
                  Expanded(
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0EBEB),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: tipologie.map((tipo) {
                              final isSelected = tipo == selectedTipologia;
                              return Column(
                                children: [
                                  ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                    title: Text(
                                      tipo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    trailing: isSelected
                                        ? const Icon(
                                            Icons.check_circle,
                                            color: AppColors.primaryColor,
                                            size: 20,
                                          )
                                        : null,
                                    onTap: () async {
                                      setState(() {
                                        selectedTipologia = tipo;
                                        showTipologie = false;
                                        isLoading = true;
                                      });
                                      await Future.delayed(
                                        const Duration(seconds: 2),
                                      );
                                      setState(() {
                                        isLoading = false;
                                      });
                                    },
                                  ),
                                  if (tipo != tipologie.last)
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 18.0,
                                      ),
                                      child: Divider(height: 1),
                                    ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                        const SizedBox(height: 8),
                      ],
                    ),
                  ),
                if (!showTipologie && !isLoading)
                  Text(
                    '${filteredObjects.length} Oggetti',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                if (!showTipologie && !isLoading) const SizedBox(height: 8),
                if (!showTipologie && !isLoading)
                  Expanded(
                    child: ListView.separated(
                      itemCount: filteredObjects.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final obj = filteredObjects[index];
                        final isSelected = obj['id_object'] == selectedObjectId;
                        final detailsObject = obj['details_object'];
                        List<String> formattedDetails = [];

                        if (detailsObject != null && detailsObject.isNotEmpty) {
                          detailsObject.forEach((key, value) {
                            if (value != null &&
                                value.toString().trim().isNotEmpty) {
                              try {
                                final date = DateTime.parse(value);
                                final formattedDate =
                                    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
                                formattedDetails.add('$key: $formattedDate');
                              } catch (_) {
                                formattedDetails.add('$key: $value');
                              }
                            }
                          });
                        }
                        return Card(
                          color: Color(0xFFEEE9E9),
                          margin: const EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 4,
                          ),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                selectedObjectId = obj['id_object'];
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  // Left: Object + Project details
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Dettagli oggetto',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (obj['description_type_object'] !=
                                            null)
                                          Text(
                                            'Tipologia oggetto: ${obj['description_type_object']}',
                                          ),
                                        const SizedBox(height: 4),
                                        ..._buildKeyValueList(
                                          obj['details_object'],
                                        ),

                                        const SizedBox(height: 10),

                                        const Text(
                                          'Dettagli progetto',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (obj['description_point'] != null)
                                          Text(
                                            'Punto: ${obj['description_point']}',
                                          ),
                                        if (obj['description_type_point'] !=
                                            null)
                                          Text(
                                            'Tipo Punto: ${obj['description_type_point']}',
                                          ),
                                        const SizedBox(height: 4),
                                        ..._buildKeyValueList(
                                          obj['details_point'],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Right: Checkmark centered vertically
                                  if (isSelected)
                                    const Padding(
                                      padding: EdgeInsets.only(left: 8.0),
                                      child: Icon(
                                        Icons.check_circle,
                                        color: AppColors.primaryColor,
                                        size: 24,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        );
                        // return Card(
                        //    color: Color(0xFFEEE9E9),
                        //   margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                        //   elevation: 2,
                        //   shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //   ),
                        //   child: InkWell(
                        //     onTap: () {
                        //       setState(() {
                        //         selectedObjectId = obj['id_object'];
                        //       });
                        //     },
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(12),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           // Checkmark icon (top right)
                        //           Align(
                        //             alignment: Alignment.center,
                        //             child: isSelected
                        //                 ? const Icon(Icons.check_circle, color: AppColors.primaryColor)
                        //                 : const SizedBox.shrink(),
                        //           ),

                        //           // --- Dettagli Oggetto ---
                        //           const Text(
                        //             'Dettagli oggetto',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15,
                        //             ),
                        //           ),
                        //           const SizedBox(height: 6),
                        //           if (obj['description_type_object'] != null)
                        //             Text('Tipologia oggetto: ${obj['description_type_object']}'),
                        //           const SizedBox(height: 4),
                        //           ..._buildKeyValueList(obj['details_object']),

                        //           const SizedBox(height: 10),

                        //           // --- Dettagli Progetto ---
                        //           const Text(
                        //             'Dettagli progetto',
                        //             style: TextStyle(
                        //               fontWeight: FontWeight.bold,
                        //               fontSize: 15,
                        //             ),
                        //           ),
                        //           const SizedBox(height: 6),
                        //           if (obj['description_point'] != null)
                        //             Text('Punto: ${obj['description_point']}'),
                        //           if (obj['description_type_point'] != null)
                        //             Text('Tipo Punto: ${obj['description_type_point']}'),
                        //           const SizedBox(height: 4),
                        //           ..._buildKeyValueList(obj['details_point']),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // );

                        // return ListTile(
                        //   dense: true,
                        //   contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        //   title: null, // Title not needed since we're putting everything inside subtitle
                        //   subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       // --- Dettagli oggetto ---
                        //       const Text(
                        //         'Dettagli oggetto',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 4),
                        //       if (obj['description_type_object'] != null)
                        //         Text('Tipologia oggetto: ${obj['description_type_object']}'),
                        //       const SizedBox(height: 4),
                        //       ..._buildKeyValueList(obj['details_object']),
                        //       const SizedBox(height: 10),
                        //       // --- Dettagli progetto ---
                        //       const Text(
                        //         'Dettagli progetto',
                        //         style: TextStyle(
                        //           fontWeight: FontWeight.bold,
                        //           fontSize: 14,
                        //         ),
                        //       ),
                        //       const SizedBox(height: 4),
                        //       if (obj['description_point'] != null)
                        //         Text('Punto: ${obj['description_point']}'),
                        //       if (obj['description_type_point'] != null)
                        //         Text('Tipo Punto: ${obj['description_type_point']}'),
                        //       const SizedBox(height: 4),
                        //       ..._buildKeyValueList(obj['details_point']),
                        //     ],
                        //   ),
                        //   trailing: isSelected
                        //       ? const Icon(
                        //           Icons.check_circle,
                        //           color: AppColors.primaryColor,
                        //           size: 20,
                        //         )
                        //       : null,
                        //   onTap: () {
                        //     setState(() {
                        //       selectedObjectId = obj['id_object'];
                        //     });
                        //   },
                        // );
                      },
                    ),
                  ),
                SizedBox(height: 40),
                if (isLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('ANNULLA', AppColors.primaryColor, () {
                  setState(() {
                    selectedObjectId = null;
                  });
                  final navbarController = Get.find<NavbarController>();
                  Get.back();
                }),
                _buildActionButton(
                  'CONTINUA',
                  selectedObjectId == null ? Colors.grey : Color(0xFF3C8F3D),
                  selectedObjectId == null
                      ? () {}
                      : () async {
                          final selected = objectsList.firstWhere(
                            (o) => o['id_object'] == selectedObjectId,
                            orElse: () => {},
                          );
                          final utilitiScreenController = Get.put(
                            UtilitiScreenController(),
                          );
                          utilitiScreenController.relable_idproject =
                              selectedObjectId!;
                          print('this is id object ${selectedObjectId}');
                          final navbarController = Get.find<NavbarController>();
                          Get.to(() => RelabelScanner());
                        },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String label, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.4,
        height: MediaQuery.of(context).size.height * 0.07,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
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
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
