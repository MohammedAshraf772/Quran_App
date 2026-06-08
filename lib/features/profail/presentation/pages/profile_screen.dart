import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:quran_app/core/language/language_cubit.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/theme/theme_cubit.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String appVersion = "1.0.0";

  @override
  void initState() {
    super.initState();
    loadVersion();
  }

  Future<void> loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    setState(() {
      appVersion = info.version;
    });
  }

  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void changeLanguage() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("select_language".tr()),

            content: Column(
              mainAxisSize: MainAxisSize.min,

              children: [
                ListTile(
                  title: const Text("العربية"),

                  onTap: () async {
                    context.read<LanguageCubit>().changeLanguage('ar');
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),

                ListTile(
                  title: const Text("English"),

                  onTap: () async {
                    context.read<LanguageCubit>().changeLanguage('en');

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),

                ListTile(
                  title: const Text("Français"),

                  onTap: () async {
                    context.read<LanguageCubit>().changeLanguage('fr');

                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),

                ListTile(
                  title: const Text("Deutsch"),

                  onTap: () async {
                    context.read<LanguageCubit>().changeLanguage('de');
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                ),
              ],
            ),
          ),
    );
  }

  void showAboutDialogApp() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("about_app".tr()),

            content: Text("Version $appVersion"),
          ),
    );
  }

  void showPrivacyPolicy() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: Text("privacy_policy".tr()),

            content: const Text("Put your privacy policy here."),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Profile",
          style: TextStyle(color: Theme.of(context).textTheme.bodyLarge?.color),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            const SizedBox(height: 20),
            BlocBuilder<ThemeCubit, bool>(
              builder: (context, state) {
                return _tile(
                  icon: state ? Icons.dark_mode : Icons.light_mode,

                  title: "dark_mode".tr(),

                  trailing: Switch(
                    value: state,

                    onChanged: (_) {
                      context.read<ThemeCubit>().toggleTheme();
                    },
                  ),
                );
              },
            ),

            _tile(
              icon: Icons.language,

              title: "language".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: changeLanguage,
            ),

            _tile(
              icon: Icons.star_rate,

              title: "rate_app".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                openUrl(
                  // هنا هينضاف  رابط التطبيق على جوجل بلاي هنا
                  "",
                );
              },
            ),

            _tile(
              icon: Icons.share,

              title: "share_app".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                Share.share(
                  // ضع رابط التطبيق هنا
                  "",
                );
              },
            ),

            _tile(
              icon: Icons.contact_mail,

              title: "contact_us".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: () {
                showModalBottomSheet(
                  context: context,

                  builder:
                      (_) => SafeArea(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,

                          children: [
                            ListTile(
                              leading: const Icon(Icons.email),

                              title: const Text("Email"),

                              onTap: () {
                                openUrl(
                                  // ضع ايميلك هنا
                                  "ُemail:your@email.com",
                                );
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.telegram),

                              title: const Text("Telegram"),

                              onTap: () {
                                openUrl(
                                  // ضع لينك التليجرام هنا
                                  "",
                                );
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.facebook),

                              title: const Text("Facebook"),

                              onTap: () {
                                openUrl(
                                  // ضع لينك الفيسبوك هنا
                                  "",
                                );
                              },
                            ),

                            ListTile(
                              leading: const Icon(Icons.camera_alt),

                              title: const Text("Instagram"),

                              onTap: () {
                                openUrl(
                                  // ضع لينك الانستجرام هنا
                                  "",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                );
              },
            ),

            _tile(
              icon: Icons.privacy_tip,

              title: "privacy_policy".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: showPrivacyPolicy,
            ),

            _tile(
              icon: Icons.info_outline,

              title: "about_app".tr(),

              trailing: const Icon(Icons.arrow_forward_ios),

              onTap: showAboutDialogApp,
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
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
      ),

      child: ListTile(
        onTap: onTap,

        leading: Icon(icon, color: Theme.of(context).iconTheme.color),

        title: Text(
          title,
          style: TextStyle(
            color: Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w500,
          ),
        ),

        trailing: trailing,
      ),
    );
  }
}
