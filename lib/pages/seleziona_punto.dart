import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/dettaglioggetto_controller.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/res/colors.dart';

class SelezionaPuntoScreen extends StatefulWidget {
  @override
  _SelezionaPuntoScreenState createState() => _SelezionaPuntoScreenState();
}

class _SelezionaPuntoScreenState extends State<SelezionaPuntoScreen> {
  String selectedTipologia = '';
  int? selectedPointId;
  List<Map<String, dynamic>> pointsList = [];
  List<String> tipologie = [];
  bool showTipologie = false;
  bool isLoading = false;
  bool isSearching = false;
  String searchQuery = '';
  late TextEditingController _searchController; // Add persistent controller

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(); // Initialize controller
    fetchPoints();
  }

  @override
  void dispose() {
    _searchController.dispose(); // Dispose controller
    super.dispose();
  }

  void fetchPoints() async {
    final projectScreenController = Get.find<ProjectScreenController>();
    final response = projectScreenController.getAllSubprojects.value;

    if (response.pointsList == null || response.pointsList!.isEmpty) {
      print("No points available.");
      return;
    }

    setState(() {
      pointsList = response.pointsList!
          .map(
            (point) => {
              'id_point': point.idPoint,
              'description_point': point.descriptionPoint ?? '',
              'id_type_point': point.idTypePoint,
              'description_type_point': point.descriptionTypePoint ?? '',
              'id_position': point.idPosition,
              'details_point': point.detailsPoint ?? {},
            },
          )
          .toList();

      tipologie = [
        'Tutte', // Add "Tutte" as first option
        ...{...pointsList.map((e) => e['description_type_point'] as String)},
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
    List<Map<String, dynamic>> basePoints = selectedTipologia.isEmpty || selectedTipologia == 'Tutte'
        ? pointsList
        : pointsList
            .where((p) => p['description_type_point'] == selectedTipologia)
            .toList();
final projectController = Get.find<ProjectScreenController>();
final objectsList = projectController.getAllSubprojects.value.objectsList ?? [];
basePoints = basePoints.where((point) {
  final pointIdPosition = point['id_position'];
  final alreadyUsed = objectsList.any(
    (obj) => obj['id_position'] == pointIdPosition,
  );
  return !alreadyUsed;
}).toList();
    // Then filter by search term - only show matching items
    List<Map<String, dynamic>> filteredPoints = basePoints;
    if (searchQuery.isNotEmpty) {
      filteredPoints = basePoints.where((point) {
        final title = (point['description_type_point'] ?? '').toLowerCase();
        final subtitle = (point['description_point'] ?? '').toLowerCase();

        // Find the matched object as in the card UI
        final projectController = Get.find<ProjectScreenController>();
        final objectsList = projectController.getAllSubprojects.value.objectsList;
        final matchedObject = objectsList?.firstWhere(
          (obj) => obj['id_position'] == point['id_position'],
          orElse: () => null,
        );
        final detailsObject = matchedObject?['details_object'];

        // Flatten detailsObject for search
        String flatten(dynamic value) {
          if (value == null) return '';
          if (value is Map) {
            return value.entries.map((e) => '${e.key.toString().toLowerCase()}: ${flatten(e.value)}').join(' ');
          }
          if (value is Iterable) {
            return value.map((e) => flatten(e)).join(' ');
          }
          return value.toString().toLowerCase();
        }

        final detailsString = flatten(detailsObject);

        final combined = '$title $subtitle $detailsString';
        return combined.contains(searchQuery);
      }).toList();
    }


    return Scaffold(
       resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        elevation: 0,
        title: const Text(
          'Seleziona Punto',
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
      selectionColor: AppColors.primaryColor.withOpacity(0.3), // text highlight
      selectionHandleColor: AppColors.primaryColor, // tear-drop handle color
    ),
  ),
                    child: TextField(
                      
                      cursorColor: Colors.red,
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          isSearching = value.isNotEmpty;
                           searchQuery = value.trim().toLowerCase();
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Cerca',
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 16,
                        ),
                        prefixIcon: Icon(
                          FontAwesomeIcons.magnifyingGlass,
                          size: 15,
                          color: Color(0xFF80899C),
                        ),
                        suffixIcon: searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Color(0xFF80899C),
                                  size: 20,
                                ),
                                onPressed: () {
                                  setState(() {
                                    searchQuery = '';
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
                          borderSide: BorderSide(color: Color(0xFF80899C)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(color: Color(0xFF80899C)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide(
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
                        padding: EdgeInsets.symmetric(
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
                                  ? 'Tipologia punto'
                                  : selectedTipologia,
                              style: TextStyle(fontSize: 16),
                            ),
                            FaIcon(
                              FontAwesomeIcons.chevronDown,
                              size: 16,
                              color: Color(0xFF80899C),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(
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
                            color: Color(0xFFF0EBEB),
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
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18.0,
                                      ),
                                      child: const Divider(height: 1),
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
                    '${filteredPoints.length} Punti',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                if (!showTipologie && !isLoading) const SizedBox(height: 8),
                if (!showTipologie && !isLoading)
                  Expanded(
                    child: ListView.separated(
                      padding: const EdgeInsets.only(bottom: 32), // Add bottom padding
                      itemCount: filteredPoints.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: (context, index) {
                        final point = filteredPoints[index];
                        final isSelected = point['id_point'] == selectedPointId;

                        final projectController =
                            Get.find<ProjectScreenController>();
                        final objectsList = projectController
                            .getAllSubprojects
                            .value
                            .objectsList;

                        final matchedObject = objectsList?.firstWhere(
                          (obj) => obj['id_position'] == point['id_position'],
                          orElse: () => null,
                        );

                        final detailsObject = matchedObject?['details_object'];
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

                        return GestureDetector(
  onTap: () {
    setState(() {
      selectedPointId = point['id_point'];
    });
  },
  child: Stack(
    children: [
      Container(
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryColor : Colors.grey.shade300,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.only(right: 36), // space for check icon
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                point['description_type_point'] ?? '',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),

              // Optional Subtitle
              if (point['description_point'] != null &&
                  point['description_point'].toString().isNotEmpty)
                Text(
                  point['description_point'],
                  style: const TextStyle(fontSize: 14),
                ),

              // Optional Details
              if (formattedDetails.isNotEmpty) ...[
                const SizedBox(height: 6),
                ...formattedDetails.map(
                  (detail) => Text(
                    detail,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),

      // Check Icon Positioned to the right
      if (isSelected)
        Positioned(
          right: 12,
          top: 0,
          bottom: 0,
          child: Center(
            child: Icon(
              Icons.check_circle,
              color: AppColors.primaryColor,
              size: 22,
            ),
          ),
        ),
    ],
  ),
);

                        //  ListTile(
                        //   dense: true,
                        //   contentPadding: const EdgeInsets.symmetric(
                        //     horizontal: 8,
                        //   ),
                        //   title: Text(
                        //     point['description_type_point'],
                        //     style: const TextStyle(fontWeight: FontWeight.w600),
                        //   ),
                        //   subtitle: Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     children: [
                        //       if (point['description_point'] != null &&
                        //           point['description_point']
                        //               .toString()
                        //               .isNotEmpty)
                        //         Text('${point['description_point']}'),
                        //       if (formattedDetails.isNotEmpty) ...[
                        //         const SizedBox(height: 4),
                        //         ...formattedDetails.map(
                        //           (detail) => Text(
                        //             detail,
                        //             style: TextStyle(
                        //               fontSize: 12,
                        //               color: Colors.black,
                        //             ),
                        //           ),
                        //         ),
                        //       ],
                        //     ],
                        //   ),
                        //   isThreeLine: formattedDetails.isNotEmpty,
                        //   trailing: isSelected
                        //       ? const Icon(
                        //           Icons.check_circle,
                        //           color: AppColors.primaryColor,
                        //           size: 20,
                        //         )
                        //       : null,
                        //   onTap: () {
                        //     setState(() {
                        //       selectedPointId = point['id_point'];
                        //     });
                        //   },
                        // );
                     
                      },
                    ),
                  ),
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
          SizedBox(height: 40),
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton('ANNULLA', AppColors.primaryColor, () {
                  setState(() {
                    selectedPointId = null;
                  });
                   print('Tapped on anulla');
                    final navbarController = Get.find<NavbarController>();
                    navbarController.goToTab(7);
                }),
                _buildActionButton(
                  'SALVA',
                  selectedPointId == null ? Colors.grey : Color(0xFF3C8F3D),
                  selectedPointId == null
                      ? () {}
                      : () async {
                          final selected = pointsList.firstWhere(
                            (p) => p['id_point'] == selectedPointId,
                            orElse: () => {},
                          );
                          final dettaglioController =
                              Get.find<DettaglioOggettoController>();
                          final qrCodeController =
                              dettaglioController.qrCodecontroller;
                          final projectController =
                              Get.find<ProjectScreenController>();
                          print('Selected Point: ${ projectController.selectedProjectId!.value} ${qrCodeController.scannedImage.value}${projectController.selectedProjectId!.value} ${selectedPointId} ${userId}');
                          final codeObject =
                              qrCodeController.scannedImage.value;
                          final idProject =
                              projectController.selectedProjectId!.value;
                          final idUser = box.read(userId);

                          if (codeObject != null &&
                              idProject != null &&
                              idUser != null &&
                              selectedPointId != null) {

                            await dettaglioController.DettaglioggettoPostData(
                              idUser,
                              codeObject,
                              idProject,
                              selectedPointId!,
                              1,
                            );
                          } else {
                            Get.snackbar(
                              "Errore",
                              "Dati mancanti per completare l’operazione",
                              backgroundColor: Colors.red.shade100,
                              colorText: Colors.black,
                            );
                          }
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
