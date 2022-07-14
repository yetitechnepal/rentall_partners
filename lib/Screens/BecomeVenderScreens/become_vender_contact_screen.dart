// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/Model/vender_model.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/Widgets/experience_list_widget.dart';
import 'package:rental_partners/Screens/DocumentsScreen/documents_screen.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

class BecomeVenderContactScreen extends StatelessWidget {
  late List<TextEditingController> controllers;
  final formKey = GlobalKey<FormState>();
  final experienceKey = GlobalKey<ExperienceListBoxState>();

  BecomeVenderContactScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    controllers = List.generate(3, (index) {
      String value = "";
      if (index == 0) {
        value = context.read<VenderModelCubit>().state.primaryEmail;
      } else if (index == 1) {
        value = context.read<VenderModelCubit>().state.primaryPhone;
      } else if (index == 2) {
        value = context.read<VenderModelCubit>().state.secondaryPhone;
      }
      return TextEditingController(text: value);
    });

    LoginType loginType = context.read<VenderModelCubit>().state.loginType;
    bool isVender = loginType == LoginType.vender;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("ADD CONTACT")),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    textFieldText("Primary Email"),
                    AEMPLTextField(
                      controller: controllers[0],
                      hintText: "Primary email",
                      prefix: const Icon(Icons.email),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (!value!.contains("@") || !value.contains(".")) {
                          return "Enter valid email";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    textFieldText("Primary Phone Number"),
                    AEMPLTextField(
                      controller: controllers[1],
                      hintText: "Primary phone number",
                      prefix: const Icon(CupertinoIcons.phone_solid),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    textFieldText("Secondary Phone Number"),
                    AEMPLTextField(
                      controller: controllers[2],
                      hintText: "Secondary phone number",
                      prefix: const Icon(Icons.phone_android_rounded),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter phone number";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 30),
                    Visibility(
                      visible: !isVender,
                      child: ExperienceListBox(key: experienceKey),
                    ),
                    const SizedBox(height: 50),
                    Center(
                      child: TextButton(
                        child: const Text("Submit"),
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            context
                                .read<VenderModelCubit>()
                                .state
                                .setContactinformation(
                                  primaryEmail: controllers[0].text,
                                  primaryPhone: controllers[1].text,
                                  secondaryPhone: controllers[2].text,
                                );
                            if (!isVender) {
                              List<Experience> experiences =
                                  experienceKey.currentState!.experiences;
                              if (experiences.isEmpty) {
                                showCupertinoDialog(
                                  context: context,
                                  builder: (ctx) => CupertinoAlertDialog(
                                    title: const Text(
                                        "No experiences added, continue?"),
                                    actions: [
                                      CupertinoDialogAction(
                                        child: const Text(
                                          "Continue",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                          registerNow(context);
                                        },
                                      ),
                                      CupertinoDialogAction(
                                        child: const Text(
                                          "No, I will add experiences",
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(ctx);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                context
                                    .read<VenderModelCubit>()
                                    .state
                                    .setExperiences(experiences);
                                registerNow(context);
                              }
                            } else {
                              registerNow(context);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void registerNow(BuildContext context) {
    context.read<VenderModelCubit>().state.requestOTP();
    TextEditingController otpController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showCupertinoDialog(
        context: context,
        builder: (ctx) {
          return CupertinoAlertDialog(
            title: const Text(
              "We send OTP to your email account\nEnter OTP and set password",
            ),
            content: Column(
              children: [
                const SizedBox(height: 15),
                CupertinoTextField(
                  controller: otpController,
                  placeholder: "Enter OTP",
                  maxLength: 4,
                ),
                const SizedBox(height: 10),
                CupertinoTextField(
                  controller: passwordController,
                  placeholder: "Enter Password",
                  obscureText: true,
                ),
                const SizedBox(height: 5),
              ],
            ),
            actions: [
              CupertinoDialogAction(
                child: const Text(
                  "Done",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
                onPressed: () async {
                  if (otpController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter otp");
                    return;
                  } else if (passwordController.text.isEmpty) {
                    Fluttertoast.showToast(msg: "Please enter password");
                    return;
                  }

                  Navigator.pop(ctx);
                  await context.read<VenderModelCubit>().state.setPassword(
                        password: passwordController.text,
                        otp: otpController.text,
                      );
                  if (await context
                      .read<VenderModelCubit>()
                      .state
                      .register(context)) {
                    scaffoldMessageKey.currentState!.showSnackBar(
                      const SnackBar(
                          content: Text("Please upload your legal documents")),
                    );
                    context.read<VenderModelCubit>().resetData();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const MainScreen()),
                      (route) => true,
                    );
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const DocumentsScreen(),
                      ),
                    );
                  }
                },
              ),
              CupertinoDialogAction(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () {
                  Navigator.pop(ctx);
                },
              ),
            ],
          );
        });
  }
}
