// ignore_for_file: implementation_imports, body_might_complete_normally_nullable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Blocs/category_bloc.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';

showEquipmentDetailEditPopup(
  BuildContext context, {
  required int id,
  required String name,
  required String category,
  required String dimension,
  required String weight,
}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) {
      return EditDetailBox(
        id: id,
        name: name,
        category: category,
        dimension: dimension,
        weight: weight,
        ctx: ctx,
      );
    },
  );
}

class EditDetailBox extends StatefulWidget {
  final BuildContext ctx;
  final String name, category, dimension, weight;
  final int id;

  const EditDetailBox({
    Key? key,
    required this.ctx,
    required this.id,
    required this.name,
    required this.category,
    required this.dimension,
    required this.weight,
  }) : super(key: key);
  @override
  State<EditDetailBox> createState() => _EditDetailBoxState();
}

class _EditDetailBoxState extends State<EditDetailBox> {
  late final List<TextEditingController> controllers;

  final formKey = GlobalKey<FormState>();
  Category? _selectedCategory;

  @override
  void initState() {
    context.read<CategoriesCubit>().fetchCategories();
    controllers = List.generate(5, (index) {
      if (index == 0) {
        return TextEditingController(text: widget.name);
      } else if (index == 1) {
        return TextEditingController(text: widget.category);
      } else if (index == 2) {
        return TextEditingController(text: widget.dimension);
      } else if (index == 3) {
        return TextEditingController(text: widget.weight);
      } else {
        return TextEditingController(text: "");
      }
    });
    getCategory(widget.category);
    super.initState();
  }

  getCategory(String cat) {
    context.read<CategoriesCubit>().state.categories.forEach((element) {
      if (widget.category == element.name) {
        setState(() {
          _selectedCategory = element;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showCupertinoDialog(
                  context: context,
                  builder: (cnt) => CupertinoAlertDialog(
                        title: const Text("Any changes will be discard"),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text(
                              "Discard",
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pop(cnt);
                              Navigator.pop(context);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text(
                              "Cancel",
                              style: TextStyle(color: Colors.green),
                            ),
                            onPressed: () {
                              Navigator.pop(cnt);
                            },
                          ),
                        ],
                      ));
            },
          ),
          title: Text(
            "Edit detail".toUpperCase(),
          ),
        ),
        body: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Container(
                alignment: Alignment.topCenter,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: ListView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      textFieldText("Equipment Name"),
                      AEMPLTextField(
                        controller: controllers[0],
                        hintText: "Equipment name",
                        prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
                        validator: (value) {
                          if (value!.isEmpty) return "Please enter name";
                        },
                      ),
                      textFieldText("Equipment Category"),
                      AEMPLPopUpButton(
                        value: _selectedCategory == null
                            ? null
                            : _selectedCategory!.name,
                        hintText: "Select Equipment category",
                        prefix: const AEMPLIcon(AEMPLIcons.category, size: 20),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: BlocBuilder<CategoriesCubit,
                                      CategoriesModel>(builder: (ctx, state) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: state.categories.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return ListTile(
                                          leading: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  state.categories[index].image,
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const Center(
                                                      child:
                                                          CupertinoActivityIndicator()),
                                              errorWidget: (_, __, ___) =>
                                                  Image.asset(
                                                      "assets/images/placeholder.png"),
                                            ),
                                          ),
                                          title: Text(
                                              state.categories[index].name),
                                          subtitle: Text(
                                            state.categories[index].description,
                                            maxLines: 1,
                                          ),
                                          onTap: () {
                                            setState(() => _selectedCategory =
                                                state.categories[index]);
                                            Navigator.pop(ctx);
                                          },
                                        );
                                      },
                                    );
                                  }),
                                );
                              });
                        },
                      ),
                      textFieldText("Equipment Dimension and Weight"),
                      Row(
                        children: [
                          const SizedBox(width: 16),
                          Expanded(
                            child: AEMPLTextField(
                              margin: 0,
                              controller: controllers[2],
                              hintText: "Dimension",
                              prefix: const AEMPLIcon(AEMPLIcons.dimension,
                                  size: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter dimension";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: AEMPLTextField(
                              margin: 0,
                              controller: controllers[3],
                              hintText: "Weight",
                              prefix:
                                  const AEMPLIcon(AEMPLIcons.weight, size: 20),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Please enter weight";
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                      ),
                      // textFieldText("Equipment Description"),
                      // AEMPLTextField(
                      //   controller: controllers[4],
                      //   hintText: "Equipment description",
                      //   keyboardType: TextInputType.multiline,
                      //   maxLines: 6,
                      //   prefix: const AEMPLIcon(AEMPLIcons.description, size: 20),
                      //   validator: (value) {
                      //     if (value!.isEmpty) return "Please enter detail";
                      //   },
                      // ),
                      const SizedBox(height: 60),
                      Center(
                        child: TextButton(
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              if (_selectedCategory == null) {
                                const snackBar = SnackBar(
                                    content: Text('Please select category'));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              } else {
                                EquipmentDetailModel equipmentDetailModel =
                                    EquipmentDetailModel();
                                equipmentDetailModel.setUpdate(
                                  equipId: widget.id,
                                  categoryId: _selectedCategory!.id,
                                  name: controllers[0].text,
                                  dimension: controllers[2].text,
                                  weight: controllers[3].text,
                                );
                                if (await equipmentDetailModel
                                    .updateDetail(context)) {
                                  EquipmentDetailModel equipmentDetailModel =
                                      EquipmentDetailModel();
                                  await equipmentDetailModel
                                      .fetchEquipmentDetail(context, widget.id);
                                  Navigator.pop(widget.ctx);
                                }
                              }
                            }
                          },
                          child: const Text("Update"),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
