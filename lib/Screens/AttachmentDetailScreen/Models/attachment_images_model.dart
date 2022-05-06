class AttachmentImage {
  final int id;
  final String image;

  AttachmentImage(this.id, this.image);
}

class AttachmentImagesModel {
  List<AttachmentImage> images = [];
  AttachmentImagesModel.fromMap(map) {
    for (var element in map['images']) {
      images.add(AttachmentImage(element['id'], element['path'] ?? ""));
    }
  }
}
