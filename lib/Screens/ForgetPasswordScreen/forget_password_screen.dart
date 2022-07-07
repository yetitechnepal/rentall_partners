// ignore_for_file: body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

class PasswordChange {
  String email = "", password = "", confirmPassword = "", otp = "";
  Future<bool> sendOTP(BuildContext context) async {
    context.loaderOverlay.show();
    Response response = await API().post(
      endPoint: "accounts/otp/",
      data: {"email": email},
      useToken: false,
    );
    context.loaderOverlay.hide();
    Fluttertoast.showToast(
      msg: response.data['message'],
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> changePassword(BuildContext context) async {
    context.loaderOverlay.show();
    Response response = await API().post(
      endPoint: "accounts/password-reset/",
      data: {
        "email": email,
        "new_password1": password,
        "new_password2": confirmPassword,
        "otp": otp,
      },
      useToken: false,
    );
    context.loaderOverlay.hide();
    scaffoldMessageKey.currentState!.showSnackBar(
      SnackBar(
        content: Text(response.data['message']),
      ),
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  List<TextEditingController> controllers =
      List.generate(4, (index) => TextEditingController());

  bool isEmailSent = false, hidePassword = true, hideConfirmPassword = true;
  final PasswordChange _passwordChange = PasswordChange();

  final emailFormKey = GlobalKey<FormState>(),
      otpFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("FORGET PASSWORD"),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 13),
                  textFieldText("Enter Email"),
                  const SizedBox(height: 6),
                  Form(
                    key: emailFormKey,
                    child: AEMPLTextField(
                      controller: controllers[0],
                      hintText: "Enter email",
                      disabled: isEmailSent,
                      keyboardType: TextInputType.emailAddress,
                      prefix: const Icon(Icons.email),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter email";
                        } else if (!value.contains("@") ||
                            !value.contains(".")) {
                          return "Enter valid email";
                        }
                      },
                    ),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.ease,
                    child: Visibility(
                      visible: isEmailSent,
                      child: Form(
                        key: otpFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 13),
                            textFieldText("Enter OTP we sent to your email"),
                            const SizedBox(height: 6),
                            AEMPLTextField(
                              controller: controllers[1],
                              hintText: "Enter OTP",
                              maxLength: 4,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                signed: false,
                                decimal: false,
                              ),
                              prefix: const Icon(Icons.numbers),
                              validator: (value) {
                                if (value!.length < 4) {
                                  return "Enter 4 digit OTP";
                                }
                              },
                            ),
                            const SizedBox(height: 13),
                            textFieldText("Enter New Password"),
                            const SizedBox(height: 6),
                            AEMPLTextField(
                              controller: controllers[2],
                              hintText: "Enter new password",
                              prefix: const Icon(Icons.lock),
                              obscureText: hidePassword,
                              maxLines: 1,
                              suffix: ClipRRect(
                                child: InkWell(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                  ),
                                  splashColor: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 13.5),
                                    child: Icon(
                                      hidePassword
                                          ? CupertinoIcons.eye_fill
                                          : CupertinoIcons.eye_slash_fill,
                                    ),
                                  ),
                                  onTap: () => setState(
                                    () => hidePassword = !hidePassword,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter new password";
                                }
                              },
                            ),
                            const SizedBox(height: 13),
                            textFieldText("Enter Confirm Password"),
                            const SizedBox(height: 6),
                            AEMPLTextField(
                              controller: controllers[3],
                              maxLines: 1,
                              hintText: "Enter confirm password",
                              prefix: const Icon(Icons.lock),
                              obscureText: hideConfirmPassword,
                              suffix: ClipRRect(
                                child: InkWell(
                                  borderRadius: const BorderRadius.horizontal(
                                    right: Radius.circular(10),
                                  ),
                                  splashColor: Theme.of(context).primaryColor,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0, vertical: 13.5),
                                    child: Icon(
                                      hideConfirmPassword
                                          ? CupertinoIcons.eye_fill
                                          : CupertinoIcons.eye_slash_fill,
                                    ),
                                  ),
                                  onTap: () => setState(
                                    () => hideConfirmPassword =
                                        !hideConfirmPassword,
                                  ),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Enter confirm password";
                                } else if (value != controllers[2].text) {
                                  return "Confirm password doesnot match";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      child: Text(isEmailSent ? "Change Password" : "Sent OTP"),
                      onPressed: () async {
                        if (isEmailSent) {
                          if (otpFormKey.currentState!.validate()) {
                            _passwordChange.otp = controllers[1].text.trim();
                            _passwordChange.password = controllers[2].text;
                            _passwordChange.confirmPassword =
                                controllers[3].text;
                            if (await _passwordChange.changePassword(context)) {
                              Navigator.pop(context);
                            }
                          }
                        } else {
                          if (emailFormKey.currentState!.validate()) {
                            _passwordChange.email = controllers[0].text.trim();
                            if (await _passwordChange.sendOTP(context)) {
                              setState(() => isEmailSent = true);
                            }
                          }
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
