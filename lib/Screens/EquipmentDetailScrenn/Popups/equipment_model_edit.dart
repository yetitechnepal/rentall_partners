// ignore_for_file: implementation_imports, body_might_complete_normally_nullable

import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EditModel {
  final String name,
      dimension,
      weight,
      description,
      location,
      hor,
      dom,
      count,
      price,
      fuelIncludedRate,
      brand,
      capacity,
      application;
  final String networkImage;
  AssetEntity? localImage;

  EditModel({
    required this.name,
    required this.networkImage,
    this.localImage,
    required this.dimension,
    required this.weight,
    required this.description,
    required this.location,
    required this.hor,
    required this.dom,
    required this.count,
    required this.price,
    required this.fuelIncludedRate,
    required this.brand,
    required this.capacity,
    required this.application,
  });

  Future<bool> update(BuildContext context, int? id, int equipId) async {
    FormData formData = FormData.fromMap({
      "name": name,
      "dimension": dimension,
      "weight": weight,
      "description": description,
      "location": location,
      "hour_of_renting": hor,
      "manufactured_year": dom,
      "count": count,
      // "rate": price,
      // "fuel_included_rate": fuelIncludedRate,
      "brand_name": brand,
      "capacity": capacity,
      "application": application,
    });
    if (localImage == null) {
      formData.fields.add(MapEntry("image", networkImage));
    } else {
      formData.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            (await localImage!.file)!.path,
            filename: "model" +
                DateTime.now().millisecondsSinceEpoch.toString() +
                ".png",
          ),
        ),
      );
    }
    if (id != null) {
      formData.fields.add(MapEntry("id", id.toString()));
    } else {
      formData.fields.add(MapEntry("equipment", equipId.toString()));
      formData.fields.add(MapEntry("rate", price.toString()));
      formData.fields
          .add(MapEntry("fuel_included_rate", fuelIncludedRate.toString()));
    }
    Response response;
    if (id == null) {
      response = await API().post(endPoint: "equipment/model/", data: formData);
    } else {
      response = await API().put(endPoint: "equipment/model/", data: formData);
    }
    context.loaderOverlay.hide();
    final snackBar = SnackBar(content: Text(response.data['message']));
    scaffoldMessageKey.currentState!.showSnackBar(snackBar);
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

showEquipmentModelEditPopup(
  BuildContext context, {
  required int equipId,
  EquipmentModelModel? model,
}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a, aa) {
        return _EquipmentModelEdit(equipId: equipId, model: model);
      });
}

class _EquipmentModelEdit extends StatefulWidget {
  final int equipId;
  final EquipmentModelModel? model;

  const _EquipmentModelEdit({Key? key, required this.equipId, this.model})
      : super(key: key);
  @override
  State<_EquipmentModelEdit> createState() => _EquipmentModelEditState();
}

class _EquipmentModelEditState extends State<_EquipmentModelEdit> {
  AssetEntity? image;
  late final List<TextEditingController> controllers;
  bool isVATIncluded = false;

  @override
  initState() {
    controllers = List.generate(13, (index) {
      String value = "";
      if (widget.model != null) {
        switch (index) {
          case 0:
            value = widget.model!.name;
            break;
          case 1:
            value = widget.model!.dimension;
            break;
          case 2:
            value = widget.model!.weight;
            break;
          case 3:
            value = widget.model!.location;
            break;
          case 4:
            value = widget.model!.hor;
            break;
          case 5:
            value = widget.model!.dom;
            break;
          case 6:
            value = widget.model!.counts.toString();
            break;
          case 7:
            value = widget.model!.price;
            break;
          case 8:
            value = widget.model!.fuelIncludedRate;
            break;
          case 9:
            value = widget.model!.description;
            break;
          case 10:
            value = widget.model!.brand;
            break;
          case 11:
            value = widget.model!.capacity;
            break;
          case 12:
            value = widget.model!.application;
            break;
        }
      }
      return TextEditingController(text: value);
    });
    super.initState();
  }

  pickImage() async {
    await checkImagePermission(context);
    int gridCount = min(MediaQuery.of(context).size.width ~/ 80, 7);
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      pickerConfig: AssetPickerConfig(
        selectedAssets: [],
        maxAssets: 1,
        gridCount: gridCount,
        pageSize: 100,
        requestType: RequestType.image,
        specialPickerType: SpecialPickerType.noPreview,
      ),
    );
    if (result == null) return;
    setState(() => image = result.first);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text((widget.model == null ? "Add Model" : "Edit Model")
              .toUpperCase()),
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
                      ));
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            alignment: Alignment.topCenter,
            child: Container(
              constraints: const BoxConstraints(maxWidth: 500),
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 30),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: BoxShadows.dropShadow(context),
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: AspectRatio(
                              aspectRatio: 3 / 2,
                              child: Builder(builder: (context) {
                                if (image != null) {
                                  return Image(
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    image: AssetEntityImageProvider(image!,
                                        isOriginal: false),
                                  );
                                } else {
                                  if (widget.model == null) {
                                    return const Center(
                                      child: Text("Upload image"),
                                    );
                                  }
                                  return CachedNetworkImage(
                                    imageUrl: widget.model!.image,
                                    fit: BoxFit.cover,
                                    height: double.infinity,
                                    width: double.infinity,
                                    placeholder: (context, url) => const Center(
                                        child: CupertinoActivityIndicator()),
                                    errorWidget: (_, __, ___) => Image.asset(
                                        "assets/images/placeholder.png"),
                                  );
                                }
                              }),
                            ),
                          ),
                          Positioned(
                            bottom: -10,
                            right: -10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                boxShadow: BoxShadows.dropShadow(context),
                              ),
                              child: IconButton(
                                onPressed: pickImage,
                                color: primaryColor,
                                iconSize: 20,
                                visualDensity: VisualDensity.compact,
                                icon: const AEMPLIcon(AEMPLIcons.camera),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Model Name"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[0],
                      hintText: "Model name",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter name";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Dimension"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[1],
                      hintText: "Dimension",
                      prefix: const AEMPLIcon(AEMPLIcons.dimension, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter dimension";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Weight"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[2],
                      hintText: "Weight",
                      prefix: const AEMPLIcon(AEMPLIcons.weight, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter weight";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Location"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[3],
                      hintText: "Location",
                      prefix: const AEMPLIcon(AEMPLIcons.location, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter location";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Hour meter reading"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[4],
                      hintText: "Hour meter reading",
                      keyboardType: TextInputType.number,
                      prefix: const AEMPLIcon(AEMPLIcons.hmr, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter hour meter reading";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Manufactured year"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[5],
                      hintText: "Year of manufactured",
                      keyboardType: TextInputType.number,
                      prefix: const AEMPLIcon(AEMPLIcons.state, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter year of manufatured";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Counts"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[6],
                      hintText: "Counts",
                      keyboardType: TextInputType.number,
                      prefix: const AEMPLIcon(AEMPLIcons.numbers, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter counts";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Brand"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[10],
                      hintText: "Brand",
                      prefix: const AEMPLIcon(AEMPLIcons.brand, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter brand";
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Capacity"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[11],
                      hintText: "Capacity",
                      prefix: const AEMPLIcon(AEMPLIcons.capacity, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter capacity";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Application"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[12],
                      hintText: "Application",
                      prefix: const AEMPLIcon(AEMPLIcons.application, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter application";
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.model == null,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: textFieldText("Price"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: AEMPLTextField(
                            controller: controllers[7],
                            hintText: "Price",
                            keyboardType: TextInputType.number,
                            prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) return "Please enter price";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: textFieldText("Fuel included price"),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: AEMPLTextField(
                            controller: controllers[8],
                            hintText: "Fuel included price",
                            keyboardType: TextInputType.number,
                            prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) return "Please enter price";
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 20),
                          child: CheckboxListTile(
                            value: isVATIncluded,
                            title: const Text("VAT included rates"),
                            onChanged: (value) =>
                                setState(() => isVATIncluded = value!),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: textFieldText("Description"),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                    child: AEMPLTextField(
                      controller: controllers[9],
                      hintText: "Description",
                      maxLines: 4,
                      prefix: const AEMPLIcon(AEMPLIcons.description, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter name";
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: TextButton(
                        onPressed: () async {
                          String price = controllers[7].text;
                          String fuelIncludedRate = controllers[8].text;

                          if (isVATIncluded) {
                            price = (double.parse(price) / 1.13).toString();
                            fuelIncludedRate =
                                (double.parse(fuelIncludedRate) / 1.13)
                                    .toString();
                          }
                          EditModel editModel = EditModel(
                            name: controllers[0].text,
                            networkImage:
                                widget.model == null ? "" : widget.model!.image,
                            localImage: image,
                            dimension: controllers[1].text,
                            weight: controllers[2].text,
                            description: controllers[9].text,
                            location: controllers[3].text,
                            hor: controllers[4].text,
                            dom: controllers[5].text,
                            count: controllers[6].text,
                            price: price,
                            fuelIncludedRate: fuelIncludedRate,
                            brand: controllers[10].text,
                            capacity: controllers[11].text,
                            application: controllers[12].text,
                          );
                          if (await editModel.update(
                            context,
                            (widget.model == null) ? null : widget.model!.id,
                            widget.equipId,
                          )) {
                            EquipmentDetailModel equipmentDetailModel =
                                EquipmentDetailModel();
                            await equipmentDetailModel.fetchEquipmentDetail(
                              context,
                              widget.equipId,
                            );
                            Navigator.pop(context);
                          }
                        },
                        child: Text(widget.model == null ? "Save" : "Update")),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
