import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

showModelDetailPopup(BuildContext context,
    {required EquipmentModelModel model}) {
  showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(13),
      ),
      child: EquipmentRateBox(model: model),
    ),
  );
}

class EquipmentRateBox extends StatelessWidget {
  final EquipmentModelModel model;

  const EquipmentRateBox({Key? key, required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Information",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
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
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "Name",
                value: model.name.toString(),
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "Dimension",
                value: model.dimension.toString(),
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "Weight",
                value: model.weight.toString(),
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "Location",
                value: model.location,
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "Counts",
                value: model.counts.toString(),
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "YOM",
                value: model.dom.toString(),
              ),
              const SizedBox(height: 6),
              _rowDetailText(
                context,
                title: "HMR",
                value: model.hor.toString(),
              ),
              const SizedBox(height: 10),
              const Text("Description", style: TextStyle(fontSize: 13)),
              const SizedBox(height: 3),
              Text(
                model.description,
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              "Rate",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
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
              const Text(
                "Base Rate",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Hourly Rate/Base Rate",
                subtitle: model.price.toString() + " x 1Hr",
                value: "NRs. " + model.price.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Daily Rate",
                subtitle: model.price.toString() + " x 8Hr",
                value: "NRs. " + (double.parse(model.price) * 8).toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Monthly Rate",
                subtitle: model.price.toString() + " x 8Hr x 26 Days",
                value:
                    "NRs. " + (double.parse(model.price) * 8 * 26).toString(),
              ),
              const SizedBox(height: 6),
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Rate with Fuel",
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Hourly Rate/Base Rate",
                subtitle: model.fuelIncludedRate.toString() + " x 1Hr",
                value: "NRs. " + model.fuelIncludedRate.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Daily Rate",
                subtitle: model.fuelIncludedRate.toString() + " x 8Hr",
                value: "NRs. " +
                    (double.parse(model.fuelIncludedRate) * 8).toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Monthly Rate",
                subtitle:
                    model.fuelIncludedRate.toString() + " x 8Hr x 26 Days",
                value: "NRs. " +
                    (double.parse(model.fuelIncludedRate) * 8 * 26).toString(),
              ),
              const SizedBox(height: 6),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _rowDetailText(BuildContext context,
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

  Widget _rowText(BuildContext context,
      {required String title,
      required String subtitle,
      required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xff585555),
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 10,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
