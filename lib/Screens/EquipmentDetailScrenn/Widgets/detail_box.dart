import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/equipment_detail_edit_popup.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class EquipmentDetailBox extends StatelessWidget {
  final int equipId;
  final String name, category;
  final bool isVerified;

  const EquipmentDetailBox({
    Key? key,
    required this.equipId,
    required this.name,
    required this.category,
    required this.isVerified,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13),
          child: Row(
            children: [
              const Text(
                "Details",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                decoration: BoxDecoration(
                  color: isVerified ? Colors.green : Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isVerified ? "VERIFIED" : "NOT VERIFIED",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {
                  showEquipmentDetailEditPopup(
                    context,
                    id: equipId,
                    category: category,
                    name: name,
                  );
                },
                iconSize: 30,
                icon: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: BoxShadows.dropShadow(context),
            borderRadius: BorderRadius.circular(13),
          ),
          child: Column(
            children: [
              _rowText(context, title: "Name", value: name),
              const SizedBox(height: 6),
              _rowText(context, title: "Category", value: category),
              const SizedBox(height: 6),
            ],
          ),
        )
      ],
    );
  }

  Widget _rowText(BuildContext context,
      {required String title, required String value}) {
    return Row(
      children: [
        Container(
          width: 90,
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0, color: Color(0xffDCDCDC)),
            ),
          ),
          child: Text(
            title,
            style: const TextStyle(fontSize: 13),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 13),
          ),
        ),
      ],
    );
  }
}
