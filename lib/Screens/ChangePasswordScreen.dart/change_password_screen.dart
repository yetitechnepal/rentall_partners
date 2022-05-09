// ignore_for_file: body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

changePassword(
  BuildContext context, {
  required String currentPassword,
  required String newPassword,
  required String confirmPassword,
}) async {
  context.loaderOverlay.show();
  Response response =
      await API().post(endPoint: "accounts/password-change/", data: {
    "old_password": currentPassword,
    "new_password": newPassword,
    "new_password1": confirmPassword,
  });
  context.loaderOverlay.hide();
  scaffoldMessageKey.currentState!
      .showSnackBar(SnackBar(content: Text(response.data['message'])));
  if (response.statusCode == 200) {
    LoginSession().logout();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen()),
      (route) => false,
    );
  }
}

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({Key? key}) : super(key: key);
  final List<TextEditingController> controllers =
      List.generate(3, (index) => TextEditingController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("CHANGE PASSWORD"),
        ),
        body: Form(
          key: formKey,
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ListView(
                children: [
                  textFieldText("Old Password"),
                  AEMPLTextField(
                    controller: controllers[0],
                    hintText: "Enter old password",
                    obscureText: true,
                    maxLines: 1,
                    prefix: const AEMPLIcon(AEMPLIcons.password),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter old password";
                      }
                    },
                  ),
                  textFieldText("New Password"),
                  AEMPLTextField(
                    controller: controllers[1],
                    hintText: "Enter new password",
                    obscureText: true,
                    maxLines: 1,
                    prefix: const AEMPLIcon(AEMPLIcons.password),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter new password";
                      }
                    },
                  ),
                  textFieldText("Confirm Password"),
                  AEMPLTextField(
                    controller: controllers[2],
                    hintText: "Enter confirm password",
                    obscureText: true,
                    maxLines: 1,
                    prefix: const AEMPLIcon(AEMPLIcons.password),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter confirm password";
                      } else if (value != controllers[1].text) {
                        return "Confirm password doesnot match";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          changePassword(
                            context,
                            currentPassword: controllers[0].text,
                            newPassword: controllers[1].text,
                            confirmPassword: controllers[2].text,
                          );
                        }
                      },
                      child: const Text("Change"),
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
