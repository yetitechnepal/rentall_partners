import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Utils/add_button.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

class ImagesUploadSection extends StatefulWidget {
  final int max;
  const ImagesUploadSection({Key? key, this.max = 20}) : super(key: key);

  @override
  State<ImagesUploadSection> createState() => ImagesUploadSectionState();
}

class ImagesUploadSectionState extends State<ImagesUploadSection>
    with AutomaticKeepAliveClientMixin {
  List<AssetEntity> selectedImages = [];

  Future<List<String>> getImagepathList() async {
    List<String> images = [];
    for (int index = 0; index < selectedImages.length; index++) {
      String imagePath = (await selectedImages[index].file)!.path;
      images.add(imagePath);
    }
    return images;
  }

  String? imagePath;

  setImage(List<AssetEntity> images) => setState(() => selectedImages = images);

  resetSelection() => setState(() => selectedImages = []);

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
            .copyWith(bottom: 30),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 140,
          childAspectRatio: 1,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: selectedImages.length + 1,
        itemBuilder: (context, index) {
          if (index == selectedImages.length) {
            return addButton(context, onPressed: () {
              showCupertinoDialog(
                  context: context,
                  barrierDismissible: true,
                  builder: (context) => CupertinoAlertDialog(
                        actions: [
                          CupertinoButton(
                              child: const Text('Use Camera'),
                              onPressed: () async {
                                if (selectedImages.isEmpty) {
                                  Navigator.of(context).pop();
                                  final AssetEntity? entity =
                                      await CameraPicker.pickFromCamera(
                                    context,
                                    pickerConfig: const CameraPickerConfig(
                                        textDelegate:
                                            EnglishCameraPickerTextDelegate()),
                                  );
                                  if (entity == null) return;
                                  setState(() => selectedImages.add(entity));
                                } else {
                                  resetSelection();
                                  Navigator.of(context).pop();
                                  final AssetEntity? entity =
                                      await CameraPicker.pickFromCamera(
                                    context,
                                    pickerConfig: const CameraPickerConfig(
                                        textDelegate:
                                            EnglishCameraPickerTextDelegate()),
                                  );
                                  if (entity == null) return;
                                  setState(() => selectedImages.add(entity));
                                }
                              }),
                          CupertinoButton(
                              child: const Text('Select from Gallary'),
                              onPressed: () async {
                                Navigator.of(context).pop();
                                await checkImagePermission(context);
                                final List<AssetEntity>? result =
                                    await AssetPicker.pickAssets(
                                  context,
                                  pickerConfig: AssetPickerConfig(
                                    selectedAssets: selectedImages,
                                    maxAssets: widget.max,
                                    gridCount:
                                        MediaQuery.of(context).size.width ~/ 80,
                                    pageSize: 100,
                                    requestType: RequestType.image,
                                  ),
                                );
                                if (result == null) return;
                                setState(() => selectedImages = result);
                              }),
                        ],
                      ));
            });
          }

          return Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black12)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image(
                fit: BoxFit.cover,
                image: AssetEntityImageProvider(selectedImages[index],
                    isOriginal: false),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
