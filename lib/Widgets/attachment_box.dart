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
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: CachedNetworkImage(
                    imageUrl: attachmentModel.image,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (context, url, error) =>
                        const Center(child: Icon(Icons.error)),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                attachmentModel.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
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
