import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Widgets/detail_box.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Widgets/image_display_slider.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Widgets/linked_attachment_grid.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Widgets/models_list.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Widgets/review_list.dart';

class EquipmentDetailScreen extends StatelessWidget {
  final int id;
  EquipmentDetailScreen({Key? key, this.id = 23}) : super(key: key);

  final EquipmentDetailModel _equipmentDetailModel = EquipmentDetailModel();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Equipment".toUpperCase())),
      body: FutureBuilder<EquipmentDetailModel>(
          future: _equipmentDetailModel.fetchEquipmentDetail(context, id),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return BlocBuilder<EquipmentDetailModelCubit,
                  EquipmentDetailModel>(builder: (context, state) {
                return ListView(
                  children: [
                    const SizedBox(height: 10),
                    ImageDisplaySlider(
                      images: state.images,
                      equipId: id,
                    ),
                    EquipmentDetailBox(
                      equipId: id,
                      name: state.name,
                      dimension: state.dimension,
                      weight: state.weight,
                      category: state.category,
                      isVerified: state.isVerified,
                    ),
                    ModelGrid(
                      models: state.models,
                      id: id,
                    ),
                    LinkedAttachmentSection(
                      attachments: state.attachments,
                      equipId: id,
                    ),
                    ReviewList(id: id),
                  ],
                );
              });
            } else if (asyncSnapshot.hasError) {
              if (kDebugMode) {
                return Center(
                  child: Text(asyncSnapshot.error.toString()),
                );
              } else {
                return const SizedBox();
              }
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          }),
    );
  }
}
