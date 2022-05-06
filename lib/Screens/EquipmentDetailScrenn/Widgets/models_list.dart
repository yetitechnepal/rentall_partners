import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/equipment_model_edit.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Popups/equipment_series_edit_popup.dart';
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
  List<EquipmentSeriesModel> series = [];

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
          series = model.series;
          setState(() => _selectedModel = model);
          setState(() => series);
        }
      }
    } else {
      if (widget.models.isNotEmpty) {
        _selectedModel = widget.models.first;
        series = _selectedModel!.series;
        setState(() => series);
      }
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: TitleBar(title: 'Models'),
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
        Visibility(
          visible: selected,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: TitleBar(title: 'Series'),
              ),
              SizedBox(
                height: 160,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 10),
                  scrollDirection: Axis.horizontal,
                  itemCount: series.length,
                  itemBuilder: (context, index) => serieBox(
                    context,
                    serie: series[index],
                  ),
                  separatorBuilder: (BuildContext context, int index) =>
                      const SizedBox(width: 12),
                ),
              ),
            ],
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
        boxShadow: isSelected
            ? BoxShadows.selectedDropShadow(context)
            : BoxShadows.dropShadow(context),
      ),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 13),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedNetworkImage(
                        imageUrl: model.image,
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                        placeholder: (context, url) =>
                            const Center(child: CupertinoActivityIndicator()),
                        errorWidget: (context, url, error) =>
                            const Center(child: Icon(Icons.error)),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 10,
                  ),
                  child: Text(
                    model.name,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
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
            onPressed: () {
              series = model.series;
              setState(() => _selectedModel = model);
              setState(() => series);
              setState(() => selected = true);
            },
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
                    id: model.id,
                    image: model.image,
                    name: model.name,
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

  Widget serieBox(BuildContext context, {required EquipmentSeriesModel serie}) {
    return Container(
      width: 200,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  serie.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.transparent,
                  child: IconButton(
                    onPressed: () {
                      showEquipmentSeriesEditPopup(context, serie, widget.id);
                    },
                    iconSize: 12,
                    visualDensity: VisualDensity.compact,
                    icon: Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 8,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "Base Price",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
              const Spacer(),
              Text(
                serie.price,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Text(
                "With Fuel",
                style: TextStyle(fontWeight: FontWeight.w900, fontSize: 10),
              ),
              const Spacer(),
              Text(
                serie.fuelIncludedRate,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 10,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
