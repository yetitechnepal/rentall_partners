import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Screens/DocumentsScreen/PopUp/add_document_popup.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_viewer.dart';

class DocumentsScreen extends StatelessWidget {
  const DocumentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DOCUMENTS"),
        actions: [
          IconButton(
            onPressed: () => showAddDocumentPopup(context),
            icon: Icon(
              Icons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileModel>(builder: (context, state) {
        return GridView.builder(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 400,
            childAspectRatio: 1.1,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
          ),
          itemCount: state.documents.length,
          itemBuilder: (ctx, index) {
            return _docBox(context, doc: state.documents[index]);
          },
        );
      }),
    );
  }

  Widget _docBox(BuildContext context, {required ProfileDocument doc}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: CachedNetworkImage(
                    imageUrl: doc.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    placeholder: (context, url) =>
                        const Center(child: CupertinoActivityIndicator()),
                    errorWidget: (_, __, ___) =>
                        Image.asset("assets/images/placeholder.png"),
                  ),
                ),
              ),
              const Divider(
                indent: 0,
                height: 0,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      doc.type,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      doc.docId,
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff707070)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Expiration",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat("MMM dd, yyyy").format(doc.expireDate!),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff707070)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
            onPressed: () =>
                showImageBox(context, imagePaths: [doc.image], index: 0),
            style: TextButtonStyles.overlayButtonStyle().copyWith(
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            child: const SizedBox(
              height: double.infinity,
              width: double.infinity,
            ),
          ),
        ],
      ),
    );
  }
}
