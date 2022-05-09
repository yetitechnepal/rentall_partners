import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/DashboardScreen/Widgets/summary_section.dart';
import 'package:rental_partners/Screens/DashboardScreen/Widgets/topbar.dart';
import 'package:rental_partners/Screens/NotificationScreen/notification_screen.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);
  final GlobalKey listViewKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        children: [
          // const DashboardTopBar(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(bottom: 70),
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.97)),
            child: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                "DASHBOARD",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              actions: [
                IconButton(
                  icon: const AEMPLIcon(
                    AEMPLIcons.notification,
                    color: Colors.white,
                  ),
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NotificationScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.center,
                children: [
                  RefreshIndicator(
                    onRefresh: () {
                      return Future.delayed(
                          const Duration(seconds: 1), () => true);
                    },
                    child: ListView(
                      key: listViewKey,
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      children: const [
                        SummarySectiion(title: "Today’s Order"),
                        SummarySectiion(title: "This Week’s Order"),
                        SummarySectiion(
                          title: "Order to Dispatch this Week",
                          isBoth: false,
                        ),
                        SummarySectiion(
                          title: "Order to Complete this Week",
                          isBoth: false,
                        ),
                        SummarySectiion(
                          title: "Order to Cancelled this Week",
                          isBoth: false,
                        ),
                      ],
                    ),
                  ),
                  const DashboardTopBar(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
