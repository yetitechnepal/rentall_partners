import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/OperatorScreen/OperatorExperienceScreen/AddEditExperiencePopups/add_edit_experience_popup.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/Model/vender_model.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/text_field.dart';

class ExperienceListBox extends StatefulWidget {
  const ExperienceListBox({Key? key}) : super(key: key);

  @override
  State<ExperienceListBox> createState() => ExperienceListBoxState();
}

class ExperienceListBoxState extends State<ExperienceListBox>
    with AutomaticKeepAliveClientMixin {
  List<Experience> experiences = [];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            textFieldText(
              "Experience",
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Theme.of(context).primaryColor,
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                showAddEditExperiencePopup(
                  context,
                  onAdd: (Experience experience) {
                    log("Adding");
                    experiences.add(experience);
                    setState(() => experiences);
                  },
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: experiences.length,
          itemBuilder: (context, index) {
            Experience experience = experiences[index];

            return Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Theme.of(context).scaffoldBackgroundColor,
                boxShadow: BoxShadows.dropShadow(context),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          experience.skillName,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText1!.color,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          experience.companyName,
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat("MMM dd, yyy")
                                  .format(experience.startDate) +
                              " - " +
                              (experience.endDate == null
                                  ? "Present"
                                  : DateFormat("MMM dd, yyy")
                                      .format(experience.endDate!)),
                          style: TextStyle(
                            color: Theme.of(context).textTheme.bodyText2!.color,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Material(
                      color: Colors.transparent,
                      child: IconButton(
                        onPressed: () {
                          showCupertinoDialog(
                            context: context,
                            builder: (ctx) => CupertinoAlertDialog(
                              title: const Text("Are you sure?"),
                              actions: [
                                CupertinoDialogAction(
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  onPressed: () {
                                    experiences.removeAt(index);
                                    setState(() => experiences);
                                    Navigator.pop(ctx);
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
                        icon: Icon(
                          Icons.close,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
