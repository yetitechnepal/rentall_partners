// ignore_for_file: body_might_complete_normally_nullable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_class.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/Widgets/images_upload.dart';
import 'package:rental_partners/Widgets/model_box.dart';
import 'package:rental_partners/Widgets/title_box.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../Blocs/category_bloc.dart';

class AddEquipmentModelScreen extends StatefulWidget {
  const AddEquipmentModelScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AddEquipmentModelScreen> createState() =>
      _AddEquipmentModelScreenState();
}

class _AddEquipmentModelScreenState extends State<AddEquipmentModelScreen> {
  final controllers = List.generate(14, (index) => TextEditingController());
  final equipmentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  final imageKey = GlobalKey<ImagesUploadSectionState>();

  List<AddEquipmentModelModel> models = [];
  bool isVATIncluded = false;

  final ScrollController _scrollController = ScrollController();
  Category? _selectedCategory;

  void _scrollToTop() {
    _scrollController.animateTo(0,
        duration: const Duration(milliseconds: 400), curve: Curves.linear);
    for (TextEditingController controller in controllers) {
      controller.clear();
    }
    imageKey.currentState!.resetSelection();
    setState(() {
      isVATIncluded = false;
      models = models;
    });
    Navigator.of(context).pop();
  }

  String equipmentName = "";
  @override
  void dispose() {
    _scrollController.dispose(); // dispose the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: Text("EQUIPMENT MODEL".toUpperCase())),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Form(
              key: formKey,
              child: ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
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
                              textFieldText("Equipment Name"),
                              AEMPLTextField(
                                controller: equipmentController,
                                hintText: "Equipment name",
                                prefix: const AEMPLIcon(AEMPLIcons.equipment,
                                    size: 20),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter equipment name";
                                  }
                                },
                              ),
                              textFieldText("Equipment Category"),
                              AEMPLPopUpButton(
                                value: _selectedCategory == null
                                    ? null
                                    : _selectedCategory!.name,
                                hintText: "Select Equipment category",
                                prefix: const AEMPLIcon(AEMPLIcons.category,
                                    size: 20),
                                onPressed: () {
                                  context
                                      .read<CategoriesCubit>()
                                      .fetchCategories();
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                            constraints: const BoxConstraints(
                                                maxWidth: 500),
                                            child: BlocBuilder<CategoriesCubit,
                                                    CategoriesModel>(
                                                builder: (ctx, state) {
                                              return ListView.builder(
                                                shrinkWrap: true,
                                                itemCount:
                                                    state.categories.length,
                                                itemBuilder:
                                                    (BuildContext context,
                                                        int index) {
                                                  return ListTile(
                                                    leading: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              6),
                                                      child: CachedNetworkImage(
                                                        imageUrl: state
                                                            .categories[index]
                                                            .image,
                                                        width: 60,
                                                        height: 60,
                                                        fit: BoxFit.cover,
                                                        placeholder: (context,
                                                                url) =>
                                                            const Center(
                                                                child:
                                                                    CupertinoActivityIndicator()),
                                                        errorWidget: (_, __,
                                                                ___) =>
                                                            Image.asset(
                                                                "assets/images/placeholder.png"),
                                                      ),
                                                    ),
                                                    title: Text(state
                                                        .categories[index]
                                                        .name),
                                                    subtitle: Text(
                                                      state.categories[index]
                                                          .description,
                                                      maxLines: 1,
                                                    ),
                                                    onTap: () {
                                                      setState(() =>
                                                          _selectedCategory =
                                                              state.categories[
                                                                  index]);
                                                      Navigator.pop(ctx);
                                                    },
                                                  );
                                                },
                                              );
                                            }),
                                          ),
                                        );
                                      });
                                },
                              ),
                            ],
                          ))),
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
                          textFieldText("Dimension"),
                          AEMPLTextField(
                            controller: controllers[1],
                            hintText: "Dimension",
                            prefix:
                                const AEMPLIcon(AEMPLIcons.dimension, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter dimension";
                              }
                            },
                          ),
                          textFieldText("Weight"),
                          AEMPLTextField(
                            controller: controllers[2],
                            hintText: "Weight",
                            prefix:
                                const AEMPLIcon(AEMPLIcons.weight, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) return "Please enter weight";
                            },
                          ),
                          textFieldText("Location"),
                          AEMPLTextField(
                            controller: controllers[3],
                            hintText: "Location",
                            prefix:
                                const AEMPLIcon(AEMPLIcons.location, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter location";
                              }
                            },
                          ),
                          textFieldText("Hours of renting"),
                          AEMPLTextField(
                            controller: controllers[4],
                            hintText: "Hours of renting",
                            prefix: const AEMPLIcon(AEMPLIcons.hmr, size: 20),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter hours of renting";
                              }
                            },
                          ),
                          textFieldText("Manufacture year"),
                          AEMPLTextField(
                            controller: controllers[5],
                            hintText: "Manufacture year",
                            keyboardType: TextInputType.number,
                            prefix: const AEMPLIcon(AEMPLIcons.state, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter manufactured year";
                              }
                            },
                          ),
                          textFieldText("Count"),
                          AEMPLTextField(
                            controller: controllers[6],
                            hintText: "Count",
                            keyboardType: TextInputType.number,
                            prefix:
                                const AEMPLIcon(AEMPLIcons.numbers, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter available counts";
                              }
                            },
                          ),
                          textFieldText("Price"),
                          AEMPLTextField(
                            controller: controllers[7],
                            hintText: "Price",
                            keyboardType: TextInputType.number,
                            prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) return "Please enter rate";
                            },
                          ),
                          textFieldText("Fuel included price"),
                          AEMPLTextField(
                            controller: controllers[8],
                            hintText: "Fuel included price",
                            keyboardType: TextInputType.number,
                            prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter rate with fuel";
                              }
                            },
                          ),
                          textFieldText("Brand"),
                          AEMPLTextField(
                            controller: controllers[10],
                            hintText: "Brand",
                            prefix: const AEMPLIcon(AEMPLIcons.brand, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter brand";
                              }
                            },
                          ),
                          textFieldText("Capacity"),
                          AEMPLTextField(
                            controller: controllers[11],
                            hintText: "Capacity",
                            prefix:
                                const AEMPLIcon(AEMPLIcons.capacity, size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter capacity";
                              }
                            },
                          ),
                          textFieldText("Application"),
                          AEMPLTextField(
                            controller: controllers[12],
                            hintText: "Application",
                            prefix: const AEMPLIcon(AEMPLIcons.application,
                                size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter application";
                              }
                            },
                          ),
                          CheckboxListTile(
                            value: isVATIncluded,
                            title: const Text("VAT included rates"),
                            onChanged: (value) =>
                                setState(() => isVATIncluded = value!),
                          ),
                          textFieldText("Description"),
                          AEMPLTextField(
                            controller: controllers[9],
                            hintText: "Description",
                            maxLines: 4,
                            prefix: const AEMPLIcon(AEMPLIcons.description,
                                size: 20),
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Please enter description";
                              }
                            },
                          ),
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
                                  if (_selectedCategory == null) {
                                    const snackBar = SnackBar(
                                      content: Text('Please select category'),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                    return;
                                  }
                                  List<AssetEntity> images =
                                      imageKey.currentState!.selectedImages;
                                  if (images.isEmpty) {
                                    scaffoldMessageKey.currentState!
                                        .showSnackBar(const SnackBar(
                                            content: Text("Please add image")));
                                    return;
                                  }
                                  AssetEntity image = images.first;
                                  String imagePath = (await image.file)!.path;
                                  String imageId = image.id;
                                  String price = controllers[7].text;
                                  String fuelprice = controllers[8].text;
                                  equipmentName = equipmentController.text;
                                  if (isVATIncluded) {
                                    price =
                                        (double.parse(price) / 1.13).toString();
                                    fuelprice = (double.parse(fuelprice) / 1.13)
                                        .toString();
                                  }
                                  AddEquipmentModelModel
                                      addEquipmentModelModel =
                                      AddEquipmentModelModel(
                                    imageId: imageId,
                                    image: imagePath,
                                    name: controllers[0].text,
                                    dimension: controllers[1].text,
                                    weight: controllers[2].text,
                                    location: controllers[3].text,
                                    hor: controllers[4].text,
                                    menufacturedYear: controllers[5].text,
                                    counts: controllers[6].text,
                                    price: price,
                                    fuelIncludedRate: fuelprice,
                                    isVATIncluded: isVATIncluded,
                                    description: controllers[9].text,
                                    brand: controllers[10].text,
                                    capacity: controllers[11].text,
                                    application: controllers[12].text,
                                  );
                                  models.add(addEquipmentModelModel);
                                  showCupertinoDialog(
                                    context: context,
                                    builder: (ctx) => CupertinoAlertDialog(
                                      title: const Text(
                                          "Do you want to add another model?"),
                                      actions: [
                                        CupertinoDialogAction(
                                          child: const Text(
                                            "Yes",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                          onPressed: () => _scrollToTop(),
                                        ),
                                        CupertinoDialogAction(
                                          child: const Text(
                                            "No",
                                            style:
                                                TextStyle(color: Colors.green),
                                          ),
                                          onPressed: () {
                                            AddEquipment addEquipment =
                                                AddEquipment(
                                              name: equipmentName,
                                              dimension: "",
                                              weight: "",
                                              category: _selectedCategory!,
                                              description: "",
                                            );
                                            Navigator.of(context).pop();
                                            addEquipment.models = models;
                                            addEquipment
                                                .submitEquipment(context);
                                            for (TextEditingController controller
                                                in controllers) {
                                              controller.clear();
                                            }
                                            imageKey.currentState!
                                                .resetSelection();
                                            // _selectedCategory = null;
                                            setState(() {
                                              _selectedCategory = null;
                                              equipmentController.clear();
                                              isVATIncluded = false;
                                              models = models;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  );
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
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
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

                      String price = models[index].price;
                      String fuelIncludedRate = models[index].fuelIncludedRate;

                      if (models[index].isVATIncluded) {
                        price = (1.13 * double.parse(price)).toString();
                        fuelIncludedRate =
                            (1.13 * double.parse(fuelIncludedRate)).toString();
                      }
                      bool isVatIncluded = models[index].isVATIncluded;
                      controllers[0].text = models[index].name;
                      controllers[1].text = models[index].dimension;
                      controllers[2].text = models[index].weight;
                      controllers[3].text = models[index].location;
                      controllers[4].text = models[index].hor;
                      controllers[5].text = models[index].menufacturedYear;
                      controllers[6].text = models[index].counts;
                      controllers[7].text = price;
                      controllers[8].text = fuelIncludedRate;
                      controllers[9].text = models[index].description;
                      controllers[10].text = models[index].brand;
                      controllers[11].text = models[index].capacity;
                      controllers[12].text = models[index].application;

                      imageKey.currentState!.setImage([image]);
                      models.removeAt(index);
                      setState(() {
                        controllers[13].text = equipmentName;
                        isVATIncluded = isVatIncluded;
                        models = models;
                      });
                    }),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        AddEquipment addEquipment = AddEquipment(
                          name: equipmentController.text,
                          dimension: "",
                          weight: "",
                          category: _selectedCategory!,
                          description: "",
                        );

                        addEquipment.models = models;
                        addEquipment.submitEquipment(context);
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
      ),
    );
  }
}
