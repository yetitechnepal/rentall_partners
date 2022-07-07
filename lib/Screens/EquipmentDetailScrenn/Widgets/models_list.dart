import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/equipment_model_edit.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/model_detail_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class ModelGrid extends StatefulWidget {
  final List<EquipmentModelModel> models;
  final int id;
  const ModelGrid({
    Key? key,
    required this.models,
    required this.id,
  }) : super(key: key);

  @override
  State<ModelGrid> createState() => _ModelGridState();
}

class _ModelGridState extends State<ModelGrid> {
  EquipmentModelModel? _selectedModel;

  bool selected = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (_selectedModel != null) {
      for (var model in widget.models) {
        if (_selectedModel!.id == model.id) {
          _selectedModel = model;
          setState(() => _selectedModel = model);
        }
      }
    } else {
      if (widget.models.isNotEmpty) {
        _selectedModel = widget.models.first;
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleBar(
            title: 'Models',
            suffix: IconButton(
              padding: EdgeInsets.zero,
              visualDensity: VisualDensity.compact,
              onPressed: () =>
                  showEquipmentModelEditPopup(context, equipId: widget.id),
              icon: Icon(
                Icons.add,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            scrollDirection: Axis.horizontal,
            itemCount: widget.models.length,
            itemBuilder: (context, index) => modelBox(
              context,
              model: widget.models[index],
              isSelected: _selectedModel == widget.models[index],
            ),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(width: 12),
          ),
        ),
      ],
    );
  }

  Widget modelBox(BuildContext context,
      {required EquipmentModelModel model, bool isSelected = false}) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: model.image,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (_, __, ___) =>
                        Image.asset("assets/images/placeholder.png"),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    Text(
                      model.name,
                      maxLines: 1,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            style: TextButtonStyles.overlayButtonStyle().copyWith(
              minimumSize: MaterialStateProperty.all(Size.infinite),
              shape: MaterialStateProperty.all(
                const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10),
                  ),
                ),
              ),
            ),
            onPressed: () => showModelDetailPopup(context, model: model),
            child: const SizedBox(),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Material(
                borderRadius: BorderRadius.circular(100),
                elevation: 0,
                color: Colors.transparent,
                child: IconButton(
                  iconSize: 20,
                  padding: EdgeInsets.zero,
                  visualDensity: VisualDensity.compact,
                  onPressed: () => showEquipmentModelEditPopup(
                    context,
                    model: model,
                    equipId: widget.id,
                  ),
                  icon: Text(
                    "Edit",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
