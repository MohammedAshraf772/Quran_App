import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.background,
        centerTitle: true,

        title: const Text("Profile"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),

            CircleAvatar(
              radius: 55,

              backgroundColor: AppColors.primary,

              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 15),

            const Text(
              "Quran App",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 35),

            BlocBuilder<ThemeCubit, bool>(
              builder: (context, isDark) {
                return _tile(
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,

                  title: "Dark Mode",

                  trailing: Switch(
                    value: isDark,

                    onChanged: (value) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                );
              },
            ),

            _tile(
              icon: Icons.language,
              title: "Language",
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: const Text("Select Language"),

                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            title: const Text("English"),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),

                          ListTile(
                            title: const Text("العربية"),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),

            _tile(
              icon: Icons.email_outlined,
              title: "Contact Us",

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return const AlertDialog(
                      title: Text("Contact Us"),

                      content: Text("Email:\nexample@gmail.com"),
                    );
                  },
                );
              },
            ),

            _tile(
              icon: Icons.info_outline,
              title: "About App",

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                showDialog(
                  context: context,
                  builder: (_) {
                    return const AlertDialog(
                      title: Text("About"),

                      content: Text("Quran App Version 1.0.0"),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _tile({
    required IconData icon,
    required String title,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),

      decoration: BoxDecoration(
        color: AppColors.cardColor,

        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: Colors.white),

        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: trailing,
      ),
    );
  }
}
