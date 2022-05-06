import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AttachmentModel {
  late int id, count;
  late String name, description, location, dom, weight, dimension, hor, image;
  late DateTime? addedDate;
  late String price;
  AttachmentModel.fromMap(map) {
    id = map['id'] ?? 0;
    count = map['count'] ?? 0;
    name = map['name'] ?? "";
    description = map['description'] ?? "";
    location = map['location'] ?? "";
    weight = map['weight'] ?? "";
    dimension = map['dimension'] ?? "";
    hor = map['hor'] ?? "";
    image = map['image'] ?? "";
    addedDate = DateTime.tryParse(map['dom']);
    price = map['price'].toString();
  }
}

class AllAttachmentsModel {
  List<AttachmentModel> attactions = [];
  Future<AllAttachmentsModel> fetchAllAttractions() async {
    Response response = await API().get(endPoint: "equipment/attachment/");
    if (response.statusCode == 200) {
      attactions = [];
      response.data['data']
          .forEach((map) => attactions.add(AttachmentModel.fromMap(map)));
    }
    return this;
  }
}
