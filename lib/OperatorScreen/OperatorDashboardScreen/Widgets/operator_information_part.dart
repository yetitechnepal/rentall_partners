import 'package:flutter/material.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/Widgets/operator_information_box.dart';
import 'package:rental_partners/Widgets/title_box.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class OperatorInformationpart extends StatelessWidget {
  final String value, title;

  const OperatorInformationpart({
    Key? key,
    required this.value,
    required this.title,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TitleBar(title: title),
        OperatorInformationBox(
          value: value,
          title: "Books",
          icon: AEMPLIcons.operator,
        ),
      ],
    );
  }
}
