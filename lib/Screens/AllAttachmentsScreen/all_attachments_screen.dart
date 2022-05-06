import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/AddAtttachmentScreen/add_attachment_screen.dart';
import 'package:rental_partners/Screens/AllAttachmentsScreen/Model/all_equipment_model.dart';
import 'package:rental_partners/Widgets/attachment_box.dart';

class AllAttachmentsScreen extends StatelessWidget {
  AllAttachmentsScreen({Key? key}) : super(key: key);
  final AllAttachmentsModel _allAttachmentsModel = AllAttachmentsModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Attachments".toUpperCase())),
      body: FutureBuilder<AllAttachmentsModel>(
          future: _allAttachmentsModel.fetchAllAttractions(),
          builder: (context, asyncSnapshot) {
            if (asyncSnapshot.hasData) {
              return GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 140 / 114,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: asyncSnapshot.data!.attactions.length,
                itemBuilder: (context, index) => attachmentBox(
                  context,
                  attachmentModel: asyncSnapshot.data!.attactions[index],
                ),
              );
            } else if (asyncSnapshot.hasError) {
              if (kDebugMode) {
                return Center(child: Text(asyncSnapshot.error.toString()));
              } else {
                return const SizedBox();
              }
            } else {
              return const Center(child: CupertinoActivityIndicator());
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AddAttachmentScreen(),
          ),
        ),
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.add),
      ),
    );
  }
}
