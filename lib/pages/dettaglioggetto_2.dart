import 'package:flutter/material.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/dettaglioggetto_controller.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/controllers/scan_controller.dart';
import 'package:in_code/models/get_all_subprojects.dart';
import 'package:in_code/models/scannedQrCode_data.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/res/res.dart';
import 'package:get/get.dart';

class UnifiedDettagliOggettoScreen extends StatelessWidget {
  final ScannedQrCodeDataModel data;

  UnifiedDettagliOggettoScreen({Key? key, required this.data}) : super(key: key);

  final qrCodeController = Get.put(QRCodeController());
  final projectController = Get.put(ProjectScreenController());
  final dettaglioController = Get.put(DettaglioOggettoController());

  @override
  Widget build(BuildContext context) {
    final selectedProjectId = projectController.selectedProjectId?.value;
    final bool isVirgin = data.idProject == null && data.idPoint == null;
    final bool isFromCurrentProject = data.idProject != null &&
        (data.idPoint == null || data.idProject == selectedProjectId);

    final matchedPoint = projectController.getAllSubprojects.value.pointsList?.firstWhere(
      (element) => element.idPoint == data.idPoint,
      orElse: () => PointsList(
        idPoint: 0,
        descriptionPoint: '',
        descriptionTypePoint: '',
        idTypePoint: 0,
        idPosition: null,
        detailsPoint: null,
      ),
    );

    final project = data.idProject != null ? _findProjectById(data.idProject!) : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Text(
          "Scheda Oggetto",
         style: (VxContextExtensions(context).textTheme).titleLarge?.copyWith(
            color: AppColors.textColorWhite,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_hasObjectDetails(data)) _buildObjectDetailsCard(),
            const SizedBox(height: 16),
            if (!isVirgin && project != null) _buildProjectDetailsCard(project, matchedPoint),
            if (!isFromCurrentProject && !isVirgin)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Center(
                  child: Text(
                    'È necessario selezionare il progetto corretto per poter visualizzare l\'intera sezione dei dettagli',
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            if (isVirgin) _buildVirginButtons(),
            
            if (isFromCurrentProject && !isVirgin) _buildCurrentProjectButtons(),
            if (!_hasObjectDetails(data) && !_hasPointsDetails(data))
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
        ),
      ),
    );
  }

  Map<String, dynamic>? _findProjectById(int idProject) {
    for (var category in projectController.allCategories.value) {
      for (var project in category.projects) {
        if (project.id == idProject) {
          return {
            'id': project.id,
            'title': project.title,
            'subtitle': project.subtitle,
          };
        }
      }
    }
    return null;
  }

  Widget _buildObjectDetailsCard() {
    return Card(
      elevation: 1,
      color: const Color(0xFFEEE9E9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dettagli Oggetto", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (data.descriptionTypeObject?.isNotEmpty == true)
              _buildDetailRow("Descrizione oggetto", data.descriptionTypeObject!),
            if (data.detailsObject != null)
              ...data.detailsObject!.toJson().entries
                  .where((e) => e.value != null && e.value.toString().isNotEmpty)
                  .map((e) => _buildDetailRow(e.key, e.value.toString())),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectDetailsCard(Map<String, dynamic> project, PointsList? point) {
    if (point?.descriptionPoint != null) {
      print('this is point ${point!.descriptionPoint}');
    }
    if (point?.descriptionTypePoint != null) {
      print('this is point ${point!.descriptionTypePoint}');
    }
    return Card(
      elevation: 1,
      color: const Color(0xFFEEE9E9),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Dettagli Progetto", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildDetailRow("Progetto", project['title'] ?? 'N/A'),
            _buildDetailRow("Sottotitolo progetto", project['subtitle'] ?? 'N/A'),
           if (point?.descriptionPoint != null && point!.descriptionPoint!.isNotEmpty &&
    point.descriptionTypePoint != null && point.descriptionTypePoint!.isNotEmpty)
     ...[
              _buildDetailRow("Tipologia Punto", point.descriptionTypePoint ?? ''),
              _buildDetailRow("Descrizione Punto", point.descriptionPoint ?? ''),
              if (point.detailsPoint?.toJson().isNotEmpty == true)
                ...point.detailsPoint!.toJson().entries.map(
                  (e) => _buildDetailRow(e.key, e.value.toString()),
                ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _buildVirginButtons() {
    return Column(
      children: [
        _buildActionButton("Seleziona un punto", () {
          Get.find<NavbarController>().navigatetoSelezinaPunto();
        }),
        const SizedBox(height: 12),
        _buildActionButton("Installazione libera", () {
          dettaglioController.DettaglioggettoPostData(
            box.read(userId),
            qrCodeController.scannedImage.value,
            projectController.selectedProjectId!.value,
            0,
            1,
          );
        }),
      ],
    );
  }

  Widget _buildCurrentProjectButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        children: [
          _buildActionButton("Esegui intervento", () {
            Get.find<NavbarController>().navigateEseguiInterventoScreen();
          }),
          const SizedBox(height: 12),
          _buildActionButton("Cambia posizione", () {
            Get.find<NavbarController>().navigateTocambiaPosizone();
          }),
          const SizedBox(height: 12),
          _buildActionButton("Rimuovi da progetto", () {
            dettaglioController.removeObjectFromProject(
              version: 2.0,
              idUser: box.read(userId),
              codeObject: qrCodeController.scannedImage.value,
              idProject: projectController.selectedProjectId!.value,
              idPoint: data.idPoint ?? 0,
            );
          }),
        ],
      ),
    );
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
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: AppColors.textColorPrimary),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        ),
        child: Text(
          text,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  bool _hasObjectDetails(ScannedQrCodeDataModel data) {
    return data.idObject != null ||
        data.idTypeObject != null ||
        (data.descriptionTypeObject?.isNotEmpty == true) ||
        (data.detailsObject?.dataInizioVita?.isNotEmpty == true) ||
        (data.detailsObject?.dataFineVita?.isNotEmpty == true);
  }

  bool _hasPointsDetails(ScannedQrCodeDataModel data) {
    return data.idPosition != null || data.idPoint != null || data.idProject != null;
  }
}





// class DettagliOggettoScreen2 extends StatefulWidget {
//   QRCodeController qrCodecontroller = Get.put(QRCodeController());
//   final ScannedQrCodeDataModel? data;
//   DettaglioOggettoController detailController = Get.put(
//     DettaglioOggettoController(),
//   );
//   final projectScreenController = Get.find<ProjectScreenController>();
//   DettagliOggettoScreen2({Key? key, required this.data}) : super(key: key);

//   @override
//   _DettagliOggettoScreen2State createState() => _DettagliOggettoScreen2State();
// }

// class _DettagliOggettoScreen2State extends State<DettagliOggettoScreen2> {
//   @override
//   Widget build(BuildContext context) {
//     print('this is details object ${widget.data!.detailsObject!.otherDetails}');
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.secondaryColor,
//         title: Text(
//           "Scheda",
//           style: context.titleLarge!.copyWith(
//             color: AppColors.textColorWhite,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//             fontFamily: 'Roboto',
//           ),
//         ),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             if (_hasObjectDetails(widget.data!)) ...[
//               Card(
//                 elevation: 1,
//                 color: Color(0xFFEEE9E9),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0), // Reduced padding
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text(
//                         "Dettagli Oggetto",
//                         style: TextStyle(
//                           fontSize: 16, // Reduced font size
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       const SizedBox(height: 12), // Reduced spacing
//                       // if (widget.data!.idObject != null)
//                       //   _buildDetailRow(
//                       //     "ID Object",
//                       //     widget.data!.idObject.toString(),
//                       //   ),
//                       // if (widget.data!.idTypeObject != null)
//                       //   _buildDetailRow(
//                       //     "Type Object ID",
//                       //     widget.data!.idTypeObject.toString(),
//                       //   ),
                      
//                       if (widget.data!.descriptionTypeObject != null &&
//                           widget.data!.descriptionTypeObject!.isNotEmpty)
//                         _buildDetailRow(
//                           "Type Description",
//                           widget.data!.descriptionTypeObject.toString(),
//                         ),
//                       if (widget.data?.detailsObject != null &&
//         widget.data!.detailsObject !=null)
//       ...widget.data!.detailsObject!.toJson().entries
//           .where((e) => e.value != null && e.value.toString().isNotEmpty)
//           .map((e) => _buildDetailRow(e.key, e.value.toString()))
//           .toList(),

//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),
//             ],
//             // Card(
//             //   elevation: 1,
//             //   color:Color(0xFFEEE9E9),
//             //   child: Padding(
//             //     padding: const EdgeInsets.all(12.0), // Reduced padding
//             //     child: Column(
//             //       crossAxisAlignment: CrossAxisAlignment.start,
//             //       children: [
//             //         const Text(
//             //           "Dettagli Progetto",
//             //           style: TextStyle(
//             //             fontSize: 16, // Reduced font size
//             //             fontWeight: FontWeight.bold,
//             //           ),
//             //         ),
//             //         const SizedBox(height: 12), // Reduced spacing
//             //         if (widget.data!.idPosition != null)
//             //           _buildDetailRow(
//             //             "Position ID",
//             //             widget.data!.idPosition.toString(),
//             //           ),
//             //         if (widget.data!.idPoint != null)
//             //           _buildDetailRow(
//             //             "Point ID",
//             //             widget.data!.idPoint.toString(),
//             //           ),
//             //         if (widget.data!.idProject != null)
//             //           _buildDetailRow(
//             //             "Project ID",
//             //             widget.data!.idProject.toString(),
//             //           ),
//             //       ],
//             //     ),
//             //   ),
//             // ),

//             if (!_hasObjectDetails(widget.data!) &&
//                 !_hasPointsDetails(widget.data!)) ...[
//               const Center(
//                 child: Padding(
//                   padding: EdgeInsets.all(32.0),
//                   child: Text(
//                     "No data available",
//                     style: TextStyle(fontSize: 18, color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ],
//             SizedBox(height: 24),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 return SizedBox(
//                   width: constraints.maxWidth > 600 ? 300 : double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       //  Navigate to the next screen with the scanned data
//                       print(
//                         "Seleziona un punto button pressed${widget.qrCodecontroller.scannedImage.value}",
//                       );
//                       NavbarController navbarController =
//                           Get.find<NavbarController>();
//                       navbarController.navigatetoSelezinaPunto();
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(
//                       'Seleziona un punto',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//             SizedBox(height: 12),
//             LayoutBuilder(
//               builder: (context, constraints) {
//                 return SizedBox(
//                   width: constraints.maxWidth > 600 ? 300 : double.infinity,
//                   height: 48,
//                   child: ElevatedButton(
//                     onPressed: () {
//                       final projectController =
//                           Get.find<ProjectScreenController>();
//                       final id_user = box.read(userId);

//                       // Type checks
//                       print(
//                         '🔍 id_user: $id_user,${ widget.qrCodecontroller.scannedImage.value}, ${projectController.selectedProjectId!.value}',
//                       );
//                       if (id_user is int &&
//                           projectController.selectedProjectId!.value is int &&
//                           widget.qrCodecontroller.scannedImage.value
//                               is String) {
//                         print(
//                           "🚀 All types are correct, proceeding with API call",
//                         );
//                         widget.detailController.DettaglioggettoPostData(
//                           id_user,
//                           widget.qrCodecontroller.scannedImage.value.toString(),
//                           projectController.selectedProjectId!.value,
//                           0,
//                           1,
//                         );
//                       } else {
//                         print("❌ One or more variables have incorrect types");
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: AppColors.primaryColor,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       padding: EdgeInsets.symmetric(vertical: 12),
//                     ),
//                     child: Text(
//                       'Installazione libera',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.white,
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   bool _hasObjectDetails(ScannedQrCodeDataModel data) {
//     return data.idObject != null ||
//         data.idTypeObject != null ||
//         (data.descriptionTypeObject != null &&
//             data.descriptionTypeObject!.isNotEmpty) ||
//         (data.detailsObject?.dataInizioVita != null &&
//             data.detailsObject!.dataInizioVita!.isNotEmpty) ||
//         (data.detailsObject?.dataFineVita != null &&
//             data.detailsObject!.dataFineVita!.isNotEmpty);
//   }

//   bool _hasPointsDetails(ScannedQrCodeDataModel data) {
//     return data.idPosition != null ||
//         data.idPoint != null ||
//         data.idProject != null;
//   }

//   Widget _buildDetailRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 120,
//             child: Text(
//               "$label:",
//               style: const TextStyle(
//                 fontWeight: FontWeight.bold,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(
//                 fontSize: 16,
//                 color: AppColors.textColorPrimary,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildActionButton(String text, VoidCallback onPressed) {
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         return SizedBox(
//           width: constraints.maxWidth > 600
//               ? 300
//               : double.infinity, // Adjust width based on screen size
//           height: 48,
//           child: ElevatedButton(
//             onPressed: onPressed,
//             style: ElevatedButton.styleFrom(
//               backgroundColor: AppColors.secondaryColor,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(32),
//               ),
//               padding: const EdgeInsets.symmetric(vertical: 12),
//             ),
//             child: Text(
//               text,
//               style: const TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//                 color: Colors.white,
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
