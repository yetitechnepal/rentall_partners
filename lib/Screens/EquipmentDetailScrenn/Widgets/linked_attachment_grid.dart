import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/equipment_attachment_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class LinkedAttachmentSection extends StatelessWidget {
  final List<EquipmentAttractmentModel> attachments;
  final int equipId;
  const LinkedAttachmentSection(
      {Key? key, required this.attachments, required this.equipId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    int itemCounts = attachments.length;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleBar(title: 'Linked Attachment'),
        ),
        GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 140 / 114,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: itemCounts + 1,
          itemBuilder: (context, index) => index == itemCounts
              ? addBox(context)
              : attachmentBox(context, attachmentModel: attachments[index]),
        ),
      ],
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
        onPressed: () =>
            showEquipmentAttachmentPopup(context, attachments, equipId),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Expanded(
                child: Center(
                  child: AEMPLIcon(
                    AEMPLIcons.link,
                    size: 40,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Link Attachment",
                textAlign: TextAlign.center,
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

  Widget attachmentBox(BuildContext context,
      {required EquipmentAttractmentModel attachmentModel}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
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
            onPressed: () {},
            child:
                const SizedBox(width: double.infinity, height: double.infinity),
          ),
        ],
      ),
    );
  }
}
