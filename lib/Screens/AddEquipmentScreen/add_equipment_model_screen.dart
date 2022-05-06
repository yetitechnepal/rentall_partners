import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_model.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_model_class.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/Widgets/images_upload.dart';
import 'package:rental_partners/Widgets/model_box.dart';
import 'package:rental_partners/Widgets/title_box.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class AddEquipmentModelScreen extends StatefulWidget {
  final int remoteId;

  const AddEquipmentModelScreen({
    Key? key,
    required this.remoteId,
  }) : super(key: key);

  @override
  State<AddEquipmentModelScreen> createState() =>
      _AddEquipmentModelScreenState();
}

class _AddEquipmentModelScreenState extends State<AddEquipmentModelScreen> {
  final controllers = List.generate(5, (index) => TextEditingController());

  final formKey = GlobalKey<FormState>();

  final imageKey = GlobalKey<ImagesUploadSectionState>();

  List<AddEquipmentModelModel> models = [];

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: Text("EQUIPMENT MODEL".toUpperCase())),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.topCenter,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 16),
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      boxShadow: BoxShadows.dropShadow(context),
                    ),
                    constraints: const BoxConstraints(maxWidth: 500),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        textFieldText("Model Name"),
                        AEMPLTextField(
                          controller: controllers[0],
                          hintText: "Model name",
                          prefix: const AEMPLIcon(AEMPLIcons.model, size: 20),
                          validator: (value) {
                            if (value!.isEmpty) return "Please enter name";
                          },
                        ),
                        // textFieldText("Model Category"),
                        // AEMPLTextField(
                        //   controller: controllers[1],
                        //   hintText: "Model category",
                        //   prefix: const AEMPLIcon(AEMPLIcons.category, size: 20),
                        //   validator: (value) {
                        //     if (value!.isEmpty) return "Please enter category";
                        //   },
                        // ),
                        textFieldText("Upload Image"),
                        ImagesUploadSection(
                          key: imageKey,
                          max: 1,
                        ),
                        const SizedBox(height: 20),
                        Center(
                          child: TextButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                AssetEntity image =
                                    imageKey.currentState!.selectedImages.first;
                                String imagePath = (await image.file)!.path;
                                String imageId = image.id;

                                AddEquipmentModelModel addEquipmentModelModel =
                                    AddEquipmentModelModel(
                                  image: imagePath,
                                  name: controllers[0].text,
                                  imageId: imageId,
                                );
                                models.add(addEquipmentModelModel);
                                controllers[0].clear();
                                imageKey.currentState!.resetSelection();
                                setState(() => models = models);
                              }
                            },
                            child: const Text("Add Model"),
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.0),
                  child: TitleBar(title: "Models Added"),
                ),
                GridView.builder(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 165 / 190,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                  ),
                  itemCount: models.length,
                  itemBuilder: (context, index) => modelBoxLocal(context,
                      model: models[index], onEdit: () async {
                    AssetEntity image =
                        (await AssetEntity.fromId(models[index].imageId))!;
                    controllers[0].text = models[index].name;
                    imageKey.currentState!.setImage([image]);
                    models.removeAt(index);
                    setState(() => models);
                  }),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () {
                      EquipModels equipModels = EquipModels();
                      for (var element in models) {
                        equipModels.models.add(EquipModel(
                            image: element.image, name: element.name));
                      }
                      equipModels.submit(context, widget.remoteId);

                      // Get.to(
                      //   () => AddEquipmentSeriesScreen(
                      //     addEquipmentModel: widget.addEquipmentModel,
                      //   ),
                      // );
                    },
                    child: const Text("Next"),
                  ),
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
