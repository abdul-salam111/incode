// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/interventions_screen_conttroller.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/models/intervention_model.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/components.dart';
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:in_code/utils/utils.dart';

class InterventiScreen extends StatefulWidget {
  const InterventiScreen({super.key});

  @override
  State<InterventiScreen> createState() => _InterventiScreenState();
}

class _InterventiScreenState extends State<InterventiScreen> {
  final controller = Get.put(InterventionController());
  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Obx(
          () => Text(
            languageController.getTranslation('interventions'),
            style: Theme.of(context).textTheme.displayLarge!.copyWith(
              color: AppColors.textColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
        ),
        centerTitle: false,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: _InterventionList(),
    );
  }
}

class _InterventionList extends StatefulWidget {
  @override
  State<_InterventionList> createState() => _InterventionListState();
}

class _InterventionListState extends State<_InterventionList> {
  final InterventionController controller = Get.find<InterventionController>();
  final NavbarController navbarController = Get.find<NavbarController>();
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );

  @override
  void initState() {
    super.initState();
    navbarController.interventiScrollController.addListener(_onScroll);
  }

  Future<void> _onRefresh() async {
    controller.resetPagination();
    _refreshController.refreshCompleted();
  }

  @override
  void dispose() {
    navbarController.interventiScrollController.removeListener(_onScroll);
    _refreshController.dispose();
    super.dispose();
  }

 void _onScroll() {
  if (navbarController.interventiScrollController.position.pixels >=
      navbarController.interventiScrollController.position.maxScrollExtent - 200) {
    controller.loadNextPage(); // Changed from fetchAllInterventions()
  }
}
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Get filtered interventions
      final displayedInterventions = controller.filteredInterventions;

      if (controller.interventions.isEmpty &&
          controller.hasConnectionError.value) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.wifi_off, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                "Nessuna connessione internet",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Impossibile caricare gli interventi",
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                         await controller.fetchAllInterventionsFromAPI(); // Changed
                        if (controller.hasConnectionError.value) {
                          Utils.anotherFlushbar(
                            context,
                            "Errore di connessione. Riprova.",
                            Colors.red,
                          );
                        } else {
                          Utils.anotherFlushbar(
                            context,
                            "Interventi caricati con successo",
                            Colors.green,
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: controller.isLoading.value
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.white,
                          ),
                        ),
                      )
                    : Text(
                        "Riprova",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ],
          ),
        );
      } else if (controller.interventions.isEmpty) {
        return LoadingIndicator();
      }

      return Column(
        children: [
          HeightBox(20),
          // Search Field
          Padding(
            padding: screenPadding,
            child: SizedBox(
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
                  controller: controller.searchController,
                  onChanged: (value) {
                    controller.searchQuery.value = value;
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
                    suffixIcon: controller.searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Color(0xFF80899C),
                              size: 20,
                            ),
                            onPressed: () {
                              controller.searchQuery.value = '';
                              controller.searchController.clear();
                            },
                          )
                        : const SizedBox.shrink(),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF80899C)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF80899C)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                        color: Color(0xFF80899C),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          HeightBox(15),

          // Show "No results" message when search returns empty
          if (displayedInterventions.isEmpty &&
              controller.searchQuery.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      FontAwesomeIcons.magnifyingGlass,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Nessun risultato trovato",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Prova con termini di ricerca diversi",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: SmartRefresher(
                controller: _refreshController,
                header: MaterialClassicHeader(color: AppColors.primaryColor),
                enablePullDown: true,
                onRefresh: _onRefresh,
                child: ListView.builder(
                  controller: navbarController.interventiScrollController,
                  itemCount: displayedInterventions.length + 1,
                  itemBuilder: (context, index) {
                    if (index >= displayedInterventions.length) {
                      // Don't show loading/error indicators when searching
                      if (controller.searchQuery.isNotEmpty) {
                        return const SizedBox.shrink();
                      }

                      // Show Retry button if there's a connection error
                      if (controller.hasConnectionError.value) {
                        return Container(
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                            child: Column(
                              children: [
                                Text(
                                  "Nessuna connessione internet",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                Center(
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading.value
                                        ? null
                                        : () async {
                                            final prevCount =
                                                controller.interventions.length;
                                       controller.loadNextPage();
                                            if (controller
                                                .hasConnectionError
                                                .value) {
                                              Utils.anotherFlushbar(
                                                context,
                                                "Errore di connessione. Riprova.",
                                                Colors.red,
                                              );
                                            } else if (controller
                                                    .interventions
                                                    .length >
                                                prevCount) {
                                              Utils.anotherFlushbar(
                                                context,
                                                "Interventi caricati con successo",
                                                Colors.green,
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                    ),
                                    child: controller.isLoading.value
                                        ? SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                    Colors.white,
                                                  ),
                                            ),
                                          )
                                        : Text(
                                            "Riprova",
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }
                      // Show loading indicator if there's more data to load
                      if (controller.hasMoreData.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(child: LoadingIndicator(size: 30)),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 32.0,
                            bottom: 80.0,
                          ),
                          child: Center(
                            child: Text(
                              "Non ci sono più interventi da caricare",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        );
                      }
                    }
                    return _buildInterventionCard(
                      context,
                      displayedInterventions[index],
                    );
                  },
                ),
              ),
            ),
        ],
      );
    });
  }
}

Widget _buildInterventionCard(
  BuildContext context,
  InterventionModel intervention,
) {
  final DateTime dateTime = DateTime.parse(
    intervention.datetimeIntervention.toString(),
  );
  final String formattedDate = DateFormat('dd/MM/yyyy').format(dateTime);
  final String formattedTime = DateFormat('HH:mm:ss').format(dateTime);
  Color cardColor = hexToColor(intervention.interventionColor.toString());

  bool isNotEmpty(String? value) => value != null && value.trim().isNotEmpty;

  final detailsPointMap = intervention.detailsPoint!.toJson()
    ..removeWhere((key, value) => value == null || value.toString().isEmpty);
  final detailsObjectMap = intervention.detailsObject!.toJson()
    ..removeWhere((key, value) => value == null || value.toString().isEmpty);
  detailsObjectMap.updateAll((key, value) {
    try {
      final date = DateTime.parse(value);
      return DateFormat('dd/MM/yyyy').format(date);
    } catch (e) {
      return value; // Return original value if parsing fails
    }
  });
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border(left: BorderSide(width: 5, color: cardColor)),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.1),
          blurRadius: 6,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                _getIconFromName(
                  intervention.interventionIcon ?? InterventionIcon.LIST_ALT,
                ),
                color: cardColor,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  intervention.descriptionTypeIntervention ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            "$formattedDate  $formattedTime",
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 5),

          if (isNotEmpty(intervention.userFullName))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Eseguito da: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.userFullName),
                ],
              ),
            ),

          if (isNotEmpty(intervention.descriptionIntervention))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Note: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionIntervention),
                ],
              ),
            ),
          if (isNotEmpty(intervention.descriptionCompany)) Divider(),

          if (isNotEmpty(intervention.descriptionCompany))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Azienda: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionCompany),
                ],
              ),
            ),

          if (isNotEmpty(intervention.descriptionTypeProject))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Progetto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionTypeProject),
                ],
              ),
            ),

          if (isNotEmpty(intervention.titleProject))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Titolo progetto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.titleProject),
                ],
              ),
            ),

          if (isNotEmpty(intervention.subtitleProject))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Sottotitolo progetto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.subtitleProject),
                ],
              ),
            ),

          if (isNotEmpty(intervention.descriptionPoint))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Punto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionPoint),
                ],
              ),
            ),

          if (isNotEmpty(intervention.descriptionTypePoint))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Tipo punto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionTypePoint),
                ],
              ),
            ),

          if (detailsPointMap != null && detailsPointMap.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dettagli punto:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._buildDetailsWidgets(detailsPointMap, context),
                ],
              ),
            ),

          if (isNotEmpty(intervention.descriptionTypeObject) &&
              detailsPointMap.isEmpty)
            Divider(),

          if (isNotEmpty(intervention.descriptionTypeObject))
            RichText(
              text: TextSpan(
                style: DefaultTextStyle.of(context).style,
                children: [
                  const TextSpan(
                    text: "Tipo oggetto: ",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(text: intervention.descriptionTypeObject),
                ],
              ),
            ),

          if (detailsObjectMap != null && detailsObjectMap.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Dettagli oggetto:",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ..._buildDetailsWidgets(detailsObjectMap, context),
                ],
              ),
            ),
        ],
      ),
    ),
  );
}

List<Widget> _buildDetailsWidgets(
  Map<String, dynamic> detailsMap,
  BuildContext context,
) {
  return detailsMap.entries.map((entry) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(
              text: "${_capitalizeFirstLetter(entry.key)}: ",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(text: entry.value.toString()),
          ],
        ),
      ),
    );
  }).toList();
}

String _capitalizeFirstLetter(String input) {
  if (input.isEmpty) return input;
  return input[0].toUpperCase() + input.substring(1);
}

Color hexToColor(String? hex) {
  if (hex == null || hex.trim().isEmpty) {
    return Colors.grey; // default grey color
  }
  hex = hex.trim().replaceAll("#", "");
  if (hex.length == 6) {
    hex = "FF$hex";
  }
  try {
    return Color(int.parse("0x$hex"));
  } catch (e) {
    return Colors.grey; // fallback if parsing fails
  }
}

IconData _getIconFromName(InterventionIcon icon) {
  switch (icon) {
    case InterventionIcon.BACON:
      return FontAwesomeIcons.bacon;
    case InterventionIcon.CAMERA:
      return FontAwesomeIcons.camera;
    case InterventionIcon.DOWNLOAD:
      return FontAwesomeIcons.download;
    case InterventionIcon.LIST_ALT:
      return FontAwesomeIcons.rectangleList;
    case InterventionIcon.UPLOAD:
      return FontAwesomeIcons.upload;
  }
}
