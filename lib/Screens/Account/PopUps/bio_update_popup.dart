// ignore_for_file: implementation_imports, body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

Future<bool> _updateBio(BuildContext context,
    {required String vender, required String bio}) async {
  context.loaderOverlay.show();
  Response response = await API().put(
    endPoint: "accounts/user-update/",
    data: {"name": vender, "description": bio},
  );
  context.loaderOverlay.hide();

  final snackBar = SnackBar(content: Text(response.data['message']));
  scaffoldMessageKey.currentState!.showSnackBar(snackBar);
  if (response.statusCode == 200) {
    context.read<ProfileCubit>().fetchProfile();
    return true;
  } else {
    return false;
  }
}

showBioUpdatePopup(BuildContext context,
    {required String vender, required String bio}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a, aa) {
        return BioUpdatePopup(vender: vender, bio: bio);
      });
}

class BioUpdatePopup extends StatelessWidget {
  late final TextEditingController venderConttroller;
  late final TextEditingController bioConttroller;
  BioUpdatePopup({Key? key, required String vender, required String bio})
      : super(key: key) {
    venderConttroller = TextEditingController(text: vender);
    bioConttroller = TextEditingController(text: bio);
  }
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("UPDATE BIO"),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    textFieldText(
                        LoginSession().isVender() ? "Vender" : "Operator"),
                    AEMPLTextField(
                      controller: venderConttroller,
                      prefix: const Icon(Icons.badge_outlined),
                      hintText: LoginSession().isVender()
                          ? "Vender name"
                          : "Operator name",
                      validator: (value) {
                        if (value!.isEmpty) return "Enter vender name";
                      },
                    ),
                    textFieldText("Bio"),
                    AEMPLTextField(
                      controller: bioConttroller,
                      maxLines: 6,
                      prefix: const Icon(Icons.info_outline),
                      hintText: "Description",
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (await _updateBio(context,
                                vender: venderConttroller.text,
                                bio: bioConttroller.text)) {
                              Navigator.pop(context);
                            } else {}
                          }
                        },
                        child: const Text("Update"),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
