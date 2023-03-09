// ignore_for_file: must_be_immutable, body_might_complete_normally_nullable

import 'package:country_picker/country_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/Model/vender_model.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/become_vender_contact_screen.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Utils/profile_upload_box.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

class BecomeVenderScreen extends StatefulWidget {
  const BecomeVenderScreen({Key? key}) : super(key: key);

  @override
  State<BecomeVenderScreen> createState() => _BecomeVenderScreenState();
}

class _BecomeVenderScreenState extends State<BecomeVenderScreen> {
  late List<TextEditingController> controllers;

  final formKey = GlobalKey<FormState>();

  final imageKey = GlobalKey<ProfileUploadBoxState>();

  @override
  Widget build(BuildContext context) {
    controllers = List.generate(8, (index) {
      String value = "";
      if (index == 0) {
        value = context.read<VenderModelCubit>().state.companyName;
      }
      // else if (index == 1) {
      //   value = context.read<VenderModelCubit>().state.pan;
      // }
      else if (index == 2) {
        value = context.read<VenderModelCubit>().state.information;
      } else if (index == 3) {
        value = context.read<VenderModelCubit>().state.state;
      } else if (index == 4) {
        value = context.read<VenderModelCubit>().state.district;
      } else if (index == 5) {
        value = context.read<VenderModelCubit>().state.ward;
      } else if (index == 6) {
        value = context.read<VenderModelCubit>().state.tole;
      } else if (index == 7) {
        value = context.read<VenderModelCubit>().state.country;
      }
      return TextEditingController(text: value);
    });
    LoginType loginType = context.read<VenderModelCubit>().state.loginType;
    bool isVender = loginType == LoginType.vender;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          isVender ? "BECOME VENDER" : "SIGNUP OPERATOR",
        ),
      ),
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
                  ProfileUploadBox(
                    key: imageKey,
                    image: context.read<VenderModelCubit>().state.imagePath,
                  ),
                  const SizedBox(height: 10),
                  textFieldText(
                    "General",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  textFieldText(
                      isVender ? "Company Name *" : "Operator Name *"),
                  AEMPLTextField(
                    controller: controllers[0],
                    hintText: isVender ? "Company name" : "Operator name",
                    prefix: const Icon(Icons.business),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return isVender
                            ? "Enter Company Name"
                            : "Enter Operator Name";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  // textFieldText("Personal Account Number"),
                  // AEMPLTextField(
                  //   controller: controllers[1],
                  //   hintText: "PAN",
                  //   prefix: const Icon(Icons.card_giftcard),
                  //   validator: (value) {
                  //     if (isVender) {
                  //       if (value!.isEmpty) {
                  //         return "Enter PAN";
                  //       }
                  //     }

                  //     return null;
                  //   },
                  // ),
                  const SizedBox(height: 10),
                  textFieldText(
                      isVender ? "About Company *" : "About Operator *"),
                  AEMPLTextField(
                    controller: controllers[2],
                    hintText: isVender
                        ? "Company information"
                        : "Operator Information",
                    maxLines: 10,
                    prefix: const Icon(Icons.info),
                    validator: (value) {
                      if (value!.length < 20) {
                        return isVender
                            ? "Enter Company Information with atleast 20 letters longer"
                            : "Enter Operator Information with atleast 20 letters longer";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  textFieldText(
                    "Address",
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                    color: Theme.of(context).primaryColor,
                  ),
                  textFieldText("State *"),
                  AEMPLTextField(
                    controller: controllers[3],
                    hintText: "State",
                    prefix: const Icon(Icons.map),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter State";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  textFieldText("District *"),
                  AEMPLTextField(
                    controller: controllers[4],
                    hintText: "District",
                    prefix: const Icon(Icons.location_city),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter District";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  textFieldText("Ward No. *"),
                  AEMPLTextField(
                    controller: controllers[5],
                    hintText: "Ward No.",
                    prefix: const Icon(Icons.location_on),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Ward";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  textFieldText("Tole *"),
                  AEMPLTextField(
                    controller: controllers[6],
                    hintText: "Tole",
                    prefix: const Icon(Icons.local_library_sharp),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Tole";
                      }
                    },
                  ),
                  const SizedBox(height: 10),
                  textFieldText("Country *"),
                  AEMPLTextField(
                    controller: controllers[7],
                    hintText: "Country",
                    prefix: const Icon(CupertinoIcons.globe),
                    readOnly: true,
                    onTap: () {
                      showCountryPicker(
                        context: context,
                        countryListTheme: CountryListThemeData(
                          flagSize: 25,
                          backgroundColor: Colors.white,
                          textStyle: const TextStyle(
                              fontSize: 16, color: Colors.blueGrey),
                          bottomSheetHeight: 600,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color:
                                      const Color(0xFF8C98A8).withOpacity(0.2),
                                ),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(20))),
                          ),
                        ),
                        onSelect: (Country country) {
                          controllers[7].text = country.name;
                        },
                      );
                    },
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Enter Country";
                      }
                    },
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          String? image = imageKey.currentState!.image;
                          if (image == null) {
                            scaffoldMessageKey.currentState!.showSnackBar(
                              const SnackBar(
                                content: Text("Please select profile image"),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }
                          context
                              .read<VenderModelCubit>()
                              .state
                              .setGeneratInformation(
                                companyName: controllers[0].text,
                                imagePath: image,
                                pan: controllers[1].text,
                                information: controllers[2].text,
                              );
                          context
                              .read<VenderModelCubit>()
                              .state
                              .setAddressInformation(
                                state: controllers[3].text,
                                country: controllers[7].text,
                                district: controllers[4].text,
                                tole: controllers[6].text,
                                ward: controllers[5].text,
                              );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BecomeVenderContactScreen(),
                            ),
                          );
                        }
                      },
                      child: const Text("Next"),
                    ),
                  ),
                  const SizedBox(height: 50),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
