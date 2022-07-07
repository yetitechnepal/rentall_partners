import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

Widget modelBox(BuildContext context, {required EquipmentModelModel model}) {
  return Container(
    padding: const EdgeInsets.only(top: 13),
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: BoxShadows.dropShadow(context),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: CachedNetworkImage(
              imageUrl: model.image,
              fit: BoxFit.contain,
              height: double.infinity,
              width: double.infinity,
              placeholder: (context, url) =>
                  const Center(child: CupertinoActivityIndicator()),
              errorWidget: (_, __, ___) =>
                  Image.asset("assets/images/placeholder.png"),
            ),
          ),
        ),
        const Divider(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                model.name,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Rs " + model.name,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      borderRadius: BorderRadius.circular(100),
                      elevation: 0,
                      color: Colors.transparent,
                      child: IconButton(
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        visualDensity: VisualDensity.compact,
                        onPressed: () {},
                        icon: Text(
                          "Edit",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget modelBoxLocal(
  BuildContext context, {
  required AddEquipmentModelModel model,
  Function()? onEdit,
}) {
  return Container(
    decoration: BoxDecoration(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
      color: Theme.of(context).scaffoldBackgroundColor,
      boxShadow: BoxShadows.dropShadow(context),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.file(
              File(model.image),
              fit: BoxFit.cover,
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                model.name,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Material(
                  borderRadius: BorderRadius.circular(100),
                  elevation: 0,
                  color: Colors.transparent,
                  child: IconButton(
                    iconSize: 20,
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                    onPressed: onEdit,
                    icon: Text(
                      "Edit",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
