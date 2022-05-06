import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_images_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_linked_equipments_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_rate_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/atttachment_detail_model.dart';
import 'package:rental_partners/Singletons/api_call.dart';

class AttachmentDetailsModel {
  late AttachmentDetailModel attachmentDetailModel;
  late AttachmentRateModel attachmentRateModel;
  late AttachmentImagesModel attachmentImagesModel;
  late AttachmentLinkedEquipments attachmentLinkedEquipments;

  Future<AttachmentDetailsModel> fetchAttachmentDetails(
      BuildContext context, int id) async {
    Response response = await API().get(
      endPoint: "equipment/attachment/$id/detail/",
      useToken: false,
    );
    if (response.statusCode == 200) {
      var data = response.data['data'];
      attachmentDetailModel = AttachmentDetailModel.fromMap({
        "name": data['name'],
        "weight": data['weight'],
        "dimension": data['dimension'],
        "hor": data['hor'],
        "dom": data['manufactured_year'],
        "location": data['location'],
        "description": data['description'],
        "isVerified": data['is_verified'],
      });
      attachmentRateModel = AttachmentRateModel.fromMap({
        "baseRate": data['price'],
        "withFuelRate": data['fuel_included_rate']
      });
      attachmentImagesModel =
          AttachmentImagesModel.fromMap({"images": data['gallery']});
      attachmentLinkedEquipments =
          AttachmentLinkedEquipments.fromMap({"equipments": data['equipment']});
    }
    context.read<AttachmentDetailsModelCubit>().setData(this);
    return this;
  }
}

class AttachmentDetailsModelCubit extends Cubit<AttachmentDetailsModel> {
  AttachmentDetailsModelCubit() : super(AttachmentDetailsModel());
  setData(AttachmentDetailsModel details) {
    emit(details);
  }
}
