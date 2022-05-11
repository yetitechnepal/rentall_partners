import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  final String title;
  final bool isSeeAll;
  final Function()? onSeeAllPressed;
  final Widget? suffix;

  const TitleBar({
    Key? key,
    required this.title,
    this.onSeeAllPressed,
    this.isSeeAll = false,
    this.suffix,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final isTapNull = onSeeAllPressed == null;
    return Container(
      padding: EdgeInsets.symmetric(vertical: isTapNull ? 16 : 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              // color: Theme.of(context).textTheme.bodyText1!.color!,
            ),
          ),
          suffix ??
              Visibility(
                visible: !isTapNull,
                child: IconButton(
                  onPressed: onSeeAllPressed,
                  iconSize: 30,
                  icon: Text(
                    isSeeAll ? "Hide" : "See all",
                    style: TextStyle(
                      fontSize: 10,
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
