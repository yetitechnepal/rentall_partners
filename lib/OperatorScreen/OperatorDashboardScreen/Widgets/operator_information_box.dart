import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/OrdersScreens/orders_list_screen.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class OperatorInformationBox extends StatelessWidget {
  final String value, title;
  final AEMPLIcons icon;

  const OperatorInformationBox(
      {Key? key, required this.value, required this.title, required this.icon})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: TextButton(
        style: TextButtonStyles.overlayButtonStyle(),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrdersListScreen()),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 13, horizontal: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 36,
                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                  ),
                  AEMPLIcon(
                    icon,
                    size: 26,
                    color: Theme.of(context).textTheme.bodyLarge!.color!,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).textTheme.bodyMedium!.color!,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
