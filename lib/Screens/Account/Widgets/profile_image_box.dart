// ignore_for_file: implementation_imports

import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/image_viewer.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

uploadImage(BuildContext context) async {
  String? imagPath = await pickImage(context);
  if (imagPath == null) return;
  File? croppedFile = await ImageCropper().cropImage(
    sourcePath: imagPath,
    aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
    aspectRatioPresets: [CropAspectRatioPreset.square],
    iosUiSettings: const IOSUiSettings(
      title: 'Upload profile image',
      aspectRatioLockEnabled: true,
      resetAspectRatioEnabled: false,
    ),
    androidUiSettings: AndroidUiSettings(
      toolbarTitle: 'Upload profile image',
      toolbarColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.black,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.square,
      activeControlsWidgetColor: Theme.of(context).primaryColor,
      lockAspectRatio: true,
    ),
  );
  FormData formData = FormData();
  formData.files.add(MapEntry(
    "image",
    await MultipartFile.fromFile(
      croppedFile!.path,
      filename: "profile-" +
          DateTime.now().millisecondsSinceEpoch.toString() +
          '.jpg',
    ),
  ));
  Response response =
      await API().post(endPoint: "accounts/profile-change/", data: formData);

  final snackBar = SnackBar(content: Text(response.data['message']));
  scaffoldMessageKey.currentState!.showSnackBar(snackBar);
  if (response.statusCode == 200) {
    context.read<ProfileCubit>().fetchProfile();
    return true;
  } else {
    return false;
  }
}

Future<String?> pickImage(BuildContext context) async {
  await checkImagePermission(context);
  final List<AssetEntity>? result = await AssetPicker.pickAssets(
    context,
    maxAssets: 1,
    textDelegate: EnglishTextDelegate(),
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

class ProfileImageBox extends StatelessWidget {
  final String image;

  const ProfileImageBox({Key? key, required this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                  child: Hero(
                    tag: "profile Image",
                    child: ClipOval(
                      child: CachedNetworkImage(
                        imageUrl: image,
                        height: 120,
                        width: 120,
                        fit: BoxFit.cover,
                        placeholder: (context, url) =>
                            const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (_, __, ___) =>
                            Image.asset("assets/images/placeholder.png"),
                      ),
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
                    imagePaths: [image],
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
              onPressed: () {
                uploadImage(context);
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
}
