import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

showImageBox(BuildContext context,
    {required List<String> imagePaths, required int index}) {
  showDialog(
      context: context,
      useSafeArea: false,
      barrierDismissible: true,
      builder: (ctx) {
        return Material(
          color: Colors.transparent,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: SizedBox(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ExpandablePageView.builder(
                    itemCount: imagePaths.length,
                    controller: PageController(initialPage: index),
                    itemBuilder: (BuildContext context, int index) {
                      return PhotoView(
                        tightMode: true,
                        minScale: PhotoViewComputedScale.contained,
                        maxScale: PhotoViewComputedScale.contained * 3.0,
                        initialScale: PhotoViewComputedScale.contained,
                        imageProvider:
                            CachedNetworkImageProvider(imagePaths[index]),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SafeArea(
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100),
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
