import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/atttachment_detail_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Popups/attachment_detail_edit_popup.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class AttachmentDetailBox extends StatelessWidget {
  final int id;
  final AttachmentDetailModel detail;

  const AttachmentDetailBox({
    Key? key,
    required this.id,
    required this.detail,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
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
                Image.asset(
                  detail.isVerified
                      ? "assets/icons/verified.png"
                      : "assets/icons/forbidden.png",
                  height: 15,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () {
                    showAttachmentDetailPopup(context, id: id, detail: detail);
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _rowText(context, title: "Name", value: detail.name),
              const SizedBox(height: 6),
              _rowText(context, title: "Weight", value: detail.weight),
              const SizedBox(height: 6),
              _rowText(context, title: "Dimension", value: detail.dimension),
              const SizedBox(height: 6),
              _rowText(context, title: "HMR", value: detail.hourOfRenting),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "DOM",
                value: DateFormat("MMM dd, yyyy")
                    .format(detail.dateOfManufacturing),
              ),
              const SizedBox(height: 6),
              _rowText(context, title: "Location", value: detail.location),
              const SizedBox(height: 6),
              Container(
                width: 90,
                decoration: const BoxDecoration(
                    // border: Border(
                    //   right: BorderSide(width: 1.0, color: Color(0xffDCDCDC)),
                    // ),
                    ),
                child: const Text(
                  "Description",
                  style: TextStyle(fontSize: 13),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                detail.description,
                style: const TextStyle(fontSize: 13),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _rowText(BuildContext context,
      {required String title, required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
