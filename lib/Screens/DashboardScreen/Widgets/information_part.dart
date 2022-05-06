import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/DashboardScreen/Widgets/information_box.dart';
import 'package:rental_partners/Widgets/title_box.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class Informationpart extends StatelessWidget {
  final String attachmentValue, equipmentValue, title;
  final bool isBoth;

  const Informationpart({
    Key? key,
    required this.attachmentValue,
    required this.equipmentValue,
    required this.title,
    this.isBoth = true,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: TitleBar(title: title),
        ),
        GridView.extent(
          shrinkWrap: true,
          maxCrossAxisExtent: 200,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          childAspectRatio: 4 / 3,
          children: [
            InformationBox(
              value: equipmentValue,
              title: "Equipment Orders",
              icon: AEMPLIcons.equipment,
            ),
            isBoth
                ? InformationBox(
                    value: attachmentValue,
                    title: "Attachment Orders",
                    icon: AEMPLIcons.attachment,
                  )
                : const Expanded(child: SizedBox()),
          ],
        ),
      ],
    );
  }
}
