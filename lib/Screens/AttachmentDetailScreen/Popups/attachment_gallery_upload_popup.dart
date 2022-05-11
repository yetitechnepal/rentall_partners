import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/check_permission.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ImageGallery {
  List<AssetEntity> imageEntities = [];
  ImageGallery(this.imageEntities);

  Future<bool> submit(BuildContext context, {required int id}) async {
    context.loaderOverlay.show();
    var data = FormData.fromMap({"attachment": id});
    for (int index = 0; index < imageEntities.length; index++) {
      data.files.add(
        MapEntry(
          "image",
          await MultipartFile.fromFile(
            (await imageEntities[index].file)!.path,
            filename: "attachment" +
                DateTime.now().millisecondsSinceEpoch.toString() +
                ".png",
          ),
        ),
      );
    }
    Response response =
        await API().post(endPoint: "equipment/gallery/", data: data);
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      final snackBar = SnackBar(content: Text(response.data['message']));
      scaffoldMessageKey.currentState!.showSnackBar(snackBar);

      return true;
    } else {
      final snackBar = SnackBar(content: Text(response.data['message']));
      scaffoldMessageKey.currentState!.showSnackBar(snackBar);
      return false;
    }
  }
}

void showAttachmentGalleryUploadPopup(BuildContext context,
    {required int equipId}) {
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
          title: Text("Upload Gallery".toUpperCase()),
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
                  ImageGallery imageGallery = ImageGallery(images);
                  if (await imageGallery.submit(
                    context,
                    id: widget.equipId,
                  )) {
                    AttachmentDetailsModel attachmentDetailsModel =
                        AttachmentDetailsModel();
                    await attachmentDetailsModel.fetchAttachmentDetails(
                      context,
                      widget.equipId,
                    );
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
          await checkImagePermission(context);
          final List<AssetEntity>? result = await AssetPicker.pickAssets(
            context,
            selectedAssets: images,
            maxAssets: 20,
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
