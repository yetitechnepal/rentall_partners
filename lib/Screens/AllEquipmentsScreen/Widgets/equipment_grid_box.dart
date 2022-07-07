// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AllEquipmentsScreen/Models/all_equipments_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/equipment_detail_screen.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class EquipmentGridBox extends StatelessWidget {
  final AsyncSnapshot<AllEquipmentModel> asyncsnapshot;

  EquipmentGridBox({Key? key, required this.asyncsnapshot}) : super(key: key);

  String keyWord = "";

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      List<Equipment?> equipments = [];
      for (var equip in asyncsnapshot.data!.equipments) {
        if (equip.name.contains(keyWord)) equipments.add(equip);
      }
      return Column(
        children: [
          const SizedBox(height: 15),
          Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AEMPLTextField(
              onSubmit: (value) => setState(() => keyWord = value),
              onChanged: (value) => setState(() => keyWord = value),
              hintText: "Search....",
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.search,
              prefix: AEMPLIcon(
                AEMPLIcons.search,
                size: 20,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: const TitleBar(title: "All Equipments "),
          ),
          Expanded(
            child: GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6)
                  .copyWith(bottom: 30),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.05,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemCount: equipments.length,
              itemBuilder: (context, index) {
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: BoxShadows.dropShadow(context),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color:
                                    Theme.of(context).scaffoldBackgroundColor,
                              ),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(10)),
                                child: CachedNetworkImage(
                                  imageUrl: equipments[index]!.image,
                                  fit: BoxFit.cover,
                                  height: double.infinity,
                                  width: double.infinity,
                                  placeholder: (context, url) => const Center(
                                      child: CupertinoActivityIndicator()),
                                  errorWidget: (_, __, ___) => Image.asset(
                                      "assets/images/placeholder.png"),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 5.0),
                            child: Text(
                              equipments[index]!.name,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                      TextButton(
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          primary: primaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => EquipmentDetailScreen(
                                  id: equipments[index]!.id)),
                        ),
                        child: const SizedBox(
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }
}
