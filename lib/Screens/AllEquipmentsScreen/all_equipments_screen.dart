import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AddEquipmentScreen/add_equipment_screen.dart';
import 'package:rental_partners/Screens/AllEquipmentsScreen/Models/all_equipments_model.dart';
import 'package:rental_partners/Screens/AllEquipmentsScreen/Widgets/equipment_grid_box.dart';

// ignore: must_be_immutable
class AllEquipmentsScreen extends StatelessWidget {
  AllEquipmentsScreen({Key? key}) : super(key: key);
  final AllEquipmentModel _allEquipmentModel = AllEquipmentModel();

  String keyWord = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Equipments".toUpperCase()),
      ),
      body: FutureBuilder<AllEquipmentModel>(
        future: _allEquipmentModel.fetchAllEquipments(),
        builder: (context, asyncsnapshot) {
          if (asyncsnapshot.hasData) {
            return EquipmentGridBox(asyncsnapshot: asyncsnapshot);
          } else if (asyncsnapshot.hasError) {
            return kDebugMode
                ? Center(child: Text(asyncsnapshot.error.toString()))
                : const SizedBox();
          } else {
            return const Center(child: CupertinoActivityIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AddEquipmentScreen()),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
