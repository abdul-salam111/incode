import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/utiliti_screen_controller.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/pages/relabel_detailscreen.dart';
import 'package:in_code/res/res.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/widgets/components.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:in_code/utils/utils.dart';

class RelabelProjectScreen extends StatefulWidget {
  const RelabelProjectScreen({super.key});

  @override
  State<RelabelProjectScreen> createState() => _RelabelProjectScreenState();
}

class _RelabelProjectScreenState extends State<RelabelProjectScreen> {
  final utilitiController = Get.put(UtilitiScreenController());
  late RefreshController _refreshController;

  @override
  void initState() {
    super.initState();
    _refreshController = RefreshController(initialRefresh: false);
    if (!utilitiController.isDataLoaded.value) {
    utilitiController.fetchProjectsWithCategories().then((_) {
      // Ensure layout rebuild after data is fetched
      Future.delayed(Duration(milliseconds: 100), () {
        if (mounted) setState(() {});
      });
    });
    utilitiController.isDataLoaded.value = true;}
    // if (!controller.isDataLoaded.value) {
    //   controller.fetchProjectsWithCategories();
    //   controller.isDataLoaded.value = true;
    // }
    // utilitiController.searchController.value.clear();
    // utilitiController.query.value = '';
    //  utilitiController.searchProjects();
    //  setState(() {
    //    utilitiController.isloading.value = true ;
    //  });
    // utilitiController.selectedProjectId.value = -1;
  }
  
  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    print("Refreshing projects...");
    try {
      // Reset the data loaded flag to force a fresh fetch
      utilitiController.isDataLoaded.value = false;
      
      // Fetch fresh data
      await utilitiController.fetchProjectsWithCategories();
      print("Projects fetched successfully");
      
      // Reset search and refresh the filtered results
      utilitiController.searchController.value.clear();
      utilitiController.query.value = '';
      utilitiController.searchProjects();
      print("Search completed");
      utilitiController.isloading.value && utilitiController.isloading.value == true ? 
      // Show success message
      Utils.anotherFlushbar(context, "Progetti aggiornati con successo", Colors.green) : null;
    } catch (e) {
      print("Error refreshing projects: $e");
      Utils.anotherFlushbar(context, "Errore nel caricamento dei progetti", Colors.red);
    } finally {
      _refreshController.refreshCompleted();
    }
  }

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageController>();
    return GestureDetector(
      onTap: () => context.focusScope.unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false, // Removed back button
          backgroundColor: AppColors.secondaryColor,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ), // White back button
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            "Sostituisci etichetta", // Updated title
            style: context.displayLarge!.copyWith(
              color: AppColors.textColorWhite,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: padding10,
            child: Column(
              children: [
                HeightBox(context.height * 0.01),

                // New label above search field
                Padding(
                  padding: const EdgeInsets.all(0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Seleziona progetto",
                      style: context.displayLarge!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                10.heightBox,

                // Search field
                Row(
                  children: [
                    Expanded(
                      child: Theme(
                        data: Theme.of(context).copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor, // cursor color
      selectionColor: AppColors.primaryColor.withOpacity(0.3), // text highlight
      selectionHandleColor: AppColors.primaryColor, // tear-drop handle color
    ),
  ),
                        child: Container(
                          decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3), // light grey shadow
        blurRadius: 6,
        spreadRadius: 5,
        // offset: Offset(0, 3), // vertical shadow
      ),
    ],),
                          child: TextField(
                            cursorColor: Colors.red,
                            focusNode: utilitiController.searchFocusNode,
                            controller: utilitiController.searchController.value,
                            onChanged: (val) {
                              utilitiController.query.value = val;
                              utilitiController.searchProjects();
                            },
                            style: context.displayLarge!.copyWith(fontSize: 16),
                            decoration: InputDecoration(
                              isDense: true,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(50),
                                borderSide: BorderSide(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                  color: AppColors.borderColor,
                                ),
                              ),
                              hintText: "Ricerca progetti",
                              suffixIcon: Obx(
                                () => utilitiController.query.value.isNotEmpty
                                    ? IconButton(
                                        onPressed: () {
                                          context.focusScope.unfocus();
                                          utilitiController.searchController.value.clear();
                                          utilitiController.query.value = '';
                                          utilitiController.searchProjects();
                                        },
                                        icon: Icon(Icons.close),
                                      )
                                    : SizedBox.shrink(),
                              ),
                              prefixIcon: const Icon(
                                Iconsax.search_normal,
                                size: 15,
                              ),
                              hintStyle: context.displayLarge!.copyWith(
                                fontSize: 16,
                                color: AppColors.buttonDisabledColor,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                10.heightBox,

                // Category/project list
                Obx(() {
                  final categories = utilitiController.filteredCategories;
                  return categories.isNotEmpty
                      ? Expanded(
                          child: SmartRefresher(
                            controller: _refreshController,
                            header: MaterialClassicHeader(
                              color: AppColors.primaryColor, // Spinner color
                            ),
                            enablePullDown: true,
                            enablePullUp: false, // Disable pull up to load more
                            onRefresh: _onRefresh,
                            physics: const BouncingScrollPhysics(), // Better scroll physics
                            child: ListView.builder(
                              itemCount: categories.length,
                              itemBuilder: (_, i) {
                                final cat = categories[i];
                                final isExpanded = utilitiController.isExpanded(
                                  cat.id.toString(),
                                );

                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    dividerColor: Colors.white,
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        // border: Border.fromBorderSide(BorderSide(color: Colors.grey))
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: ExpansionTile(
                                          initiallyExpanded: isExpanded,
                                          onExpansionChanged: (expanded) =>
                                              utilitiController.toggleExpansion(
                                                cat.id.toString(),
                                              ),
                                          tilePadding:
                                              const EdgeInsets.symmetric(
                                                horizontal: 6,
                                              ),
                                          collapsedIconColor: Colors.white,
                                          trailing: Obx(() {
                                            final expanded = utilitiController
                                                .isExpanded(cat.id.toString());
                                            return AnimatedRotation(
                                              turns: expanded ? 0.5 : 0.0,
                                              duration: const Duration(
                                                milliseconds: 300,
                                              ),
                                              child: Icon(
                                                Iconsax.arrow_down_14,
                                                color: Colors.black,
                                                size: 15,
                                              ).box.roundedFull.p4.white.make(),
                                            );
                                          }),
                                          title: Text(
                                            cat.name,
                                            style: context.bodyLarge!.copyWith(
                                              color: AppColors.textColorWhite,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          backgroundColor:
                                              AppColors.secondaryColor,
                                          collapsedBackgroundColor:
                                              AppColors.secondaryColor,
                                          children: List.generate(cat.projects.length, (
                                            index,
                                          ) {
                                            final project = cat.projects[index];

                                            return GestureDetector(
                                              onTap: () {
                                                print("tapped here");
                                                // controller.selectProject(
                                                //   project.id,
                                                //   context,
                                                // );
                                                print(
                                                  'this is project_id ${project.id}',
                                                );
                                                utilitiController.selectProject(
                                                  project.id,
                                                  context,
                                                );
                                              },
                                              child: Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 14,
                                                ),
                                                width: double.infinity,
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Expanded(
                                                          flex: 10,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                project.title,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                              Text(
                                                                project
                                                                    .subtitle,
                                                                style: const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Expanded(
                                                          flex: 1,
                                                          child: Obx(
                                                            () =>
                                                                utilitiController
                                                                        .selectedProjectId
                                                                        .value ==
                                                                    project.id
                                                                ? (utilitiController
                                                                              .gettingsubjProjects
                                                                              .value &&
                                                                          utilitiController.selectedProjectId.value ==
                                                                              project.id)
                                                                      ? const LoadingIndicator(
                                                                          size:
                                                                              20,
                                                                        )
                                                                      : Icon(
                                                                              Icons.done,
                                                                              color: AppColors.backgroundColor,
                                                                              size: 15,
                                                                            )
                                                                            .box
                                                                            .width(
                                                                              20,
                                                                            )
                                                                            .height(
                                                                              20,
                                                                            )
                                                                            .roundedFull
                                                                            .color(
                                                                              AppColors.primaryColor,
                                                                            )
                                                                            .make()
                                                                : const SizedBox.shrink(),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    if (index !=
                                                        cat.projects.length - 1)
                                                      const Divider(
                                                        height: 16,
                                                        thickness: 1,
                                                        color: Colors.grey,
                                                        indent: 0,
                                                        endIndent: 0,
                                                      ),
                                                  ],
                                                ),
                                              ),
                                            );
                                          }),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        )
                      : Center(
                          child: Obx(
                            () => utilitiController.isloading.value
                                ? LoadingIndicator()
                                : Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: context.width * 0.05,
                                    ),
                                    child: Center(
                                      child: Text(
                                        "Nessun risultato trovato, inserisci il testo correttamente",
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                          ),
                        );
                }),

                Padding(
                  padding: const EdgeInsets.only(bottom: 30),
                  child: Obx(() {
                    final isEnabled =
                        utilitiController.selectedProjectId.value != -1;

                    return GestureDetector(
                      onTap: utilitiController.dataFetched.value == true
                          ? () {
                              print('Continua tapped');
                              // Navigate or perform next action
                              Get.off(() => DetailRelabelScreen());
                            }
                          : null,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.07,
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: utilitiController.dataFetched.value == true
                                ? Colors.green
                                : Colors.grey, // green if enabled, grey if not
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
                              "CONTINUA",
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
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
