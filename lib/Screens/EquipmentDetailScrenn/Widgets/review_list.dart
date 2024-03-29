import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_review_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class ReviewList extends StatefulWidget {
  final int id;
  const ReviewList({Key? key, required this.id}) : super(key: key);

  @override
  State<ReviewList> createState() => _ReviewListState();
}

class _ReviewListState extends State<ReviewList>
    with AutomaticKeepAliveClientMixin {
  final Reviews reviews = Reviews();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return FutureBuilder<Reviews>(
        future: reviews.fetchRating(widget.id),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Review> reviews = snapshot.data!.reviews;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TitleBar(title: 'Review'),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 10,
                  ).copyWith(bottom: 20),
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: BoxShadows.dropShadow(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Text(
                        snapshot.data!.avgRating.toString(),
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Overall Rating",
                              style: TextStyle(fontSize: 14),
                            ),
                            const SizedBox(height: 3),
                            RatingBar(
                              initialRating: snapshot.data!.avgRating,
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
                              itemPadding:
                                  const EdgeInsets.symmetric(horizontal: 1.5),
                              onRatingUpdate: (rating) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 20),
                  itemCount: reviews.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) => reviewBox(
                    context,
                    review: reviews[index],
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(height: 15),
                )
              ],
            );
          } else if (snapshot.hasError) {
            return const SizedBox();
          } else {
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          }
        });
  }

  @override
  bool get wantKeepAlive => true;

  Widget reviewBox(BuildContext context,
      {String? title, required Review review}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(45),
              child: CachedNetworkImage(
                height: 45,
                width: 45,
                fit: BoxFit.cover,
                imageUrl: review.profile,
                placeholder: (context, url) =>
                    const Center(child: CupertinoActivityIndicator()),
                errorWidget: (_, __, ___) =>
                    Image.asset("assets/images/placeholder.png"),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    review.ratedBy,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  RatingBar(
                    initialRating: review.rating + 0.0,
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
        Text(
          review.comment,
          style: const TextStyle(fontSize: 14),
        )
      ],
    );
  }
}
