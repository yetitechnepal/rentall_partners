import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/add_button.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

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
            return addButton(context, onPressed: () async {
              await checkImagePermission(context);
              final List<AssetEntity>? result = await AssetPicker.pickAssets(
                context,
                selectedAssets: selectedImages,
                maxAssets: widget.max,
                gridCount: MediaQuery.of(context).size.width ~/ 80,
                specialPickerType: widget.max == 1
                    ? SpecialPickerType.noPreview
                    : SpecialPickerType.wechatMoment,
                textDelegate: EnglishTextDelegate(),
              );
              if (result == null) return;
              setState(() => selectedImages = result);
            });
          }
          return Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: BoxShadows.dropShadow(context),
            ),
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
