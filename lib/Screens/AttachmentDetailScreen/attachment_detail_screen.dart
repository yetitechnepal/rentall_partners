import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Widgets/attachment_detail_box.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Widgets/attachment_gallery_box.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Widgets/attachment_linked_equipment_box.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Widgets/attachment_rate_box.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Widgets/attachment_review_box.dart';

class AttachmentDetailScreen extends StatelessWidget {
  final int id;
  AttachmentDetailScreen({Key? key, this.id = 1}) : super(key: key);

  final AttachmentDetailsModel _attachmentDetailsModel =
      AttachmentDetailsModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attachment".toUpperCase()),
      ),
      body: FutureBuilder<AttachmentDetailsModel>(
          future: _attachmentDetailsModel.fetchAttachmentDetails(context, id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CupertinoActivityIndicator());
            } else if (snapshot.hasData) {
              return BlocBuilder<AttachmentDetailsModelCubit,
                  AttachmentDetailsModel>(builder: (context, state) {
                return ListView(
                  children: [
                    const SizedBox(height: 10),
                    AttachmentGalleryBox(
                      id: id,
                      images: state.attachmentImagesModel,
                    ),
                    AttachmentDetailBox(
                      id: id,
                      detail: state.attachmentDetailModel,
                    ),
                    AttachmentRateBox(rate: state.attachmentRateModel),
                    AttachmentLinkedEquipmentBox(
                      equipmentLinked: state.attachmentLinkedEquipments,
                      id: id,
                    ),
                    AttachmentReviewBox(id: id),
                  ],
                );
              });
            } else if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}
