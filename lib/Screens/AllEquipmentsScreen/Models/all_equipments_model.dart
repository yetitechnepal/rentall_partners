import 'package:dio/dio.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class Equipment {
  late int id;
  late String image, name;
  Equipment.fromMap(map) {
    id = map['id'] ?? 0;
    image = map['image'] ?? "";
    name = map['name'] ?? "";
  }
}

class AllEquipmentModel {
  List<Equipment> equipments = [];
  Future<AllEquipmentModel> fetchAllEquipments() async {
    Response response =
        await API().get(endPoint: "equipment/company/all-listing/");
    if (response.statusCode == 200) {
      equipments = [];
      var data = response.data['data'];
      data['equipment']
          .forEach((map) => equipments.add(Equipment.fromMap(map)));
    }
    return this;
  }
}
