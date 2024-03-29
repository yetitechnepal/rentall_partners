// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AddAtttachmentScreen/Model/add_attachment_model.dart';
import 'package:rental_partners/Screens/MainScreen/main_screen.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Widgets/images_upload.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/text_field.dart';

class AddAttachmentScreen extends StatefulWidget {
  const AddAttachmentScreen({Key? key}) : super(key: key);

  @override
  State<AddAttachmentScreen> createState() => _AddAttachmentScreenState();
}

class _AddAttachmentScreenState extends State<AddAttachmentScreen> {
  final controllers = List.generate(11, (index) => TextEditingController());

  final formKey = GlobalKey<FormState>();

  TextEditingController yearManufactureController = TextEditingController();
  bool isVATIncluded = false;

  final imageuploadKey = GlobalKey<ImagesUploadSectionState>();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("ADD ATTACHMENT")),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
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
                      textFieldText("Attachment Name"),
                      AEMPLTextField(
                        controller: controllers[0],
                        hintText: "Attachment name",
                        prefix:
                            const AEMPLIcon(AEMPLIcons.attachment, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter attachment name";
                          }
                        },
                      ),
                      textFieldText("Attachment Description"),
                      AEMPLTextField(
                        controller: controllers[1],
                        hintText: "Attachment description",
                        keyboardType: TextInputType.multiline,
                        maxLines: 6,
                        prefix:
                            const AEMPLIcon(AEMPLIcons.description, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter attachment detail";
                          }
                        },
                      ),
                      textFieldText("Attachment Dimension and Weight"),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: AEMPLTextField(
                              margin: 0,
                              controller: controllers[2],
                              hintText: "Dimension",
                              prefix: const AEMPLIcon(AEMPLIcons.dimension,
                                  size: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter dimension";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AEMPLTextField(
                              margin: 0,
                              controller: controllers[3],
                              hintText: "Weight",
                              prefix:
                                  const AEMPLIcon(AEMPLIcons.weight, size: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter weight";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      textFieldText("Attachment count"),
                      AEMPLTextField(
                        controller: controllers[4],
                        hintText: "Attachment count",
                        paddingRight: 4,
                        keyboardType: TextInputType.number,
                        prefix: const AEMPLIcon(AEMPLIcons.numbers, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter attachment count";
                          }
                        },
                      ),
                      textFieldText("Hours of renting"),
                      AEMPLTextField(
                        controller: controllers[5],
                        hintText: "Hours of renting",
                        paddingRight: 4,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.lock_clock_outlined, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter hour of renting";
                          }
                        },
                      ),
                      textFieldText("Year of Manufacturing"),
                      AEMPLTextField(
                        controller: controllers[8],
                        hintText: "Year of manufacturing",
                        paddingRight: 4,
                        keyboardType: TextInputType.number,
                        prefix: const Icon(Icons.calendar_today, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter year of manufacturing";
                          }
                        },
                      ),
                      textFieldText("Location"),
                      AEMPLTextField(
                        controller: controllers[7],
                        hintText: "Location",
                        paddingRight: 4,
                        keyboardType: TextInputType.text,
                        prefix: const AEMPLIcon(AEMPLIcons.location, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter attachment location";
                          }
                        },
                      ),
                      textFieldText("Base rate per hour"),
                      AEMPLTextField(
                        controller: controllers[10],
                        hintText: "Base rate per hour",
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            AEMPLIcon(AEMPLIcons.price, size: 20),
                            SizedBox(width: 5),
                            Text("Rs "),
                          ],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) return "Please enter base rate";
                        },
                      ),
                      textFieldText("Fuel included rate per hour"),
                      AEMPLTextField(
                        controller: controllers[9],
                        hintText: "Fuel included rate per hour",
                        prefix: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            AEMPLIcon(AEMPLIcons.price, size: 20),
                            SizedBox(width: 5),
                            Text("Rs "),
                          ],
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please enter fuel included rate";
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      CheckboxListTile(
                        value: isVATIncluded,
                        title: const Text("VAT included rates"),
                        onChanged: (value) =>
                            setState(() => isVATIncluded = value!),
                      ),
                      const SizedBox(height: 10),
                      textFieldText("Add Images"),
                      ImagesUploadSection(key: imageuploadKey),
                      const SizedBox(height: 60),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              double baseRate =
                                  double.parse(controllers[10].text);
                              double fuelIncludedRate =
                                  double.parse(controllers[9].text);

                              if (isVATIncluded) {
                                baseRate = baseRate / 1.13;
                                fuelIncludedRate = fuelIncludedRate / 1.13;
                              }

                              AddAttachmentModel addAttachmentModel =
                                  AddAttachmentModel(
                                name: controllers[0].text,
                                description: controllers[1].text,
                                dimension: controllers[2].text,
                                weight: controllers[3].text,
                                count: controllers[4].text,
                                hourOfRenting: controllers[5].text,
                                manufacturedYear: controllers[8].text,
                                location: controllers[7].text,
                                baseRate: baseRate.toStringAsFixed(2),
                                feulIncludedRate:
                                    fuelIncludedRate.toStringAsFixed(2),
                              );
                              int id = await addAttachmentModel
                                  .addAttachment(context);
                              if (id != 0) {
                                List<String> images = await imageuploadKey
                                    .currentState!
                                    .getImagepathList();
                                AddAttachmentImagesModel imagesModel =
                                    AddAttachmentImagesModel(images);
                                if (await imagesModel.addAttachmentImages(id)) {
                                  Fluttertoast.showToast(
                                      msg: "Attachment added");
                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) =>
                                            const MainScreen(initialIndex: 2)),
                                    (route) => true,
                                  );
                                } else {
                                  Fluttertoast.showToast(
                                      msg: "Attachment adding failed");
                                }
                              } else {
                                Fluttertoast.showToast(
                                    msg: "Attachment adding failed");
                              }
                            }
                          },
                          child: const Text("Submit"),
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
    );
  }
}
