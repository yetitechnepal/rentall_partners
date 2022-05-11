// ignore_for_file: implementation_imports, body_might_complete_normally_nullable

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
  final String name;
  final String networkImage;
  AssetEntity? localImage;

  EditModel(this.name, this.networkImage, this.localImage);

  Future<bool> update(BuildContext context, int id) async {
    FormData formData = FormData.fromMap({
      "model": name,
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
    Response response =
        await API().put(endPoint: "equipment/model/$id/", data: formData);
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
  required int id,
  required String image,
  required String name,
}) {
  showGeneralDialog(
      context: context,
      pageBuilder: (ctx, a, aa) {
        return _EquipmentModelEdit(id: id, name: name, image: image);
      });
}

class _EquipmentModelEdit extends StatefulWidget {
  final int id;
  final String name, image;

  const _EquipmentModelEdit(
      {Key? key, required this.id, required this.name, required this.image})
      : super(key: key);
  @override
  State<_EquipmentModelEdit> createState() => _EquipmentModelEditState();
}

class _EquipmentModelEditState extends State<_EquipmentModelEdit> {
  AssetEntity? image;
  late final TextEditingController controller;

  @override
  initState() {
    controller = TextEditingController(text: widget.name);
    super.initState();
  }

  pickImage() async {
    await checkImagePermission(context);
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      selectedAssets: [],
      maxAssets: 1,
      textDelegate: EnglishTextDelegate(),
      gridCount: MediaQuery.of(context).size.width ~/ 100,
      specialPickerType: SpecialPickerType.noPreview,
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
          title: Text("Edit Model".toUpperCase()),
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
                                  return CachedNetworkImage(
                                    imageUrl: widget.image,
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
                      controller: controller,
                      hintText: "Model name",
                      prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                      validator: (value) {
                        if (value!.isEmpty) return "Please enter name";
                      },
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: TextButton(
                        onPressed: () async {
                          EditModel editModel =
                              EditModel(controller.text, widget.image, image);
                          if (await editModel.update(context, widget.id)) {
                            EquipmentDetailModel equipmentDetailModel =
                                EquipmentDetailModel();
                            await equipmentDetailModel.fetchEquipmentDetail(
                                context, widget.id);
                            Navigator.pop(context);
                          }
                        },
                        child: const Text("Update")),
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
