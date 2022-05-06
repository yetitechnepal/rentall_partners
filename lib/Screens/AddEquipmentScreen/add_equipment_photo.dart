import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_images.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Widgets/images_upload.dart';

class AddEquipmentPhoto extends StatefulWidget {
  final int equipId;

  const AddEquipmentPhoto({Key? key, required this.equipId}) : super(key: key);
  @override
  State<AddEquipmentPhoto> createState() => _AddEquipmentPhotoState();
}

class _AddEquipmentPhotoState extends State<AddEquipmentPhoto> {
  final imageKey = GlobalKey<ImagesUploadSectionState>();
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("ADD PHOTO")),
        body: ImagesUploadSection(key: imageKey),
        floatingActionButton: TextButton(
          onPressed: () async {
            List<String> imagesPath =
                await imageKey.currentState!.getImagepathList();
            AddEquipmentImages addEquipmentImages =
                AddEquipmentImages(imagesPath);
            addEquipmentImages.submit(context, equipment: widget.equipId);
          },
          child: const Text("Submit"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
