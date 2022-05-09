// ignore_for_file: body_might_complete_normally_nullable

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
// ignore: implementation_imports
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Utils/loading_widget.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

class ContactType {
  late String value, description;
  late int id;
  ContactType.fromMap(map) {
    id = map['id'];
    value = map['value'];
    description = map['description'];
  }
}

Future<List<ContactType>> fetchContactTypes() async {
  List<ContactType> contactTypes = [];
  Response response = await API().get(endPoint: "contact-type/");
  if (response.statusCode == 200) {
    for (var element in response.data['data']) {
      contactTypes.add(ContactType.fromMap(element));
    }
  }
  return contactTypes;
}

Future<ContactType?> getContactType(String type) async {
  List<ContactType> contactTypes = await fetchContactTypes();
  for (var ele in contactTypes) {
    if (type == ele.value) {
      return ele;
    }
  }
  return null;
}

Future<bool> addUpdateContact(
  BuildContext context, {
  int? id,
  required String conactType,
  required String conactValue,
  required bool isPrimary,
}) async {
  context.loaderOverlay.show();
  Response response;
  if (id == null) {
    response = await API().post(
      endPoint: "accounts/add-contact/",
      data: {
        "contact_type": conactType,
        "contact_value": conactValue,
        "is_primary": isPrimary,
      },
    );
  } else {
    response = await API().put(
      endPoint: "accounts/update-contact/",
      data: {
        "contact_type": conactType,
        "contact_value": conactValue,
        "is_primary": isPrimary,
        "id": id,
      },
    );
  }
  scaffoldMessageKey.currentState!.showSnackBar(SnackBar(
    content: Text(response.data['message']),
    duration: const Duration(milliseconds: 300),
  ));
  context.loaderOverlay.hide();
  if (response.statusCode == 200) {
    context.read<ProfileCubit>().fetchProfile();
    return true;
  } else {
    return false;
  }
}

shoowAddEditPopup(BuildContext context,
    {ProfileContact? contact, required bool isAddNew}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) {
      return ProfileContentAddEditBox(
        contact: contact,
        isAddNew: isAddNew,
      );
    },
  );
}

class ProfileContentAddEditBox extends StatefulWidget {
  final ProfileContact? contact;
  final bool isAddNew;

  const ProfileContentAddEditBox(
      {Key? key, this.contact, required this.isAddNew})
      : super(key: key);

  @override
  State<ProfileContentAddEditBox> createState() =>
      _ProfileContentAddEditBoxState();
}

class _ProfileContentAddEditBoxState extends State<ProfileContentAddEditBox> {
  ContactType? contactType;
  late final TextEditingController controller;
  bool isPrimary = false;

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    controller = TextEditingController(
        text: widget.contact != null ? widget.contact!.value : null);
    if (widget.contact != null) {
      isPrimary = widget.contact!.isPrimary;
      getContact();
    }
    super.initState();
  }

  getContact() async {
    contactType = await getContactType(widget.contact!.contactType);
    setState(() => contactType);
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.isAddNew
                ? "Add Contact".toUpperCase()
                : "Edit Contact".toUpperCase(),
          ),
        ),
        body: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Container(
              alignment: Alignment.topCenter,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    textFieldText("Contact Type"),
                    AEMPLPopUpButton(
                      hintText: "Select contact type",
                      value: contactType != null ? contactType!.value : null,
                      prefix: const Icon(Icons.contact_support_outlined),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => Dialog(
                            child: FutureBuilder<List<ContactType>>(
                                future: fetchContactTypes(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (ctx, index) => ListTile(
                                        onTap: () {
                                          setState(() => contactType =
                                              snapshot.data![index]);
                                          Navigator.pop(context);
                                        },
                                        title:
                                            Text(snapshot.data![index].value),
                                      ),
                                    );
                                  } else {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      child: const CupertinoActivityIndicator(),
                                    );
                                  }
                                }),
                          ),
                        );
                      },
                    ),
                    textFieldText("Contact"),
                    AEMPLTextField(
                      controller: controller,
                      hintText: "Enter contact",
                      prefix: const Icon(Icons.contact_phone_outlined),
                      keyboardType: contactType == null
                          ? TextInputType.text
                          : contactType!.value == "Phone"
                              ? TextInputType.phone
                              : TextInputType.text,
                      validator: (value) {
                        if (contactType == null) {
                          return "Please select contact type";
                        } else if (value!.isEmpty) {
                          if (contactType!.value.toUpperCase() == "PHONE") {
                            return "Enter phone number";
                          } else {
                            return "Enter email";
                          }
                        } else {
                          var email = value;
                          bool emailValid = RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(email);
                          if (contactType!.value.toUpperCase() == "PHONE" &&
                              emailValid) {
                            return "Enter valid phone number";
                          }
                          if (contactType!.value.toUpperCase() == "EMAIL" &&
                              !emailValid) {
                            return "Enter valid email";
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    CheckboxListTile(
                      value: isPrimary,
                      title: Text(
                        "Is primary",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => isPrimary = value!);
                      },
                    ),
                    const SizedBox(height: 30),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            if (contactType == null ||
                                controller.text.isEmpty) {
                              scaffoldMessageKey.currentState!.showSnackBar(
                                  const SnackBar(
                                      content: Text("Please fill all data")));
                              return;
                            }
                            if (await addUpdateContact(
                              context,
                              id: widget.isAddNew ? null : widget.contact!.id,
                              conactType: contactType!.id.toString(),
                              conactValue: controller.text,
                              isPrimary: isPrimary,
                            )) {
                              Navigator.pop(context);
                            }
                          }
                        },
                        child: Text(
                            widget.isAddNew ? "Add contact" : "Update contact"),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
