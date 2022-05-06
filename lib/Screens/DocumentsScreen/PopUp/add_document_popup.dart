// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/date_picker_theme.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class DocType {
  late int id;
  late String value;
  DocType.fromMap(map) {
    id = map['id'];
    value = map['value'];
  }
}

class DocTypes {
  List<DocType> docs = [];
  Future<DocTypes> fetchDocTypes() async {
    Response response = await API().get(endPoint: "document-type/");
    if (response.statusCode == 200) {
      for (var element in response.data['data']) {
        docs.add(DocType.fromMap(element));
      }
    }
    return this;
  }
}

class Document {
  final String image, docType, docId, expiryDate;

  Document(this.image, this.docType, this.docId, this.expiryDate);

  Future<bool> addDoc(BuildContext context) async {
    context.loaderOverlay.show();
    FormData formData = FormData.fromMap({
      "type": docType,
      "document_id": docId,
      "expire_date": expiryDate,
    });
    formData.files.add(
      MapEntry(
        "image",
        await MultipartFile.fromFile(
          image,
          filename: "document-" +
              DateTime.now().millisecondsSinceEpoch.toString() +
              '.jpg',
        ),
      ),
    );
    Response response =
        await API().post(endPoint: "accounts/document-upload/", data: formData);
    scaffoldMessageKey.currentState!.clearSnackBars();
    scaffoldMessageKey.currentState!
        .showSnackBar(SnackBar(content: Text(response.data['message'])));

    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      context.read<ProfileCubit>().fetchProfile();
      return true;
    } else {
      return false;
    }
  }
}

showAddDocumentPopup(BuildContext context) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) => const AddDocumentBox(),
  );
}

class AddDocumentBox extends StatefulWidget {
  const AddDocumentBox({Key? key}) : super(key: key);

  @override
  State<AddDocumentBox> createState() => _AddDocumentBoxState();
}

class _AddDocumentBoxState extends State<AddDocumentBox> {
  AssetEntity? image;
  DocType? docType;
  TextEditingController controller = TextEditingController();
  DateTime? expiryDate;
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("ADD DOCUMENT"),
        ),
        body: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              children: [
                textFieldText("Document Type"),
                AEMPLPopUpButton(
                  value: docType == null ? null : docType!.value,
                  hintText: "Select document type",
                  prefix: const Icon(Icons.document_scanner_outlined),
                  onPressed: () {
                    final DocTypes docTypes = DocTypes();
                    showDialog(
                      context: context,
                      builder: (ctx) => Dialog(
                        child: FutureBuilder<DocTypes>(
                          future: docTypes.fetchDocTypes(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (cont, index) {
                                    return ListTile(
                                      title: Text(
                                          snapshot.data!.docs[index].value),
                                      onTap: () {
                                        setState(() {
                                          docType = snapshot.data!.docs[index];
                                        });
                                        Navigator.pop(ctx);
                                      },
                                    );
                                  });
                            } else {
                              return const Padding(
                                padding: EdgeInsets.all(20),
                                child: CupertinoActivityIndicator(),
                              );
                            }
                          },
                        ),
                      ),
                    );
                  },
                ),
                textFieldText("Document Number"),
                AEMPLTextField(
                  controller: controller,
                  hintText: "Document identity number",
                  prefix: const Icon(Icons.info_outline),
                ),
                textFieldText("Expiration date"),
                AEMPLPopUpButton(
                  value: expiryDate == null
                      ? null
                      : DateFormat("MMM dd, yyyy").format(expiryDate!),
                  hintText: "Select date of expiration",
                  prefix: const Icon(
                    Icons.calendar_today_outlined,
                    // color: Color(0xffF8F8F8),
                  ),
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now()
                          .subtract(const Duration(days: 1000 * 365)),
                      lastDate:
                          DateTime.now().add(const Duration(days: 1000 * 365)),
                      builder: (context, child) {
                        return Theme(
                          data: datePickerTheme(context),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate == null) return;
                    setState(() => expiryDate = selectedDate);
                  },
                ),
                textFieldText("Image File(The file must be less than 1MB)"),
                Builder(
                  builder: (ctx) {
                    if (image != null) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          Image(
                            image: AssetEntityImageProvider(image!),
                            height: 200,
                            fit: BoxFit.contain,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 20,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(100),
                                color: Colors.white,
                              ),
                              child: InkWell(
                                // : Colors.white,
                                borderRadius: BorderRadius.circular(100),
                                onTap: onImageChoose,
                                child: Container(
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    border: Border.all(
                                        color: const Color(0xff707070),
                                        width: 1),
                                  ),
                                  padding: const EdgeInsets.all(10),
                                  child: const Icon(Icons.edit),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }

                    return const SizedBox();
                  },
                ),
                Visibility(
                  visible: image == null,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border:
                          Border.all(color: const Color(0xff707070), width: 1),
                    ),
                    child: InkWell(
                      onTap: onImageChoose,
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(40),
                        child: Text(image == null ? "Upload" : "Change"),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      if (controller.text.isEmpty ||
                          image == null ||
                          expiryDate == null ||
                          docType == null) {
                        scaffoldMessageKey.currentState!.showSnackBar(
                          const SnackBar(content: Text("Please fill all data")),
                        );
                      } else {
                        Document document = Document(
                          (await image!.file)!.path,
                          docType!.id.toString(),
                          controller.text,
                          DateFormat("yyyy-MM-dd").format(expiryDate!),
                        );
                        if (await document.addDoc(context)) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text("Save"),
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  onImageChoose() async {
    final List<AssetEntity>? result = await AssetPicker.pickAssets(
      context,
      selectedAssets: [],
      maxAssets: 1,
      textDelegate: EnglishTextDelegate(),
      specialPickerType: SpecialPickerType.noPreview,
    );
    if (result == null) return;
    setState(() => image = result.first);
  }
}
