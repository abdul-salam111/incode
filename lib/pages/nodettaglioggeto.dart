import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/models/get_all_subprojects.dart';

import 'package:in_code/models/scannedQrCode_data.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/res/res.dart';

class NodettaglioggetoScreen extends StatefulWidget {
  final ScannedQrCodeDataModel? data;
  NodettaglioggetoScreen({Key? key, required this.data}) : super(key: key);

  @override
  _NodettaglioggetoScreenState createState() => _NodettaglioggetoScreenState();
}

class _NodettaglioggetoScreenState extends State<NodettaglioggetoScreen> {
  final projectController = Get.find<ProjectScreenController>();
  Map<String, dynamic>? findProjectById(int idProject) {
    for (var category in projectController.allCategories.value) {
      for (var project in category.projects) {
        if (project.id == idProject) {
          return {
            'id': project.id,
            'title': project.title,
            'subtitle': project.subtitle,
            // Add other fields as necessary
          }; // ✅ Safely return a Map
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final idProject = widget.data?.idProject;
    final project = idProject != null ? findProjectById(idProject) : null;
    final matchedPoint = projectController.getAllSubprojects.value.pointsList
        ?.firstWhere(
          (element) => element.idPoint == widget.data?.idPoint,
          orElse: () => PointsList(
            idPoint: 0,
            descriptionPoint: '',
            descriptionTypePoint: '',
            idTypePoint: 0,
            idPosition: null,
            detailsPoint: null,
          ),
        );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          "Scheda Oggetto",
          style: context.titleLarge!.copyWith(
            color: AppColors.textColorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'Roboto',
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasObjectDetails(widget.data!)) ...[
              Card(
                elevation: 1,
                color: Color(0xFFEEE9E9),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Dettagli Oggetto",
                        style: TextStyle(
                          fontSize: 16, // Reduced font size for responsiveness
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12), // Reduced spacing
                      // if (widget.data!.idObject != null)
                      //   _buildDetailRow(
                      //     "ID Object",
                      //     widget.data!.idObject.toString(),
                      //   ),
                      // if (widget.data!.idTypeObject != null)
                      //   _buildDetailRow(
                      //     "Type Object ID",
                      //     widget.data!.idTypeObject.toString(),
                      //   ),
                      if (widget.data!.descriptionTypeObject != null &&
                          widget.data!.descriptionTypeObject!.isNotEmpty)
                        _buildDetailRow(
                          "Type Description",
                          widget.data!.descriptionTypeObject.toString(),
                        ),
                      if (widget.data!.detailsObject?.dataInizioVita != null &&
                          widget
                              .data!
                              .detailsObject!
                              .dataInizioVita!
                              .isNotEmpty)
                        _buildDetailRow(
                          "Start Date",
                          widget.data!.detailsObject!.dataInizioVita.toString(),
                        ),
                      if (widget.data!.detailsObject?.dataFineVita != null &&
                          widget.data!.detailsObject!.dataFineVita!.isNotEmpty)
                        _buildDetailRow(
                          "End Date",
                          widget.data!.detailsObject!.dataFineVita.toString(),
                        ),
                      if (widget.data!.detailsObject?.otherDetails.isNotEmpty ==
                          true)
                        ...widget.data!.detailsObject!.otherDetails.entries.map(
                          (entry) {
                            return _buildDetailRow(
                              entry.key,
                              entry.value.toString(),
                            );
                          },
                        ).toList(),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
            Card(
              elevation: 1,
              color: Color(0xFFEEE9E9),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Dettagli Progetto",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (project != null) ...[
                      _buildDetailRow("Progetto", project['title'] ?? 'N/A'),
                      _buildDetailRow(
                        "Indirizzo",
                        project['subtitle'] ?? 'N/A',
                      ),
                    ],
                    // if (projectController.projectSubtittle != null)
                    //   _buildDetailRow(
                    //     "Sottotitolo",
                    //     projectController.projectSubtittle.toString(),
                    //   ),
                    //                 if (matchedPoint != null) ...[
                    //                   _buildDetailRow("Tipologia Punto", matchedPoint.descriptionTypePoint ?? ''),
                    //   _buildDetailRow("Descrizione Punto", matchedPoint.descriptionPoint ?? ''),

                    //   if (matchedPoint.detailsPoint != null && matchedPoint.detailsPoint! != 0) ...[
                    //   if (matchedPoint.detailsPoint != null &&
                    //     matchedPoint.detailsPoint!.toJson().isNotEmpty) ...[
                    //   const Padding(
                    //     padding: EdgeInsets.only(bottom: 12.0),
                    //     child: Text(
                    //       "",
                    //       style: TextStyle(
                    //         fontWeight: FontWeight.bold,
                    //         color: Colors.black,
                    //       ),
                    //     ),
                    //   ),
                    //   ...matchedPoint.detailsPoint!.toJson().entries.map(
                    //     (e) => _buildDetailRow(e.key, e.value.toString()),
                    //   ),
                    // ],
                    // ],
                    // ],
                    // if (widget.data!.idProject != null)
                    //   _buildDetailRow(
                    //     "Project ID",
                    //     widget.data!.idProject.toString(),
                    //   ),
                  ],
                ),
              ),
            ),
            SizedBox(
                height: 20 ,
              ),
               Center(
                 child: Text(
                        'È necessario selezionare il progetto corretto per poter visualizzare l\'intera sezione dei dettagli',
                       style: TextStyle(
                         fontSize: 16,
                         fontWeight: FontWeight.w500,
                         color: Colors.black,
                       ),
                       textAlign: TextAlign.center,
                     ),
               ),
            if (!_hasObjectDetails(widget.data!) &&
                !_hasPointsDetails(widget.data!)) ...[
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    "No data available",
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ),
              ),
              
            ],

            //            SizedBox(height: 24),
            //           _buildActionButton("Seleziona un punto", () {
            //             }),
            //            SizedBox(height: 12),
            //    LayoutBuilder(
            //   builder: (context, constraints) {
            //     return SizedBox(
            //       width: constraints.maxWidth > 600 ? 300 : double.infinity,
            //       height: 48,
            //       child: ElevatedButton(
            //         onPressed: () {
            //           DettaglioOggettoController dettaglioOggettoController = Get.find<DettaglioOggettoController>();
            //           dettaglioOggettoController.DettaglioggettoPostData(
            //             box.read(userId),
            //             widget.data!.idObject,
            //             widget.data!.idProject,
            //             widget.data!.idPoint,
            //             1,
            //           );
            //         },
            //         style: ElevatedButton.styleFrom(
            //           backgroundColor: AppColors.primaryColor,
            //           shape: RoundedRectangleBorder(
            //             borderRadius: BorderRadius.circular(32),
            //           ),
            //           padding:  EdgeInsets.symmetric(vertical: 12),
            //         ),
            //         child: Text(
            //                 'Installazione libera',
            //                 style: TextStyle(
            //                   fontSize: 16,
            //                   fontWeight: FontWeight.bold,
            //                   color: Colors.white,
            //                 ),
            //               ),
            //       ),
            //     );
            //   },
            // )
          ],
        ),
      ),
    );
  }

  bool _hasObjectDetails(ScannedQrCodeDataModel data) {
    return data.idObject != null ||
        data.idTypeObject != null ||
        (data.descriptionTypeObject != null &&
            data.descriptionTypeObject!.isNotEmpty) ||
        (data.detailsObject?.dataInizioVita != null &&
            data.detailsObject!.dataInizioVita!.isNotEmpty) ||
        (data.detailsObject?.dataFineVita != null &&
            data.detailsObject!.dataFineVita!.isNotEmpty);
  }

  bool _hasPointsDetails(ScannedQrCodeDataModel data) {
    return data.idPosition != null ||
        data.idPoint != null ||
        data.idProject != null;
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textColorPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildActionButton(String text, VoidCallback onPressed) {
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       return SizedBox(
  //         width: constraints.maxWidth > 600
  //             ? 300
  //             : double.infinity, // Adjust width based on screen size
  //         height: 48,
  //         child: ElevatedButton(
  //           onPressed: onPressed,
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: AppColors.primaryColor,
  //             shape: RoundedRectangleBorder(
  //               borderRadius: BorderRadius.circular(32),
  //             ),
  //             padding: const EdgeInsets.symmetric(vertical: 12),
  //           ),
  //           child: Text(
  //             text,
  //             style: const TextStyle(
  //               fontSize: 16,
  //               fontWeight: FontWeight.bold,
  //               color: Colors.white,
  //             ),
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}
