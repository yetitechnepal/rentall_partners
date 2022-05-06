class AttachmentLinkedEquipmentModel {
  late int id;
  late String name, image;
  AttachmentLinkedEquipmentModel.fromMap(map) {
    id = map['id'] ?? 0;
    name = map['name'] ?? "";
    image = map['image'] ?? "";
  }
  AttachmentLinkedEquipmentModel() {
    id = 0;
    name = "Equipment 1";
    image = "https://www.worldhighways.com/sites/ropl-wh/files/109509.jpg";
  }
}

class AttachmentLinkedEquipments {
  List<AttachmentLinkedEquipmentModel> equipments = [];
  AttachmentLinkedEquipments.fromMap(map) {
    for (var element in map['equipments']) {
      equipments.add(AttachmentLinkedEquipmentModel.fromMap(element));
    }
  }
  AttachmentLinkedEquipments() {
    equipments.add(AttachmentLinkedEquipmentModel());
    equipments.add(AttachmentLinkedEquipmentModel());
    equipments.add(AttachmentLinkedEquipmentModel());
  }
}
