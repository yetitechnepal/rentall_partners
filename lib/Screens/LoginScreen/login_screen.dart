// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/operator_dashboard_screen.dart';
import 'package:rental_partners/Screens/ForgetPasswordScreen/forget_password_screen.dart';
import 'package:rental_partners/Screens/LoginScreen/Model/login_model.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';

enum LoginType { vender, operator }

class LoginScreen extends StatelessWidget {
  final controllers = List.generate(2, (index) => TextEditingController());

  LoginScreen({Key? key}) : super(key: key);
  final formKey = GlobalKey<FormState>();
  LoginType type = LoginType.vender;

  bool isObsecure = true;

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: const Color(0xffED1A25),
          body: SingleChildScrollView(
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Form(
                    key: formKey,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Image.asset("assets/images/logo.png", height: 160),
                        StatefulBuilder(
                          builder: (context, setState) => AEMPLPopUpButton(
                            hintText: "Select login type",
                            prefix: const Icon(Icons.login),
                            value: type == LoginType.operator
                                ? "Login as Operator"
                                : "Login as Vender",
                            onPressed: () {
                              showCupertinoDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (ctx) => CupertinoAlertDialog(
                                  title: const Text("Select login as"),
                                  actions: [
                                    CupertinoDialogAction(
                                      child: const Text("Login as Vender"),
                                      onPressed: () {
                                        setState(() => type = LoginType.vender);
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: const Text("Login as Operator"),
                                      onPressed: () {
                                        setState(
                                            () => type = LoginType.operator);
                                        Navigator.pop(ctx);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        AEMPLTextField(
                          hintText: "Email",
                          controller: controllers[0],
                          keyboardType: TextInputType.emailAddress,
                          prefix: const Icon(Icons.email, size: 20),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return "Please enter email";
                            } else if (!value.contains("@") ||
                                !value.contains(".")) {
                              return "Please enter valid email";
                            }
                          },
                        ),
                        const SizedBox(height: 20),
                        StatefulBuilder(builder: (context, setState) {
                          return AEMPLTextField(
                            hintText: "Password",
                            controller: controllers[1],
                            obscureText: isObsecure,
                            maxLines: 1,
                            textInputAction: TextInputAction.done,
                            prefix: const Icon(Icons.lock, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter password";
                              }
                            },
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
                                    isObsecure
                                        ? CupertinoIcons.eye_fill
                                        : CupertinoIcons.eye_slash_fill,
                                  ),
                                ),
                                onTap: () {
                                  setState(() => isObsecure = !isObsecure);
                                },
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerRight,
                          child: InkWell(
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (ctx) => ForgetPasswordScreen(),
                              ),
                            ),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 20.0,
                                vertical: 10,
                              ),
                              child: Text(
                                "Forgot Password?",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                        Center(
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.white.withOpacity(01),
                              primary: Colors.white38,
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                LoginModel loginModel = LoginModel(
                                  controllers[0].text.trim(),
                                  controllers[1].text,
                                );
                                if (await loginModel.doLogin(
                                  context,
                                  loginType: type,
                                )) {
                                  if (type == LoginType.vender) {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) => const MainScreen()),
                                      (route) => false,
                                    );
                                  } else {
                                    Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              const OperatorDashboardScreen()),
                                      (route) => false,
                                    );
                                  }
                                }
                              }
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ),
                        const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
