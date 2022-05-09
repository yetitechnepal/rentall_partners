import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

showImageBox(BuildContext context,
    {required List<String> imagePaths,
    required int index,
    String heroTag = ""}) {
  showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: true,
      barrierColor: Colors.transparent,
      builder: (ctx) {
        return Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 6.0, sigmaY: 6.0),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  PageView.builder(
                    itemCount: imagePaths.length,
                    controller: PageController(initialPage: index),
                    itemBuilder: (BuildContext context, int index) {
                      return Hero(
                        tag: heroTag,
                        child: PhotoView(
                          tightMode: true,
                          backgroundDecoration:
                              const BoxDecoration(color: Colors.transparent),
                          minScale: PhotoViewComputedScale.contained,
                          maxScale: PhotoViewComputedScale.contained * 5.0,
                          initialScale: PhotoViewComputedScale.contained,
                          imageProvider:
                              CachedNetworkImageProvider(imagePaths[index]),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SafeArea(
                      child: IconButton(
                        iconSize: 30,
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: BoxShadows.dropShadow(context),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
}
