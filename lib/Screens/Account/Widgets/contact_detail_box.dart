// ignore_for_file: implementation_imports

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Screens/Account/PopUps/contact_add_edit_popup.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/colors.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Widgets/title_box.dart';

deleteContact(BuildContext context, int id) async {
  Response response =
      await API().delete(endPoint: "accounts/$id/delete-contact/");
  if (response.statusCode == 200) {
    context.read<ProfileCubit>().fetchProfile();
  }
}

class ContactDetailBox extends StatelessWidget {
  final ProfileModel profile;

  const ContactDetailBox({Key? key, required this.profile}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TitleBar(
          title: "Contact Details",
          suffix: IconButton(
            onPressed: () {
              shoowAddEditPopup(context, isAddNew: true);
            },
            iconSize: 20,
            splashRadius: 20,
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: BoxShadows.dropShadow(context),
                borderRadius: BorderRadius.circular(100),
              ),
              child: const AEMPLIcon(
                AEMPLIcons.add,
                size: 15,
              ),
            ),
          ),
        ),
        _viewText(
          context,
          isPrimary: true,
          value: profile.email,
        ),
        const SizedBox(height: 10),
        ListView.separated(
          itemCount: profile.contacts.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (ctx, index) {
            return _viewText(
              context,
              isPrimary: profile.contacts[index].isPrimary,
              value: profile.contacts[index].value,
              onEditPressed: () {
                shoowAddEditPopup(
                  context,
                  contact: profile.contacts[index],
                  isAddNew: false,
                );
              },
              onDeletePressed: () {
                showCupertinoDialog(
                  context: context,
                  builder: (ctx) => CupertinoAlertDialog(
                    title: const Text("Are you sure to delete contact?"),
                    actions: [
                      CupertinoDialogAction(
                        child: const Text(
                          "Yes",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                          deleteContact(context, profile.contacts[index].id);
                        },
                      ),
                      CupertinoDialogAction(
                        child: const Text(
                          "No",
                          style: TextStyle(color: Colors.green),
                        ),
                        onPressed: () {
                          Navigator.pop(ctx);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const SizedBox(height: 10),
        ),
      ],
    );
  }

  Widget _viewText(
    BuildContext context, {
    required bool isPrimary,
    required String value,
    Function()? onEditPressed,
    Function()? onDeletePressed,
  }) {
    return Container(
      padding: const EdgeInsets.only(left: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: Theme.of(context).scaffoldBackgroundColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Visibility(
            visible: isPrimary,
            child: Container(
              height: 10,
              width: 10,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius: BorderRadius.circular(100)),
            ),
          ),
          Expanded(child: Text(value)),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onEditPressed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: onEditPressed == null
                    ? const AEMPLIcon(
                        AEMPLIcons.edit,
                        color: Colors.transparent,
                        size: 14,
                      )
                    : AEMPLIcon(
                        AEMPLIcons.edit,
                        color: Theme.of(context).primaryColor,
                        size: 14,
                      ),
              ),
            ),
          ),
          ClipRRect(
            borderRadius:
                const BorderRadius.horizontal(right: Radius.circular(11)),
            child: Material(
              color: Colors.transparent,
              child: onDeletePressed == null
                  ? const SizedBox()
                  : InkWell(
                      onTap: onDeletePressed,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: AEMPLIcon(
                          AEMPLIcons.trash,
                          color: Theme.of(context).primaryColor,
                          size: 14,
                        ),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
