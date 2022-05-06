import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_gallery.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

void showGalleryUploadPopup(BuildContext context, {required int equipId}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) => GalleryPopupBox(
      equipId: equipId,
      ctx: ctx,
    ),
  );
}

class GalleryPopupBox extends StatefulWidget {
  final int equipId;
  final BuildContext ctx;
  const GalleryPopupBox({Key? key, required this.equipId, required this.ctx})
      : super(key: key);
  @override
  State<GalleryPopupBox> createState() => _GalleryPopupBoxState();
}

class _GalleryPopupBoxState extends State<GalleryPopupBox> {
  List<AssetEntity> images = [];
  @override
  Widget build(BuildContext context) {
    int itemCounts = images.length;
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Upload gallery".toUpperCase()),
        ),
        body: Column(
          children: [
            Expanded(
              child: GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 140 / 114,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: itemCounts + 1,
                itemBuilder: (context, index) => index == itemCounts
                    ? addBox(context)
                    : imageBox(context, images[index]),
              ),
            ),
            SafeArea(
              child: TextButton(
                onPressed: () async {
                  EquipmentGallery equipmentGallery = EquipmentGallery(images);
                  if (await equipmentGallery.submit(
                    context,
                    id: widget.equipId,
                  )) {
                    EquipmentDetailModel equipmentDetailModel =
                        EquipmentDetailModel();
                    await equipmentDetailModel.fetchEquipmentDetail(
                        context, widget.equipId);
                    Navigator.pop(widget.ctx);
                  }
                },
                child: const Text("Upload"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget addBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: TextButton(
        onPressed: () async {
          final List<AssetEntity>? result = await AssetPicker.pickAssets(
            context,
            selectedAssets: images,
            maxAssets: 20,
            gridThumbSize: 100,
            textDelegate: EnglishTextDelegate(),
          );
          if (result == null) return;
          setState(() => images = result);
        },
        child: const Center(
          child: AEMPLIcon(
            AEMPLIcons.add,
            size: 40,
          ),
        ),
        style: TextButtonStyles.overlayButtonStyle(),
      ),
    );
  }

  Widget imageBox(BuildContext context, AssetEntity image) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image(
          fit: BoxFit.cover,
          image: AssetEntityImageProvider(image, isOriginal: false),
        ),
      ),
    );
  }
}
