// ignore_for_file: implementation_imports

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

import '../../Account/account_screen.dart';

class DashboardTopBar extends StatelessWidget {
  const DashboardTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<ProfileCubit>().fetchProfile();
    return Positioned(
      top: -80,
      child: BlocBuilder<ProfileCubit, ProfileModel>(builder: (context, state) {
        return Center(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AccountScreen(),
              ));
            },
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    boxShadow: BoxShadows.selectedDropShadow(context),
                  ),
                  child: ClipOval(
                    child: CachedNetworkImage(
                      imageUrl: state.profile,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CupertinoActivityIndicator()),
                      errorWidget: (_, __, ___) =>
                          Image.asset("assets/images/placeholder.png"),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).scaffoldBackgroundColor,
                  ),
                  child: Text(
                    state.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }),
    );
  }
}
