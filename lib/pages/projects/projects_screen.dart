// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/pages/projects/project_details.dart';
import 'package:in_code/res/res.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/widgets/components.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ProjectScreen extends StatefulWidget {
  const ProjectScreen({super.key});
  @override
  State<ProjectScreen> createState() => _ProjectScreenState();
}

class _ProjectScreenState extends State<ProjectScreen>
    with WidgetsBindingObserver {
  final controller = Get.put(ProjectScreenController());
  late RefreshController _refreshController;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _refreshController = RefreshController(initialRefresh: false);
    if (!controller.isDataLoaded.value) {
      controller.fetchProjectsWithCategories();
      controller.isDataLoaded.value = true;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-fetch data ONLY if we were previously offline
      if (controller.wasOffline.value) {
        controller.fetchProjectsWithCategories();
        controller.wasOffline.value = false;
      }
    }
  }

  Future<void> _onRefresh() async {
    await controller.fetchProjectsWithCategories();
    controller.searchProjects();
    _refreshController.refreshCompleted();
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
          backgroundColor: AppColors.secondaryColor,
          title: Obx(
            () => Text(
              languageController.getTranslation('projects'),
              style: context.displayLarge!.copyWith(
                color: AppColors.textColorWhite,
                fontWeight: FontWeight.bold,
                fontSize: 25,
              ),
            ),
          ),
          centerTitle: false,
          elevation: 0,
        ),
        body: Padding(
          padding: padding5,
          child: Column(
            children: [
              HeightBox(context.height * 0.01),
              Row(
                children: [
                  Expanded(
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
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(
                                0.3,
                              ), // light grey shadow
                              blurRadius: 6,
                              spreadRadius: 5,
                              // offset: Offset(0, 3), // vertical shadow
                            ),
                          ],
                        ),
                        child: TextField(
                          cursorColor: Colors.red,
                          focusNode: controller.searchFocusNode,
                          controller: controller.searchController.value,
                          onChanged: (val) {
                            controller.query.value = val;
                            controller.searchProjects();
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
                              () => controller.query.value.isNotEmpty
                                  ? IconButton(
                                      onPressed: () {
                                        context.focusScope.unfocus();
                                        controller.searchController.value
                                            .clear();
                                        controller.query.value = '';
                                        controller.searchProjects();
                                      },
                                      icon: Icon(Icons.close),
                                    )
                                  : SizedBox.shrink(),
                            ),
                            prefixIcon: Icon(Iconsax.search_normal, size: 15),
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
              Obx(() {
                final categories = controller.filteredCategories;
                return categories.isNotEmpty
                    ? Expanded(
                        child: SmartRefresher(
                          controller: _refreshController,
                          header: MaterialClassicHeader(
                            color: AppColors.primaryColor,
                          ),
                          enablePullDown: true,
                          onRefresh: _onRefresh,
                          child: ListView.builder(
                            itemCount: categories.length,
                            itemBuilder: (_, i) {
                              final cat = categories[i];
                              final isExpanded = controller.isExpanded(
                                cat.id.toString(),
                              );
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  dividerColor: Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Material(
                                    elevation: isExpanded ? 3 : 0,
                                    shadowColor: Colors.black54,
                                    borderRadius: BorderRadius.circular(12),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.secondaryColor,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: ExpansionTile(
                                        initiallyExpanded: isExpanded,
                                        onExpansionChanged: (expanded) =>
                                            controller.toggleExpansion(
                                              cat.id.toString(),
                                            ),
                                        tilePadding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                        ),
                                        collapsedIconColor: Colors.white,
                                        trailing: Obx(() {
                                          final expanded = controller
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
                                        children: [
                                          ...List.generate(cat.projects.length, (
                                            index,
                                          ) {
                                            final project = cat.projects[index];
                                            return GestureDetector(
                                              onTap: () {
                                                controller.selectProject(
                                                  project.id,
                                                  context,
                                                );
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
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
                                                                controller
                                                                    .isSelected(
                                                                      project
                                                                          .id,
                                                                    )
                                                                ? (controller
                                                                              .gettingsubjProjects
                                                                              .value &&
                                                                          controller.selectedProjectId!.value ==
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
                                                        Obx(
                                                          () =>
                                                              controller
                                                                  .isSelected(
                                                                    project.id,
                                                                  )
                                                              ? IconButton(
                                                                  onPressed: () {
                                                                    Get.to(
                                                                      () =>
                                                                          ProjectDetails(),
                                                                      arguments: controller
                                                                          .getAllSubprojects
                                                                          .value,
                                                                    );
                                                                  },
                                                                  icon: Icon(
                                                                    Icons
                                                                        .visibility,
                                                                    color: AppColors
                                                                        .primaryColor,
                                                                  ),
                                                                )
                                                              : SizedBox.shrink(),
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
                                        ],
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
                          () => controller.isloading.value
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
            ],
          ),
        ),
      ),
    );
  }
}
