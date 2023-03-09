// ignore_for_file: implementation_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/OperatorScreen/OperatorDashboardScreen/Widgets/operator_summary_section.dart';
import 'package:rental_partners/Screens/Account/account_screen.dart';
import 'package:rental_partners/Screens/NotificationScreen/notification_screen.dart';

class OperatorDashboardScreen extends StatelessWidget {
  const OperatorDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        leadingWidth: 80,
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0),
          child: Row(
            children: [
              IconButton(
                iconSize: 50,
                padding: const EdgeInsets.all(4),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountScreen(),
                    ),
                  );
                },
                icon: BlocBuilder<ProfileCubit, ProfileModel>(
                  builder: (context, state) {
                    return Hero(
                      tag: "profile Image",
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            width: 2,
                          ),
                        ),
                        child: ClipOval(
                          child: CachedNetworkImage(
                            imageUrl: state.profile,
                            fit: BoxFit.cover,
                            height: 60,
                            width: 60,
                            placeholder: (context, url) => const Center(
                                child: CupertinoActivityIndicator()),
                            errorWidget: (_, __, ___) =>
                                Image.asset("assets/images/placeholder.png"),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        title: const Text(
          "DASHBOARD",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationScreen(),
                ),
              );
            },
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: GridView.extent(
        maxCrossAxisExtent: 200,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        // crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1,
        children: const [
          OperatorSummarySectiion(
            title: "Today’s Books",
          ),
          OperatorSummarySectiion(
            title: "This Week’s Books",
          ),
          // OperatorSummarySectiion(
          //   title: "Operate this week",
          // ),
          OperatorSummarySectiion(
            title: "Completed this Week",
          ),
          OperatorSummarySectiion(
            title: "Cancelled this week",
          ),
        ],
      ),
    );
  }
}
