import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Widget reviewBox(BuildContext context, {String? title}) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(45),
            child: CachedNetworkImage(
              height: 45,
              width: 45,
              fit: BoxFit.cover,
              imageUrl:
                  "https://www.denofgeek.com/wp-content/uploads/2019/02/mcu-1-iron-man.jpg?fit=1200%2C675",
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Ramesh Nepal",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                RatingBar(
                  initialRating: 3,
                  itemSize: 14,
                  direction: Axis.horizontal,
                  allowHalfRating: false,
                  itemCount: 5,
                  ignoreGestures: false,
                  ratingWidget: RatingWidget(
                    full: Image.asset('assets/icons/full_star.png'),
                    half: Image.asset('assets/icons/full_star.png'),
                    empty: Image.asset('assets/icons/no_star.png'),
                  ),
                  itemPadding: const EdgeInsets.symmetric(horizontal: 1.5),
                  onRatingUpdate: (rating) {},
                ),
              ],
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      const Text(
        '''Here will be the review.Here will be the review.Here will be the review.Here will be the review.Here will be the review.Here will be the review.Here will be the review.''',
        style: TextStyle(fontSize: 14),
      )
    ],
  );
}
