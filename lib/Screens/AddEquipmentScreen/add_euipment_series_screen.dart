import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_model.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_model_class.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_series_class.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Widgets/add_series_widgets.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class AddEquipmentSeriesScreen extends StatefulWidget {
  final int equipId;
  final List<Model> modelList;
  const AddEquipmentSeriesScreen({
    Key? key,
    required this.equipId,
    required this.modelList,
  }) : super(key: key);

  @override
  State<AddEquipmentSeriesScreen> createState() =>
      _AddEquipmentSeriesScreenState();
}

class _AddEquipmentSeriesScreenState extends State<AddEquipmentSeriesScreen> {
  late AddEquipmentModel addEquipmentModel;
  late List<AddEquipmentModelModel> models;
  Model? selectedModel;
  int? selectedModelIndex;

  List<Series> series = [];

  @override
  void initState() => super.initState();

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(title: const Text("EQUIPMENT SERIES")),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const TitleBar(title: "Select your Model"),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: const Color(0xffDDDDDD)),
                    ),
                    child: InkWell(
                      splashColor: Theme.of(context).primaryColor,
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) {
                            return Dialog(
                              child: ListView.builder(
                                itemCount: widget.modelList.length,
                                shrinkWrap: true,
                                itemBuilder: (context, index) => ListTile(
                                  onTap: () {
                                    setState(() {
                                      selectedModel = widget.modelList[index];
                                    });
                                    selectedModelIndex = index;
                                    Navigator.pop(ctx);
                                  },
                                  title: Text(widget.modelList[index].name),
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                        child: Row(
                          children: [
                            const AEMPLIcon(AEMPLIcons.model),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                selectedModel == null
                                    ? "Select your model"
                                    : selectedModel!.name,
                                style:
                                    const TextStyle(color: Color(0xff292929)),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const AEMPLIcon(
                              AEMPLIcons.drop,
                              color: Color(0xffB4B4B4),
                              size: 16,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Visibility(
                visible: selectedModel != null,
                child: AddSeriesBox(
                  equip: widget.equipId,
                  modelName: selectedModel == null ? "" : selectedModel!.name,
                  model: selectedModel == null ? 0 : selectedModel!.id,
                  series: (series.map((e) {
                    if (e.model == selectedModel!.id) {
                      return e;
                    }
                  }).toList()),
                  onSeriesAdd: (serie) {
                    series.add(serie);
                    setState(() => series);
                  },
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: TextButton(
          onPressed: () async {
            AddSeries addSeries = AddSeries(series);
            addSeries.submit(context, widget.equipId);
          },
          child: const Text("Next"),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }
}
