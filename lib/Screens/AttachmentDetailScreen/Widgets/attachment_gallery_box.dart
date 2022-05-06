import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_images_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Popups/attachment_gallery_upload_popup.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/image_viewer.dart';
import 'package:rental_partners/main.dart';

Future<bool> _deleteImage(int imageId) async {
  Response response = await API()
      .delete(endPoint: "equipment/gallery/", data: {"image_id": imageId});
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

class AttachmentGalleryBox extends StatefulWidget {
  final AttachmentImagesModel images;

  final int id;

  const AttachmentGalleryBox({Key? key, required this.images, required this.id})
      : super(key: key);
  @override
  State<AttachmentGalleryBox> createState() => _ImageDisplaySliderState();
}

class _ImageDisplaySliderState extends State<AttachmentGalleryBox> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            _carousel(context),
            Positioned(
              bottom: 10,
              child: TextButton(
                onPressed: () {
                  showAttachmentGalleryUploadPopup(context, equipId: widget.id);
                },
                style: Theme.of(context).textButtonTheme.style!.copyWith(
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 4),
                      ),
                    ),
                child: const Text(
                  "Upload",
                  style: TextStyle(fontSize: 8),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 15),
          height: 10,
          alignment: Alignment.center,
          child: ListView.separated(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: widget.images.images.length,
            itemBuilder: (context, index) => Container(
              height: 10,
              width: 10,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: index == currentPage
                    ? Theme.of(context).primaryColor
                    : Colors.transparent,
                border: Border.all(
                  width: 1,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 5),
          ),
        ),
        const Divider(color: Color(0xffE8E8E8), thickness: 1),
      ],
    );
  }

  Widget _carousel(BuildContext context) {
    if (widget.images.images.isEmpty) {
      return const SizedBox(
        height: 260,
        child: Center(
          child: Text(
            "No image uploaded yet",
            style: TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    } else {
      return CarouselSlider.builder(
        itemCount: widget.images.images.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: BoxShadows.dropShadow(context),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.images.images[itemIndex].image,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                  TextButton(
                    style: TextButtonStyles.overlayButtonStyle(),
                    onPressed: () {
                      List<String> images = widget.images.images
                          .map((element) => element.image)
                          .toList();
                      showImageBox(
                        context,
                        imagePaths: images,
                        index: itemIndex,
                      );
                    },
                    child: const SizedBox(
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Material(
                        color: Colors.transparent,
                        child: IconButton(
                          onPressed: () {
                            showCupertinoDialog(
                              context: context,
                              builder: (ctx) => CupertinoAlertDialog(
                                title: const Text("Are you sure to delete?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text(
                                      "Yes",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () async {
                                      if (await _deleteImage(
                                          widget.images.images[itemIndex].id)) {
                                        AttachmentDetailsModel
                                            attachmentDetailsModel =
                                            AttachmentDetailsModel();
                                        await attachmentDetailsModel
                                            .fetchAttachmentDetails(
                                          context,
                                          widget.id,
                                        );
                                      }
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(ctx);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          color: primaryColor,
                          iconSize: 20,
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              boxShadow: BoxShadows.dropShadow(context),
                            ),
                            child: const AEMPLIcon(AEMPLIcons.trash),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        options: CarouselOptions(
          height: 260,
          aspectRatio: 327 / 250,
          viewportFraction: 1,
          initialPage: 0,
          enableInfiniteScroll: widget.images.images.length > 1,
          reverse: false,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 3),
          autoPlayAnimationDuration: const Duration(milliseconds: 800),
          autoPlayCurve: Curves.fastOutSlowIn,
          enlargeCenterPage: false,
          onPageChanged: (page, reason) => setState(() => currentPage = page),
          scrollDirection: Axis.horizontal,
        ),
      );
    }
  }
}
