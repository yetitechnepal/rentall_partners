import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AttachmentReviewModel {
  final int id, rating;
  final String comment, ratedBy, profile;
  AttachmentReviewModel(
      this.id, this.rating, this.comment, this.ratedBy, this.profile);
}

class AttachmentReviewsModel {
  double avgRating = 0.0;
  List<AttachmentReviewModel> reviews = [];
  Future<AttachmentReviewsModel> fetchRating(int id) async {
    Response responseReview = await API()
        .get(endPoint: "equipment/attachment/$id/review/", useToken: false);
    if (responseReview.statusCode == 200) {
      var ratings = responseReview.data['data'];
      avgRating = ratings['avg_rating'] ?? 0.0;
      reviews = [];
      ratings['review'].forEach((json) {
        AttachmentReviewModel review = AttachmentReviewModel(
            json['id'],
            json['rating'],
            json['comment'],
            json['rated_by'],
            json['profile'] ?? "");
        reviews.add(review);
      });
    }
    return this;
  }
}
