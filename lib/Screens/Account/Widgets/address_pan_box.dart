import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/OperatorScreen/OperatorExperienceScreen/operator_experince_screen.dart';
import 'package:rental_partners/Screens/Account/PopUps/address_edit_popup.dart';
import 'package:rental_partners/Screens/ChangePasswordScreen.dart/change_password_screen.dart';
import 'package:rental_partners/Screens/DocumentsScreen/documents_screen.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class AddressPanBox extends StatelessWidget {
  final ProfileModel profile;

  const AddressPanBox({Key? key, required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "PAN Number",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _viewText(
          context,
          value: profile.pan,
          backgroundColor: Theme.of(context).disabledColor,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "Markup %",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _viewText(
          context,
          value: profile.commisionPercentage,
          backgroundColor: Theme.of(context).disabledColor,
        ),
        Visibility(
          visible: !LoginSession().isVender(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: const Text(
                  "Your Operating Rate",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: _viewText(
                        context,
                        value: profile.perHourRate.toString(),
                        backgroundColor: Theme.of(context).disabledColor,
                        isCenter: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _viewText(
                        context,
                        value: profile.perDayRate.toString(),
                        backgroundColor: Theme.of(context).disabledColor,
                        isCenter: true,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _viewText(
                        context,
                        value: profile.perMonthRate.toString(),
                        backgroundColor: Theme.of(context).disabledColor,
                        isCenter: true,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _viewTextButton(
          context,
          value: "View Documents",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DocumentsScreen()),
          ),
        ),
        Visibility(
          visible: !LoginSession().isVender(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              _viewTextButton(
                context,
                value: "Experience",
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const OperatorExperienceScreen()),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 15),
        _viewTextButton(
          context,
          value: "Change Password",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChangePasswordScreen()),
          ),
        ),
        const SizedBox(height: 15),
        _viewTextButton(context, value: "About", onPressed: () async {
          PackageInfo packageInfo = await PackageInfo.fromPlatform();

          String appName = packageInfo.appName;
          String version = packageInfo.version;
          String buildNumber = packageInfo.buildNumber;
          showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: const Text("About"),
              content: Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    appName,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "version: $version ($buildNumber)",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              actions: [
                CupertinoDialogAction(
                  child: const Text("Ok"),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
          );
        }),
        const SizedBox(height: 15),
        _themeButton(context),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Address Details",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  showAdressEditPopup(context, address: profile.address);
                },
                iconSize: 30,
                splashRadius: 20,
                icon: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        _viewText(
          context,
          value: profile.address.address.toString(),
        ),
      ],
    );
  }

  Widget _viewText(
    BuildContext context, {
    required String value,
    Color? backgroundColor,
    bool isCenter = false,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
      ),
      child: isCenter
          ? Center(
              child: Text(value, textAlign: TextAlign.center),
            )
          : Text(value),
    );
  }

  Widget _viewTextButton(
    BuildContext context, {
    required String value,
    Color backgroundColor = Colors.white,
    Function()? onPressed,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: backgroundColor,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(11),
        child: Material(
          color: Theme.of(context).primaryColor,
          child: InkWell(
            onTap: onPressed,
            splashColor: Colors.red,
            child: Padding(
              padding: const EdgeInsets.all(13),
              child: Row(
                children: [
                  Text(
                    value,
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  const RotatedBox(
                    quarterTurns: 2,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _themeButton(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 13, right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        children: [
          const Text("Change Theme"),
          const Spacer(),
          ValueListenableBuilder(
            valueListenable: AdaptiveTheme.of(context).modeChangeNotifier,
            builder: (_, mode, child) {
              return ToggleButtons(
                borderRadius: BorderRadius.circular(6),
                constraints: const BoxConstraints(minHeight: 40, minWidth: 40),
                children: [
                  const Tooltip(
                    message: "Light Theme",
                    child: Icon(
                      Icons.light_mode,
                    ),
                  ),
                  Tooltip(
                    message: "Dark Theme",
                    child: Transform(
                      child: const Icon(
                        Icons.mode_night_sharp,
                      ),
                      alignment: FractionalOffset.center,
                      transform: Matrix4.identity()
                        ..rotateZ(45 * 3.1415927 / 180),
                    ),
                  ),
                  const Tooltip(
                    message: "System Theme",
                    child: Icon(
                      CupertinoIcons.gear_alt_fill,
                    ),
                  ),
                ],
                isSelected: [
                  AdaptiveTheme.of(context).mode == AdaptiveThemeMode.light,
                  AdaptiveTheme.of(context).mode == AdaptiveThemeMode.dark,
                  AdaptiveTheme.of(context).mode == AdaptiveThemeMode.system,
                ],
                onPressed: (index) {
                  if (index == 0) {
                    AdaptiveTheme.of(context).setLight();
                  } else if (index == 1) {
                    AdaptiveTheme.of(context).setDark();
                  } else {
                    AdaptiveTheme.of(context).setSystem();
                  }
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
