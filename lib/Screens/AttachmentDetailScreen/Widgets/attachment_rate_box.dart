import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_rate_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class AttachmentRateBox extends StatelessWidget {
  final AttachmentRateModel rate;

  const AttachmentRateBox({Key? key, required this.rate}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: const Text(
              "Rate",
              style: TextStyle(
                fontSize: 20,
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
                "Attachment Base Rate",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Hourly Rate/Base Rate",
                subtitle: rate.hourlyRate.toString() + " x 1Hr",
                value: "NRs. " + rate.hourlyRate.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Daily Rate",
                subtitle: rate.hourlyRate.toString() + " x 8Hr",
                value: "NRs. " + rate.dailyRate.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Monthly Rate",
                subtitle: rate.hourlyRate.toString() + " x 8Hr x 26 Days",
                value: "NRs. " + rate.monthlyRate.toString(),
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
                "Attachment Rate with Fuel",
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Hourly Rate/Base Rate",
                subtitle: rate.hourlyRate.toString() + " x 1Hr",
                value: "NRs. " + rate.hourlyWithFuelRate.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Daily Rate",
                subtitle: rate.hourlyRate.toString() + " x 8Hr",
                value: "NRs. " + rate.dailyWithFuelRate.toString(),
              ),
              const SizedBox(height: 6),
              _rowText(
                context,
                title: "Monthly Rate",
                subtitle: rate.hourlyRate.toString() + " x 8Hr x 26 Days",
                value: "NRs. " + rate.monthlyWithFuelRate.toString(),
              ),
              const SizedBox(height: 6),
            ],
          ),
        )
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
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: Color(0xff585555),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            color: Theme.of(context).primaryColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
