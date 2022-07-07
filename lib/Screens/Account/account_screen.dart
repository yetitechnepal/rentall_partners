import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Screens/Account/Widgets/address_pan_box.dart';
import 'package:rental_partners/Screens/Account/Widgets/contact_detail_box.dart';
import 'package:rental_partners/Screens/Account/Widgets/profile_image_box.dart';
import 'package:rental_partners/Screens/Account/Widgets/profile_info_box.dart';
import 'package:rental_partners/Screens/LoginScreen/login_screen.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/Theme/theme_change_listener.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile();
    listernToTheme(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Account".toUpperCase()),
        actions: [
          IconButton(
            onPressed: () {
              showCupertinoDialog(
                context: context,
                builder: (ctx) => CupertinoAlertDialog(
                  title: const Text("Are you sure to logout?"),
                  actions: [
                    CupertinoDialogAction(
                      child: Text(
                        "Yes, logout",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      onPressed: () {
                        LoginSession().logout();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (_) => LoginScreen()),
                          (route) => false,
                        );
                      },
                    ),
                    CupertinoDialogAction(
                      child: const Text(
                        "No",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              );
            },
            icon: Icon(
              Icons.logout,
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: BlocBuilder<ProfileCubit, ProfileModel>(
                builder: (context, state) {
              return ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: [
                  ProfileImageBox(image: state.profile),
                  ProfileInfoBox(profile: state),
                  AddressPanBox(profile: state),
                  ContactDetailBox(profile: state),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
