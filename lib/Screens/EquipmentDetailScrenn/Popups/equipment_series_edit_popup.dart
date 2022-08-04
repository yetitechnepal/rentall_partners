// // ignore_for_file: body_might_complete_normally_nullable

// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
// import 'package:rental_partners/Singletons/api_call.dart';
// import 'package:rental_partners/Theme/date_picker_theme.dart';
// import 'package:rental_partners/Utils/image_icon.dart';
// import 'package:rental_partners/Utils/loading_widget.dart';
// import 'package:rental_partners/Utils/text_field.dart';
// import 'package:rental_partners/main.dart';

// class EditSeries {
//   final int id;
//   final String name, description, hourOfRun, dateOfManufacture, location;

//   EditSeries({
//     required this.id,
//     required this.name,
//     required this.description,
//     required this.hourOfRun,
//     required this.dateOfManufacture,
//     required this.location,
//   });
//   update(BuildContext context) async {
//     context.loaderOverlay.show();
//     Response response =
//         await API().patch(endPoint: "equipment/series/$id/", data: {
//       "series": name,
//       "description": description,
//       "hour_of_renting": hourOfRun,
//       "manufactured_year": dateOfManufacture,
//       "location": location,
//     });
//     context.loaderOverlay.hide();
//     scaffoldMessageKey.currentState!.clearSnackBars();
//     scaffoldMessageKey.currentState!
//         .showSnackBar(SnackBar(content: Text(response.data['message'])));
//     if (response.statusCode == 200) {
//       return true;
//     } else {
//       return false;
//     }
//   }
// }

// showEquipmentSeriesEditPopup(
//   BuildContext context,
//   EquipmentSeriesModel series,
//   int id,
// ) {
//   showGeneralDialog(
//       context: context,
//       pageBuilder: (ctx, a, aa) {
//         return _EquipmentSeriesEditBox(series: series, id: id);
//       });
// }

// class _EquipmentSeriesEditBox extends StatefulWidget {
//   final EquipmentSeriesModel series;
//   final int id;

//   const _EquipmentSeriesEditBox({
//     Key? key,
//     required this.series,
//     required this.id,
//   }) : super(key: key);
//   @override
//   State<_EquipmentSeriesEditBox> createState() =>
//       _EquipmentSeriesEditBoxState();
// }

// class _EquipmentSeriesEditBoxState extends State<_EquipmentSeriesEditBox> {
//   late final List<TextEditingController> controllers;
//   final formKey = GlobalKey<FormState>();

//   DateTime? manufaturedDate;

//   @override
//   void initState() {
//     controllers = List.generate(5, (index) {
//       if (index == 0) {
//         return TextEditingController(text: widget.series.name);
//       } else if (index == 1) {
//         return TextEditingController(text: widget.series.description);
//       } else if (index == 2) {
//         return TextEditingController(text: widget.series.hor);
//       } else if (index == 3) {
//         return TextEditingController(text: widget.series.dom);
//       } else {
//         return TextEditingController(text: widget.series.location);
//       }
//     });
//     manufaturedDate = DateTime.tryParse(widget.series.dom);
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return LoaderOverlay(
//       useDefaultLoading: false,
//       overlayWidget: loader(context),
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text("Edit Series".toUpperCase()),
//           leading: IconButton(
//             icon: const Icon(Icons.close),
//             onPressed: () {
//               showCupertinoDialog(
//                 context: context,
//                 builder: (cnt) => CupertinoAlertDialog(
//                   title: const Text("Any changes will be discard"),
//                   actions: [
//                     CupertinoDialogAction(
//                       child: const Text(
//                         "Discard",
//                         style: TextStyle(
//                           color: Colors.red,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(cnt);
//                         Navigator.pop(context);
//                       },
//                     ),
//                     CupertinoDialogAction(
//                       child: const Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.green),
//                       ),
//                       onPressed: () {
//                         Navigator.pop(cnt);
//                       },
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//         body: Form(
//           key: formKey,
//           child: SingleChildScrollView(
//             child: Center(
//               child: Container(
//                 constraints: const BoxConstraints(maxWidth: 500),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     textFieldText("Series Name"),
//                     AEMPLTextField(
//                       controller: controllers[0],
//                       hintText: "Series name",
//                       prefix: const AEMPLIcon(AEMPLIcons.attachment, size: 20),
//                       validator: (value) {
//                         if (value!.isEmpty) return "Please enter series name";
//                       },
//                     ),
//                     textFieldText("Series Description"),
//                     AEMPLTextField(
//                       controller: controllers[1],
//                       hintText: "Series description",
//                       keyboardType: TextInputType.multiline,
//                       maxLines: 6,
//                       prefix: const AEMPLIcon(AEMPLIcons.description, size: 20),
//                       validator: (value) {
//                         if (value!.isEmpty) return "Please enter series detail";
//                       },
//                     ),
//                     textFieldText("Year of Manufacture"),
//                     AEMPLPopUpButton(
//                       hintText: "Select Year",
//                       prefix: const Icon(Icons.calendar_today_sharp),
//                       value: manufaturedDate == null
//                           ? null
//                           : DateFormat("MMM dd, yyyy").format(manufaturedDate!),
//                       onPressed: () async {
//                         DateTime? selectedDate = await showDatePicker(
//                           context: context,
//                           initialDate: DateTime.now(),
//                           firstDate: DateTime.now()
//                               .subtract(const Duration(days: 365 * 100)),
//                           lastDate: DateTime.now(),
//                           builder: (context, child) {
//                             return Theme(
//                               data: datePickerTheme(context),
//                               child: child!,
//                             );
//                           },
//                         );
//                         setState(() => manufaturedDate = selectedDate);
//                       },
//                     ),
//                     textFieldText("Hour of Renting"),
//                     AEMPLTextField(
//                       controller: controllers[2],
//                       hintText: "Hour of renting",
//                       prefix: const Icon(Icons.lock_clock_outlined, size: 20),
//                       validator: (value) {
//                         if (value!.isEmpty)
//                           return "Please enter hours of renting";
//                       },
//                     ),
//                     textFieldText("Series Location"),
//                     AEMPLTextField(
//                       controller: controllers[4],
//                       hintText: "Series location",
//                       prefix: const AEMPLIcon(AEMPLIcons.location, size: 20),
//                       validator: (value) {
//                         if (value!.isEmpty)
//                           return "Please enter series location";
//                       },
//                     ),
//                     const SizedBox(height: 10),
//                     Center(
//                       child: TextButton(
//                         onPressed: () async {
//                           if (formKey.currentState!.validate()) {
//                             if (manufaturedDate == null) {
//                               scaffoldMessageKey.currentState!.showSnackBar(
//                                   const SnackBar(
//                                       content: Text(
//                                           "Please choose date of manufacture")));
//                             } else {
//                               EditSeries editSeries = EditSeries(
//                                 id: widget.series.id,
//                                 dateOfManufacture: DateFormat("yyyy-MM-dd")
//                                     .format(manufaturedDate!),
//                                 description: controllers[1].text,
//                                 hourOfRun: controllers[2].text,
//                                 location: controllers[4].text,
//                                 name: controllers[0].text,
//                               );
//                               if (await editSeries.update(context)) {
//                                 EquipmentDetailModel equipmentDetailModel =
//                                     EquipmentDetailModel();
//                                 await equipmentDetailModel.fetchEquipmentDetail(
//                                   context,
//                                   widget.id,
//                                 );
//                                 Navigator.pop(context);
//                               }
//                             }
//                           }
//                         },
//                         child: const Text("Update Series"),
//                       ),
//                     ),
//                     const SizedBox(height: 20),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
