// ignore_for_file: unnecessary_null_comparison, must_be_immutable, body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/atttachment_detail_model.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';

class _AttachmentDetail {
  final String name, weight, dimension, hor, dom, location, description;
  final bool isVerified;

  _AttachmentDetail({
    required this.name,
    required this.weight,
    required this.dimension,
    required this.hor,
    required this.dom,
    required this.location,
    required this.description,
    required this.isVerified,
  });

  Future<bool> update(BuildContext context, {required int id}) async {
    context.loaderOverlay.show();
    Response response =
        await API().patch(endPoint: "equipment/attachment/", data: {
      "attachment_id": id,
      "description": description,
      "dimension": dimension,
      "hour_of_renting": hor,
      "is_verified": isVerified,
      "location": location,
      "manufactured_year": dom,
      "name": name,
      "weight": weight,
    });
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

showAttachmentDetailPopup(BuildContext context,
    {required int id, required AttachmentDetailModel detail}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a, aa) {
        return AttachmentDetailEditPopup(id: id, detail: detail);
      });
}

class AttachmentDetailEditPopup extends StatefulWidget {
  final int id;
  final AttachmentDetailModel detail;

  late List<TextEditingController> controllers;
  AttachmentDetailEditPopup({Key? key, required this.id, required this.detail})
      : super(key: key) {
    controllers = List.generate(7, (index) {
      if (index == 0) {
        return TextEditingController(text: detail.name);
      } else if (index == 1) {
        return TextEditingController(text: detail.weight);
      } else if (index == 2) {
        return TextEditingController(text: detail.dimension);
      } else if (index == 3) {
        return TextEditingController(text: detail.hourOfRenting);
      } else if (index == 4) {
        var dom = DateFormat('yyyy-MM-dd').format(detail.dateOfManufacturing);
        return TextEditingController(text: dom);
      } else if (index == 5) {
        return TextEditingController(text: detail.location);
      } else {
        return TextEditingController(text: detail.description);
      }
    });
  }

  @override
  State<AttachmentDetailEditPopup> createState() =>
      _AttachmentDetailEditPopupState();
}

class _AttachmentDetailEditPopupState extends State<AttachmentDetailEditPopup> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Edit Detail".toUpperCase()),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (cnt) => CupertinoAlertDialog(
                  title: const Text("Any changes will be discard"),
                  actions: [
                    CupertinoDialogAction(
                      child: const Text(
                        "Discard",
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(cnt);
                        Navigator.pop(context);
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        "Cancel",
                        style: TextStyle(color: Colors.green),
                      ),
                      onPressed: () {
                        Navigator.pop(cnt);
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    textFieldText("Equipment Name"),
                    AEMPLTextField(
                      controller: widget.controllers[0],
                      hintText: "Equipment name",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter name";
                      },
                    ),
                    textFieldText("Weight"),
                    AEMPLTextField(
                      controller: widget.controllers[1],
                      hintText: "Weight",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter weight";
                      },
                    ),
                    textFieldText("Dimension"),
                    AEMPLTextField(
                      controller: widget.controllers[2],
                      hintText: "Dimension",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter dimension";
                      },
                    ),
                    textFieldText("Hour meter reading"),
                    AEMPLTextField(
                      controller: widget.controllers[3],
                      hintText: "Hour meter reading",
                      keyboardType: TextInputType.number,
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter hour meter reading";
                        }
                      },
                    ),
                    textFieldText("Year of Manufacturing"),
                    AEMPLTextField(
                      controller: widget.controllers[4],
                      hintText: "Year of manufacture",
                      keyboardType: TextInputType.number,
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter year of manufacture";
                        }
                      },
                    ),
                    textFieldText("Location"),
                    AEMPLTextField(
                      controller: widget.controllers[5],
                      hintText: "Location",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter location";
                      },
                    ),
                    textFieldText("Description"),
                    AEMPLTextField(
                      controller: widget.controllers[6],
                      hintText: "Description",
                      textInputAction: TextInputAction.done,
                      maxLines: 6,
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter description";
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          _AttachmentDetail _attachmentDetail =
                              _AttachmentDetail(
                            name: widget.controllers[0].text,
                            weight: widget.controllers[1].text,
                            dimension: widget.controllers[2].text,
                            hor: widget.controllers[3].text,
                            dom: widget.controllers[4].text,
                            location: widget.controllers[5].text,
                            description: widget.controllers[6].text,
                            isVerified: widget.detail.isVerified,
                          );
                          if (await _attachmentDetail.update(context,
                              id: widget.id)) {
                            AttachmentDetailsModel attachmentDetailsModel =
                                AttachmentDetailsModel();
                            await attachmentDetailsModel.fetchAttachmentDetails(
                                context, widget.id);
                            Navigator.pop(context);
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
