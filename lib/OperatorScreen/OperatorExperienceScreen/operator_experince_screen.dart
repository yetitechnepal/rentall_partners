import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/OperatorScreen/OperatorExperienceScreen/AddEditExperiencePopups/add_edit_experience_popup.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class OperatorExperienceScreen extends StatelessWidget {
  const OperatorExperienceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("EXPERIENCES"),
        actions: [
          IconButton(
            onPressed: () {
              showAddEditExperiencePopup(context);
            },
            icon: AEMPLIcon(
              AEMPLIcons.add,
              color: Theme.of(context).primaryColor,
            ),
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileModel>(builder: (context, state) {
        return ListView.builder(
            itemCount: state.experiences.length,
            padding: const EdgeInsets.symmetric(vertical: 5),
            itemBuilder: (context, index) {
              ProfileExperience experience = state.experiences[index];
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
                            experience.skill,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyLarge!.color,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            experience.companyName,
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            DateFormat("MMM dd, yyy")
                                    .format(experience.startDate!) +
                                " - " +
                                (experience.endDate == null
                                    ? "Present"
                                    : DateFormat("MMM dd, yyy")
                                        .format(experience.endDate!)),
                            style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyMedium!.color,
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
                            showAddEditExperiencePopup(
                              context,
                              experience: experience,
                            );
                          },
                          icon: AEMPLIcon(
                            AEMPLIcons.edit,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            });
      }),
    );
  }
}
