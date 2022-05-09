// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';

showAdressEditPopup(BuildContext context, {required ProfileAddress address}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a, aa) {
        return AddressEditPopup(
          address: address,
        );
      });
}

class AddressEditPopup extends StatelessWidget {
  final ProfileAddress address;

  // ignore: prefer_typing_uninitialized_variables
  late final controllers;
  final formKey = GlobalKey<FormState>();
  AddressEditPopup({Key? key, required this.address}) : super(key: key) {
    controllers = List.generate(5, (index) {
      if (index == 0) {
        return TextEditingController(text: address.state);
      } else if (index == 1) {
        return TextEditingController(text: address.district);
      } else if (index == 2) {
        return TextEditingController(text: address.ward);
      } else if (index == 3) {
        return TextEditingController(text: address.tole);
      } else {
        return TextEditingController(text: address.country);
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("UPDATE ADDRESS")),
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
                  children: [
                    textFieldText("State"),
                    AEMPLTextField(
                      controller: controllers[0],
                      hintText: "State name",
                      prefix: const AEMPLIcon(AEMPLIcons.state),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter state";
                      },
                    ),
                    textFieldText("District"),
                    AEMPLTextField(
                      controller: controllers[1],
                      hintText: "District name",
                      prefix: const AEMPLIcon(AEMPLIcons.location),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter district";
                      },
                    ),
                    textFieldText("Ward no"),
                    AEMPLTextField(
                      controller: controllers[2],
                      hintText: "Ward no",
                      prefix: const AEMPLIcon(AEMPLIcons.state),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter ward number";
                      },
                    ),
                    textFieldText("Tole"),
                    AEMPLTextField(
                      controller: controllers[3],
                      hintText: "Tole name",
                      prefix: const AEMPLIcon(AEMPLIcons.location),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter tole";
                      },
                    ),
                    textFieldText("Country"),
                    AEMPLTextField(
                      controller: controllers[4],
                      prefix: const AEMPLIcon(AEMPLIcons.country),
                      hintText: "Country name",
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter country";
                      },
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            ProfileAddress profileAddress =
                                ProfileAddress.update(
                              id: address.id,
                              state: controllers[0].text,
                              district: controllers[1].text,
                              ward: controllers[2].text,
                              tole: controllers[3].text,
                              country: controllers[4].text,
                              address: "",
                            );
                            if (await profileAddress.update(
                                context, address.id)) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: const Text("Update"),
                      ),
                    ),
                    const SizedBox(height: 20),
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
