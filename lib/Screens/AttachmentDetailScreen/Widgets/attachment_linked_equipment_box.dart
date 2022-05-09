import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_linked_equipments_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Popups/equipment_attachment_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class AttachmentLinkedEquipmentBox extends StatelessWidget {
  final AttachmentLinkedEquipments equipmentLinked;
  final int id;

  const AttachmentLinkedEquipmentBox({
    Key? key,
    required this.equipmentLinked,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    int itemCounts = equipmentLinked.equipments.length;
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleBar(title: 'Linked Equipments'),
        ),
        GridView.builder(
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
              : attachmentBox(context,
                  eqipment: equipmentLinked.equipments[index]),
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
        onPressed: () {
          List<int> ids = [];
          for (var equip in equipmentLinked.equipments) {
            ids.add(equip.id);
          }
          showAttachmentLinkedEquipmentPopup(context, ids, id);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Center(
                  child: AEMPLIcon(
                    AEMPLIcons.link,
                    size: 40,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Link Equipment",
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
      {required AttachmentLinkedEquipmentModel eqipment}) {
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
                      imageUrl: eqipment.image,
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
                const SizedBox(height: 10),
                Text(
                  eqipment.name,
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
