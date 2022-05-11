// ignore_for_file: implementation_imports

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/image_viewer.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

Future<String?>? uploadImage(BuildContext context) async {
  String? imagPath = await pickImage(context);
  if (imagPath == null) return null;
  File? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagPath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [CropAspectRatioPreset.square],
    iosUiSettings: const IOSUiSettings(
      title: 'Upload profile image',
      aspectRatioLockEnabled: true,
      resetAspectRatioEnabled: false,
    ),
    androidUiSettings: const AndroidUiSettings(
      toolbarTitle: 'Upload profile image',
      toolbarColor: Colors.deepOrange,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: true,
    ),
  );
  if (croppedFile == null) {
    return null;
  }
  return croppedFile.path;
}

Future<String?> pickImage(BuildContext context) async {
  await checkImagePermission(context);
  final List<AssetEntity>? result = await AssetPicker.pickAssets(
    context,
    maxAssets: 1,
    textDelegate: EnglishTextDelegate(),
    gridCount: MediaQuery.of(context).size.width ~/ 80,
    specialPickerType: SpecialPickerType.noPreview,
  );
  String imagePath;
  if (result == null) {
    return null;
  } else {
    imagePath = (await result.first.file)!.path;
    return imagePath;
  }
}

class ProfileUploadBox extends StatefulWidget {
  final String? image;
  const ProfileUploadBox({Key? key, this.image}) : super(key: key);

  @override
  State<ProfileUploadBox> createState() => ProfileUploadBoxState();
}

class ProfileUploadBoxState extends State<ProfileUploadBox>
    with AutomaticKeepAliveClientMixin {
  String? image;
  @override
  void initState() {
    image = widget.image;
    super.initState();
  }

  String? getImagePath() {
    return image;
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Center(
      child: Stack(
        children: [
          Container(
            height: 130,
            width: 130,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(100),
              boxShadow: BoxShadows.selectedDropShadow(context),
            ),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: ClipOval(
                    child: image == null
                        ? Image.asset("assets/images/uploadImage.png")
                        : Image.file(
                            File(image!),
                          ),
                  ),
                ),
                TextButton(
                  style: TextButtonStyles.overlayButtonStyle().copyWith(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100)),
                    ),
                  ),
                  onPressed: () => showImageBox(
                    context,
                    imagePaths: [],
                    index: 0,
                    heroTag: "profile Image",
                  ),
                  child: const SizedBox(
                    height: double.infinity,
                    width: double.infinity,
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: IconButton(
              onPressed: () async {
                String? pickedImage = await uploadImage(context);
                if (pickedImage != null) {
                  setState(() => image = pickedImage);
                }
              },
              iconSize: 16,
              padding: EdgeInsets.zero,
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(
                    color: const Color(0xff111111),
                    width: 1,
                  ),
                  boxShadow: BoxShadows.dropShadow(context),
                ),
                child: AEMPLIcon(
                  AEMPLIcons.edit,
                  size: 19,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
