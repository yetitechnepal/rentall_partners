// ignore_for_file: implementation_imports, body_might_complete_normally_nullable

import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/src/provider.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/date_picker_theme.dart';
import 'package:rental_partners/Utils/text_field.dart';
import 'package:rental_partners/main.dart';

class SkillSet {
  late int id;
  late String value, description;
  SkillSet.fromMap(map) {
    id = map['id'];
    value = map['value'];
    description = map['description'];
  }
}

class SkillSets {
  List<SkillSet> skills = [];
  Future<SkillSets> fetchSkills() async {
    Response response = await API().get(endPoint: "operator-skills/");
    if (response.statusCode == 200) {
      var data = response.data['data'];
      for (var element in data) {
        log(element.toString());
        skills.add(SkillSet.fromMap(element));
      }
    }
    return this;
  }
}

showAddEditExperiencePopup(BuildContext context,
    {ProfileExperience? experience}) {
  showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) {
      return ExperiencePopup(experience: experience);
    },
  );
}

class ExperiencePopup extends StatefulWidget {
  final ProfileExperience? experience;

  const ExperiencePopup({Key? key, this.experience}) : super(key: key);

  @override
  State<ExperiencePopup> createState() => _ExperiencePopupState();
}

class _ExperiencePopupState extends State<ExperiencePopup> {
  bool isCurrentlyWorking = true;
  TextEditingController companyNameController = TextEditingController();
  DateTime? startDate, endDate;
  List<SkillSet> skills = [];
  SkillSet? selectedSkill;

  final formKey = GlobalKey<FormState>();
  @override
  void initState() {
    if (widget.experience != null) {
      companyNameController.text = widget.experience!.companyName;
      isCurrentlyWorking = widget.experience!.endDate == null;
      startDate = widget.experience!.startDate;
      endDate = widget.experience!.endDate;
    }
    getSkills();
    super.initState();
  }

  getSkills() async {
    SkillSets skillSets = SkillSets();
    skills = (await skillSets.fetchSkills()).skills;
    log(skills.toString());
    setState(() => skills);

    if (widget.experience != null) {
      for (var skill in skills) {
        if (widget.experience!.skill == skill.value) {
          setState(() {
            selectedSkill = skill;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.experience == null
              ? "Add Experience".toUpperCase()
              : "Edit Experience".toUpperCase(),
        ),
      ),
      body: Form(
        key: formKey,
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: [
                textFieldText("Skill"),
                AEMPLPopUpButton(
                  hintText: "Select skill",
                  value: selectedSkill == null ? null : selectedSkill!.value,
                  prefix: const Icon(Icons.home_outlined),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (ctx) => Dialog(
                        child: ListView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            itemCount: skills.length,
                            itemBuilder: (cnt, index) {
                              return InkWell(
                                onTap: () {
                                  setState(() => selectedSkill = skills[index]);
                                  Navigator.pop(context);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    skills[index].value,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyText1!
                                          .color,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    );
                  },
                ),
                textFieldText("Company Name"),
                AEMPLTextField(
                  controller: companyNameController,
                  hintText: "Company name",
                  prefix: const Icon(Icons.home_outlined),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Enter company name";
                    }
                  },
                ),
                const SizedBox(height: 10),
                Visibility(
                  visible: endDate == null,
                  child: CheckboxListTile(
                    title: const Text("I am currently working in this company"),
                    value: isCurrentlyWorking,
                    onChanged: (value) {
                      setState(() {
                        isCurrentlyWorking = value!;
                        endDate = null;
                      });
                    },
                  ),
                ),
                textFieldText("Start Date"),
                AEMPLPopUpButton(
                  hintText: "Start Date",
                  value: startDate == null
                      ? null
                      : DateFormat("MMM dd, yyyy").format(startDate!),
                  prefix: const Icon(Icons.home_outlined),
                  onPressed: () async {
                    DateTime? selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: datePickerTheme(context),
                          child: child!,
                        );
                      },
                    );
                    if (selectedDate != null) {
                      setState(() => startDate = selectedDate);
                    }
                  },
                ),
                textFieldText("End Date"),
                AEMPLPopUpButton(
                  hintText: "End Date",
                  value: endDate == null
                      ? null
                      : DateFormat("MMM dd, yyyy").format(endDate!),
                  prefix: const Icon(Icons.home_outlined),
                  onPressed: isCurrentlyWorking
                      ? null
                      : () async {
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime.now(),
                            builder: (context, child) {
                              return Theme(
                                data: datePickerTheme(context),
                                child: child!,
                              );
                            },
                          );
                          if (selectedDate != null) {
                            setState(() => endDate = selectedDate);
                          }
                        },
                ),
                const SizedBox(height: 20),
                Center(
                  child: TextButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        bool isSuccess = await saveExperience(
                          context,
                          id: widget.experience == null
                              ? null
                              : widget.experience!.id,
                          companyName: companyNameController.text,
                          skillId: selectedSkill!.id,
                          isCurentlyWorking: isCurrentlyWorking,
                          startDate:
                              DateFormat("yyyy-MM-dd").format(startDate!),
                          endDate: endDate == null
                              ? null
                              : DateFormat("yyyy-MM-dd").format(endDate!),
                        );
                        if (isSuccess) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: Text(widget.experience == null ? "Add" : "Update"),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> saveExperience(
  BuildContext context, {
  int? id,
  required String companyName,
  required int skillId,
  required bool isCurentlyWorking,
  required String startDate,
  String? endDate,
}) async {
  Response response;

  var data = {
    "company": companyName,
    "currently_working": isCurentlyWorking ? 1 : 0,
    "operator_skills": skillId,
    "start_date": startDate,
    "end_date": endDate
  };
  if (id != null) {
    data.addAll({"id": id});
    response = await API().put(endPoint: "accounts/experience/", data: data);
  } else {
    response = await API().post(endPoint: "accounts/experience/", data: data);
  }
  log(data.toString());

  scaffoldMessageKey.currentState!
      .showSnackBar(SnackBar(content: Text(response.data['message'])));
  if (response.statusCode == 200) {
    context.read<ProfileCubit>().fetchProfile();
    return true;
  } else {
    return false;
  }
}
