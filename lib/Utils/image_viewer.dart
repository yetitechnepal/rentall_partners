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
                    allowImplicitScrolling: true,
                    itemCount: imagePaths.length,
                    controller: PageController(initialPage: index),
                    itemBuilder: (BuildContext context, int index) {
                      return Hero(
                        tag: heroTag,
                        child: CachedNetworkImage(
                          imageBuilder: (context, provider) {
                            return PhotoView(
                              tightMode: true,
                              backgroundDecoration: const BoxDecoration(
                                  color: Colors.transparent),
                              minScale: PhotoViewComputedScale.contained,
                              maxScale: PhotoViewComputedScale.contained * 5.0,
                              initialScale: PhotoViewComputedScale.contained,
                              imageProvider: provider,
                            );
                          },
                          imageUrl: imagePaths[index],
                          progressIndicatorBuilder: (context, val, progress) =>
                              Center(
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              constraints: const BoxConstraints(maxWidth: 300),
                              decoration: BoxDecoration(
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                                boxShadow: BoxShadows.dropShadow(context),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: LinearProgressIndicator(
                                  value: progress.progress),
                            ),
                          ),
                          errorWidget: (_, __, ___) =>
                              Image.asset("assets/images/placeholder.png"),
                        ),
                      );
                    },
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: SafeArea(
                      child: IconButton(
                        iconSize: 40,
                        splashRadius: 40,
                        onPressed: () => Navigator.pop(context),
                        icon: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(color: Colors.black, width: 2),
                            borderRadius: BorderRadius.circular(100),
                            boxShadow: BoxShadows.dropShadow(context),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Theme.of(context).primaryColor,
                            size: 27,
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
