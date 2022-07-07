import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AddAtttachmentScreen/add_attachment_screen.dart';
import 'package:rental_partners/Screens/AllAttachmentsScreen/Model/all_equipment_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/attachment_detail_screen.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';

Widget attachmentBox(BuildContext context,
    {bool isLast = false, required AttachmentModel attachmentModel}) {
  if (isLast) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: TextButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddAttachmentScreen()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Center(
                  child: AEMPLIcon(
                    AEMPLIcons.add,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Add New Attachment",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                ),
              )
            ],
          ),
        ),
        style: TextButtonStyles.overlayButtonStyle(),
      ),
    );
  }
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: BoxShadows.dropShadow(context),
    ),
    child: Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(10)),
                child: CachedNetworkImage(
                  imageUrl: attachmentModel.image,
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  placeholder: (context, url) =>
                      const Center(child: CupertinoActivityIndicator()),
                  errorWidget: (_, __, ___) =>
                      Image.asset("assets/images/placeholder.png"),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                attachmentModel.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 5),
          ],
        ),
        TextButton(
          style: TextButtonStyles.overlayButtonStyle(),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    AttachmentDetailScreen(id: attachmentModel.id),
              ),
            );
          },
          child:
              const SizedBox(width: double.infinity, height: double.infinity),
        ),
      ],
    ),
  );
}
