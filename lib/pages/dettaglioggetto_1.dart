// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/dettaglioggetto_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/models/get_all_subprojects.dart';
import 'package:in_code/controllers/navbar_controller.dart'; // Ensure NavbarController is imported
import 'package:in_code/res/res.dart';
import 'package:in_code/models/scannedQrCode_data.dart';

class DettagliOggettoScreen1 extends StatefulWidget {
  final ScannedQrCodeDataModel? data;

  DettagliOggettoScreen1({required this.data});

  @override
  State<DettagliOggettoScreen1> createState() => _DettagliOggettoScreen1State();
}

class _DettagliOggettoScreen1State extends State<DettagliOggettoScreen1> {
  final qrCodeController = Get.find<DettaglioOggettoController>();
  final projectController = Get.find<ProjectScreenController>();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print('title & subtitle ${projectController.projectTitle.value}');
    final matchedPoint = projectController.getAllSubprojects.value.pointsList!
        .firstWhere(
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
                    if (projectController.projectTitle.value.isNotEmpty)
                      _buildDetailRow(
                        "Progetto",
                        projectController.projectTitle.value.toString(),
                      ),
                    if (projectController.projectSubtittle.value.isNotEmpty)
                      _buildDetailRow(
                        "Sottotitolo",
                        projectController.projectSubtittle.value.toString(),
                      ),
                    if (matchedPoint!=null) ...[
                      _buildDetailRow(
                        "Tipologia Punto",
                        matchedPoint.descriptionTypePoint ?? '',
                      ),
                      _buildDetailRow(
                        "Descrizione Punto",
                        matchedPoint.descriptionPoint ?? '',
                      ),

                      if (matchedPoint.detailsPoint != null &&
                          matchedPoint.detailsPoint! != 0) ...[
                        if (matchedPoint.detailsPoint != null &&
                            matchedPoint.detailsPoint!.toJson().isNotEmpty) ...[
                          const Padding(
                            padding: EdgeInsets.only(bottom: 12.0),
                            child: Text(
                              "",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          ...matchedPoint.detailsPoint!.toJson().entries.map(
                            (e) => _buildDetailRow(e.key, e.value.toString()),
                          ),
                        ],
                      ],
                    ],
                    // if (widget.data!.idProject != null)
                    //   _buildDetailRow(
                    //     "Project ID",
                    //     widget.data!.idProject.toString(),
                    //   ),
                  ],
                ),
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
            const SizedBox(height: 24),
            _buildActionButton("Esegui intervento", () {
              final navbarController = Get.find<NavbarController>();
              navbarController.navigateEseguiInterventoScreen();
        
            }),
            const SizedBox(height: 12),
            _buildActionButton("Cambia posizione", () {
              final navbarController = Get.find<NavbarController>();
              navbarController.navigateTocambiaPosizone();

            }),
            const SizedBox(height: 12),
            _buildActionButton("Rimuovi da progetto", () {
              final dettaglioController =
                  Get.find<DettaglioOggettoController>();
              final projectController = Get.find<ProjectScreenController>();
              print(
                'removing data ${box.read(userId)}, ${dettaglioController.qrCodecontroller.scannedImage.value}, ${projectController.selectedProjectId!.value} ${widget.data?.idPoint}',
              );
              dettaglioController.removeObjectFromProject(
                version: 2.0,
                idUser: box.read(userId),
                codeObject:
                    dettaglioController.qrCodecontroller.scannedImage.value,
                idProject: projectController.selectedProjectId!.value,
                idPoint: widget.data?.idPoint ?? 0,
              );
            }),
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

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth > 600
              ? 300
              : double.infinity, // Adjust width based on screen size
          height: 48,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              padding: const EdgeInsets.symmetric(vertical: 12),
            ),
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}
