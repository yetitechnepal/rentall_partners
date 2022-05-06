import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/Account/account_screen.dart';
import 'package:rental_partners/Screens/AllAttachmentsScreen/all_attachments_screen.dart';
import 'package:rental_partners/Screens/AllEquipmentsScreen/all_equipments_screen.dart';
import 'package:rental_partners/Screens/DashboardScreen/dashboard_screen.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  const MainScreen({Key? key, this.initialIndex = 0}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentPage = 0;

  @override
  void initState() {
    currentPage = widget.initialIndex;
    super.initState();
  }

  Future<bool> _onWillPop() async {
    if (currentPage == 0) {
      return (await showCupertinoDialog(
            context: context,
            builder: (ctx) => CupertinoAlertDialog(
              title: const Text("Are you sure to exit?"),
              actions: [
                CupertinoDialogAction(
                  child: const Text(
                    "Yes, Exist",
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
                CupertinoDialogAction(
                  child: const Text(
                    "No",
                    style: TextStyle(color: Colors.green),
                  ),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
              ],
            ),
          ) ??
          false);
    } else {
      setState(() => currentPage = 0);
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        body: [
          DashboardScreen(),
          AllEquipmentsScreen(),
          AllAttachmentsScreen(),
          const AccountScreen(),
        ][currentPage],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            boxShadow: BoxShadows.dropShadow(context),
            // color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BottomNavigationBar(
              currentIndex: currentPage,
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              selectedItemColor: Theme.of(context).primaryColor,
              unselectedItemColor: const Color(0xffAAB4BD),
              showUnselectedLabels: true,
              type: BottomNavigationBarType.fixed,
              onTap: (page) {
                setState(() => currentPage = page);
              },
              items: const [
                BottomNavigationBarItem(
                  icon: AEMPLIcon(AEMPLIcons.home),
                  label: "Home",
                ),
                BottomNavigationBarItem(
                  icon: AEMPLIcon(AEMPLIcons.equipment),
                  label: "Equipment",
                ),
                BottomNavigationBarItem(
                  icon: AEMPLIcon(AEMPLIcons.model),
                  label: "Attachment",
                ),
                BottomNavigationBarItem(
                  icon: AEMPLIcon(AEMPLIcons.profile),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
