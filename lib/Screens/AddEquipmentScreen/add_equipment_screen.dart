// // ignore_for_file: body_might_complete_normally_nullable

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:loader_overlay/loader_overlay.dart';
// import 'package:rental_partners/Blocs/category_bloc.dart';
// import 'package:rental_partners/Screens/AddEquipmentScreen/Model/add_equipment_class.dart';
// import 'package:rental_partners/Utils/image_icon.dart';
// import 'package:rental_partners/Utils/loading_widget.dart';
// import 'package:rental_partners/Utils/text_field.dart';

// import 'add_equipment_model_screen.dart';

// class AddEquipmentScreen extends StatefulWidget {
//   const AddEquipmentScreen({Key? key}) : super(key: key);

//   @override
//   State<AddEquipmentScreen> createState() => _AddEquipmentScreenState();
// }

// class _AddEquipmentScreenState extends State<AddEquipmentScreen> {
//   final controllers = List.generate(5, (index) => TextEditingController());

//   final formKey = GlobalKey<FormState>();

//   Category? _selectedCategory;

//   @override
//   Widget build(BuildContext context) {
//     context.read<CategoriesCubit>().fetchCategories();
//     return LoaderOverlay(
//       useDefaultLoading: false,
//       overlayWidget: loader(context),
//       child: Scaffold(
//         appBar: AppBar(title: Text("Add Equipment".toUpperCase())),
//         body: GestureDetector(
//           onTap: () => FocusScope.of(context).unfocus(),
//           child: SingleChildScrollView(
//             child: Form(
//               key: formKey,
//               child: Container(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//                   constraints: const BoxConstraints(maxWidth: 500),
//                   child: ListView(
//                     shrinkWrap: true,
//                     physics: const NeverScrollableScrollPhysics(),
//                     children: [
//                       textFieldText("Equipment Name"),
//                       AEMPLTextField(
//                         controller: controllers[0],
//                         hintText: "Equipment name",
//                         prefix: const AEMPLIcon(AEMPLIcons.equipment, size: 20),
//                         validator: (value) {
//                           if (value!.isEmpty) return "Please enter name";
//                         },
//                       ),
//                       textFieldText("Equipment Category"),
//                       AEMPLPopUpButton(
//                         value: _selectedCategory == null
//                             ? null
//                             : _selectedCategory!.name,
//                         hintText: "Select Equipment category",
//                         prefix: const AEMPLIcon(AEMPLIcons.category, size: 20),
//                         onPressed: () {
//                           showDialog(
//                               context: context,
//                               builder: (context) {
//                                 return Dialog(
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(10),
//                                   ),
//                                   child: Container(
//                                     constraints:
//                                         const BoxConstraints(maxWidth: 500),
//                                     child: BlocBuilder<CategoriesCubit,
//                                         CategoriesModel>(builder: (ctx, state) {
//                                       return ListView.builder(
//                                         shrinkWrap: true,
//                                         itemCount: state.categories.length,
//                                         itemBuilder:
//                                             (BuildContext context, int index) {
//                                           return ListTile(
//                                             leading: ClipRRect(
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                               child: CachedNetworkImage(
//                                                 imageUrl: state
//                                                     .categories[index].image,
//                                                 width: 60,
//                                                 height: 60,
//                                                 fit: BoxFit.cover,
//                                                 placeholder: (context, url) =>
//                                                     const Center(
//                                                         child:
//                                                             CupertinoActivityIndicator()),
//                                                 errorWidget: (_, __, ___) =>
//                                                     Image.asset(
//                                                         "assets/images/placeholder.png"),
//                                               ),
//                                             ),
//                                             title: Text(
//                                                 state.categories[index].name),
//                                             subtitle: Text(
//                                               state.categories[index]
//                                                   .description,
//                                               maxLines: 1,
//                                             ),
//                                             onTap: () {
//                                               setState(() => _selectedCategory =
//                                                   state.categories[index]);
//                                               Navigator.pop(ctx);
//                                             },
//                                           );
//                                         },
//                                       );
//                                     }),
//                                   ),
//                                 );
//                               });
//                         },
//                       ),
//                       const SizedBox(height: 60),
//                       Center(
//                         child: TextButton(
//                           onPressed: () async {
//                             if (formKey.currentState!.validate()) {
//                               if (_selectedCategory == null) {
//                                 const snackBar = SnackBar(
//                                   content: Text('Please select category'),
//                                 );

//                                 ScaffoldMessenger.of(context)
//                                     .showSnackBar(snackBar);
//                               } else {
//                                 AddEquipment addEquipment = AddEquipment(
//                                   name: controllers[0].text,
//                                   dimension: "",
//                                   weight: "",
//                                   category: _selectedCategory!,
//                                   description: "",
//                                 );
//                                 Navigator.push(
//                                   context,
//                                   MaterialPageRoute(
//                                     builder: (context) =>
//                                         const AddEquipmentModelScreen(),
//                                   ),
//                                 );
//                               }
//                             }
//                           },
//                           child: const Text("Next"),
//                         ),
//                       ),
//                       const SizedBox(height: 60),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
