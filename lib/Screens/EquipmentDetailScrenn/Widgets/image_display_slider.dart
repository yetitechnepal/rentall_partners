import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_gallery.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/gallery_upload_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/image_viewer.dart';

class ImageDisplaySlider extends StatefulWidget {
  final List<ImageModel> images;

  final int equipId;

  const ImageDisplaySlider(
      {Key? key, required this.images, required this.equipId})
      : super(key: key);
  @override
  State<ImageDisplaySlider> createState() => _ImageDisplaySliderState();
}

class _ImageDisplaySliderState extends State<ImageDisplaySlider> {
  int currentPage = 0;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomCenter,
          children: [
            _galleryCaraosel(context),
            Positioned(
              bottom: 10,
              child: TextButton(
                onPressed: () {
                  showGalleryUploadPopup(context, equipId: widget.equipId);
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
            itemCount: widget.images.length,
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

  Widget _galleryCaraosel(BuildContext context) {
    if (widget.images.isEmpty) {
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
        itemCount: widget.images.length,
        itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) =>
            ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            margin: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: BoxShadows.dropShadow(context),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: widget.images[itemIndex].imagePath,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (_, __, ___) =>
                        Image.asset("assets/images/placeholder.png"),
                  ),
                  TextButton(
                    style: TextButtonStyles.overlayButtonStyle(),
                    onPressed: () {
                      List<String> images = widget.images
                          .map((element) => element.imagePath)
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
                                      if (await EquipmentGallery.deleteImage(
                                          context,
                                          widget.images[itemIndex].id)) {
                                        EquipmentDetailModel
                                            equipmentDetailModel =
                                            EquipmentDetailModel();
                                        await equipmentDetailModel
                                            .fetchEquipmentDetail(
                                                context, widget.equipId);
                                      }
                                      Navigator.pop(context);
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    child: const Text(
                                      "No",
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                          color: primaryColor,
                          iconSize: 30,
                          icon: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100),
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
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
          enableInfiniteScroll: widget.images.length > 1,
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
