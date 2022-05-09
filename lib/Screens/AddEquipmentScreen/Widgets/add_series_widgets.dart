// ignore_for_file: body_might_complete_normally_nullable

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_model_class.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/date_picker_theme.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/Widgets/title_box.dart';

class AddSeriesBox extends StatefulWidget {
  final int model, equip;
  final String modelName;
  final List<Series?> series;
  final Function(Series)? onSeriesAdd;

  const AddSeriesBox(
      {Key? key,
      required this.model,
      required this.modelName,
      required this.equip,
      required this.series,
      this.onSeriesAdd})
      : super(key: key);
  @override
  State<AddSeriesBox> createState() => _AddSeriesBoxState();
}

class _AddSeriesBoxState extends State<AddSeriesBox> {
  get primaryColor => null;

  @override
  Widget build(BuildContext context) {
    int counts = widget.series.length;
    return GridView.builder(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16)
          .copyWith(bottom: 40),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 150,
        childAspectRatio: 1,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemCount: counts + 1,
      itemBuilder: (context, index) {
        if (index == counts) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
              boxShadow: BoxShadows.dropShadow(context),
            ),
            child: TextButton(
              onPressed: () => showDialogAddSeries(context, widget.equip,
                  widget.model, widget.modelName, widget.onSeriesAdd),
              style: TextButtonStyles.overlayButtonStyle(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AEMPLIcon(
                    AEMPLIcons.add,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Add Series",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: BoxShadows.dropShadow(context),
          ),
          child: TextButton(
            onPressed: () {},
            style: TextButtonStyles.overlayButtonStyle().copyWith(
              foregroundColor: MaterialStateProperty.all(Colors.black),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.series[index]!.modelName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.series[index]!.seriesName,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Rs " + widget.series[index]!.price,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

showDialogAddSeries(BuildContext context, int equip, int modelId,
    String modelName, Function(Series)? onSeriesAdd) {
  showDialog(
      context: context,
      barrierColor: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.6),
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: AddSeriesPopupBox(
              equip: equip,
              modelId: modelId,
              modelName: modelName,
              onSeriesAdd: (series) {
                onSeriesAdd!(series);
                Navigator.pop(ctx);
              },
            ),
          ),
        );
      });
}

class AddSeriesPopupBox extends StatefulWidget {
  final Function(Series)? onSeriesAdd;
  final int equip, modelId;
  final String modelName;

  const AddSeriesPopupBox(
      {Key? key,
      required this.equip,
      required this.modelId,
      required this.modelName,
      this.onSeriesAdd})
      : super(key: key);
  @override
  State<AddSeriesPopupBox> createState() => _AddSeriesPopupBoxState();
}

class _AddSeriesPopupBoxState extends State<AddSeriesPopupBox> {
  final controllers = List.generate(7, (index) => TextEditingController());
  final formKey = GlobalKey<FormState>();

  DateTime? manufaturedDate;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: TitleBar(title: "Add Series"),
            ),
            textFieldText("Series Name"),
            AEMPLTextField(
              controller: controllers[0],
              hintText: "Series name",
              keyboardType: TextInputType.text,
              prefix: const AEMPLIcon(AEMPLIcons.attachment, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter series name";
              },
            ),
            textFieldText("Date of Manufacture"),
            AEMPLPopUpButton(
              hintText: "Select Date",
              prefix: const Icon(Icons.calendar_today_outlined),
              value: manufaturedDate == null
                  ? null
                  : DateFormat("MMM dd, yyyy").format(manufaturedDate!),
              onPressed: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate:
                      DateTime.now().subtract(const Duration(days: 365 * 100)),
                  lastDate: DateTime.now(),
                  builder: (context, child) {
                    return Theme(
                      data: datePickerTheme(context),
                      child: child!,
                    );
                  },
                );
                setState(() => manufaturedDate = selectedDate);
              },
            ),
            textFieldText("Hour of Renting"),
            AEMPLTextField(
              controller: controllers[1],
              hintText: "Hour of renting",
              keyboardType: TextInputType.text,
              prefix: const Icon(Icons.lock_clock_outlined, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter hours of renting";
              },
            ),
            textFieldText("Series Location"),
            AEMPLTextField(
              controller: controllers[2],
              hintText: "Series location",
              keyboardType: TextInputType.text,
              prefix: const AEMPLIcon(AEMPLIcons.location, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter series location";
              },
            ),
            textFieldText("Frequency"),
            AEMPLTextField(
              controller: controllers[3],
              hintText: "Frequency",
              keyboardType: TextInputType.number,
              prefix: const AEMPLIcon(AEMPLIcons.numbers, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter frequency";
              },
            ),
            textFieldText("Base Rate per hour"),
            AEMPLTextField(
              controller: controllers[4],
              hintText: "Base rate",
              keyboardType: TextInputType.number,
              prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter base rate";
              },
            ),
            textFieldText("Feul Included Rate per hour"),
            AEMPLTextField(
              controller: controllers[5],
              hintText: "Feul included rate",
              keyboardType: TextInputType.number,
              prefix: const AEMPLIcon(AEMPLIcons.price, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter feul inclusion rate";
              },
            ),
            textFieldText("Series Description"),
            AEMPLTextField(
              controller: controllers[6],
              hintText: "Series description",
              keyboardType: TextInputType.text,
              maxLines: 6,
              textInputAction: TextInputAction.done,
              prefix: const AEMPLIcon(AEMPLIcons.description, size: 20),
              validator: (value) {
                if (value!.isEmpty) return "Please enter series detail";
              },
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    Series seriesModel = Series(
                      seriesName: controllers[0].text,
                      hourOfRenting: controllers[1].text,
                      location: controllers[2].text,
                      count: controllers[3].text,
                      price: controllers[4].text,
                      fuelIncludedRate: controllers[5].text,
                      description: controllers[6].text,
                      equipment: widget.equip,
                      model: widget.modelId,
                      modelName: widget.modelName,
                      menufatureDate:
                          DateFormat("yyyy-MM-dd").format(manufaturedDate!),
                    );
                    widget.onSeriesAdd!(seriesModel);
                  }
                },
                child: const Text("Add Series"),
              ),
            ),
            const SizedBox(height: 0),
          ],
        ),
      ),
    );
  }
}
