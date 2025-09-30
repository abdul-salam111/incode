import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/controllers/login_controller.dart';
import 'package:in_code/controllers/navbar_controller.dart';

import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/models/login_model.dart';

import 'package:in_code/pages/auth_screen.dart';
import 'package:in_code/pages/set_password_screen.dart';
import 'package:in_code/res/res.dart';
import 'package:intl/intl.dart';
import '../config/config.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final languageController = Get.find<LanguageController>();
  var onlyDate;

  @override
  Widget build(BuildContext context) {
    String lastLogin = '${box.read(userinformation)}' ?? 'N/A';
    if (lastLogin == 'N/A') {
      setState(() {
        onlyDate = "";
      });
    } else {
      DateTime dateTime = DateTime.parse(lastLogin);
      String formatted = DateFormat('dd/MM/yyyy HH:mm:ss').format(dateTime);
      setState(() {
        onlyDate = formatted.toString();
      });
      print("this is right format${formatted}");
      // Output: 15-06-2025 20:57 
    }

    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.secondaryColor,
        title: Obx(
          () => Text(
            languageController.getTranslation('profile'),
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
      body: SafeArea(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: isLandscape
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection(),
                    //  SizedBox(width: 16),
                    Expanded(child: _buildActionButtons(context)),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoSection(),
                    SizedBox(height: isLandscape ? 16 : 18),
                    _buildActionButtons(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildInfoSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWideScreen = constraints.maxWidth > 600;
        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color:Colors.grey.withOpacity(0.1), // light pink/red background
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 4), // changes position of shadow
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Informazioni',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildInfoItem(
                Iconsax.user,
                '${box.read(userFirstName)}',
                null,
                'Nome: ',
              ),
              if (!isWideScreen) const Divider(),
              _buildInfoItem(
                Iconsax.user,
                '${box.read(userLastName)}',
                null,
                'Cognome: ',
              ),
              if (!isWideScreen) const Divider(),
              _buildInfoItem(
                Iconsax.sms,
                '${box.read(userEmail)}',
                null,
                'Email: ',
              ),
              if (!isWideScreen) const Divider(),
              _buildInfoItem(
                Iconsax.calendar,
                onlyDate ?? "N/A",
                null,
                'Ultimo Accesso: ',
              ),
              if (!isWideScreen) const Divider(),
              _buildInfoItem(Iconsax.info_circle, "2.0", null, 'Versione: '),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SetPasswordScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Modifica Password',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              box.remove(userId);
              box.remove("expandedStates");
              box.remove("selectedProjectId");
              box.remove("selectedProject");
              final navbarController = Get.find<NavbarController>();
              navbarController.logoutAndResetControllers();
              Get.offAll(() => AuthScreen());
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
            ),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoItem(
    IconData icon,
    String text,
    Function()? onTap,
    String? title,
  ) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Icon(icon, size: 24, color: AppColors.secondaryColor),
            const SizedBox(width: 6),
            Text(
              title!,
              style: TextStyle(
                fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 14,
                color: AppColors.textColorPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              text,
              style: TextStyle(
              fontSize: MediaQuery.of(context).size.width > 600 ? 16 : 13,
              color: Colors.grey[800],
              ),
            ),
            if (onTap != null)
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
          ],
        ),
      ),
    );
  }
}
