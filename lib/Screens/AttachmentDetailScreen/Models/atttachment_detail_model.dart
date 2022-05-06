class AttachmentDetailModel {
  late String name, weight, dimension, hourOfRenting, location, description;
  late bool isVerified;
  late DateTime dateOfManufacturing;
  AttachmentDetailModel.fromMap(map) {
    name = map['name'];

    weight = map['weight'];
    dimension = map['dimension'];
    hourOfRenting = map['hor'];
    dateOfManufacturing = DateTime.tryParse(map['dom']) ?? DateTime.now();
    location = map['location'];
    description = map['description'];
    isVerified = map['isVerified'];
  }
  AttachmentDetailModel() {
    name = "CAT Dozer";
    weight = "1200 lbs";
    dimension = "20 x 40";
    hourOfRenting = "120hrs";
    dateOfManufacturing = DateTime.now();
    location = "Pokhara";
    description =
        "Skid Steer Grader Attachment (Laser System Optional). Skid Steer Grader Attachment (Laser System Optional). Skid Steer Grader Attachment (Laser System Optional)";
    isVerified = true;
  }
}
