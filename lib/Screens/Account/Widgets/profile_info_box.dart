import 'package:flutter/material.dart';
import 'package:rental_partners/Blocs/profile_bloc.dart';
import 'package:rental_partners/Screens/Account/PopUps/bio_update_popup.dart';
import 'package:rental_partners/Singletons/login_session.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class ProfileInfoBox extends StatelessWidget {
  final ProfileModel profile;

  const ProfileInfoBox({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            children: [
              Text(
                LoginSession().isVender()
                    ? "Company Details"
                    : "Operator Information",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              _pill(context,
                  value:
                      profile.isContractDone ? "MOU signed" : "MOU not signed",
                  isVerified: profile.isContractDone),
              const SizedBox(width: 10),
              _pill(context,
                  value: profile.isKycVerified
                      ? "KYC Verified"
                      : "KYC not verified",
                  isVerified: profile.isKycVerified),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                LoginSession().isVender() ? "Vendor" : "Name",
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  showBioUpdatePopup(context,
                      vender: profile.name, bio: profile.description);
                },
                iconSize: 20,
                padding: EdgeInsets.zero,
                splashRadius: 20,
                icon: Text(
                  "Edit",
                  style: TextStyle(
                    fontSize: 10,
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        _viewText(
          context,
          value: profile.name,
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: const Text(
            "Bio",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        _viewText(
          context,
          value: profile.description,
        ),
      ],
    );
  }

  Widget _viewText(BuildContext context, {required String value}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        boxShadow: BoxShadows.dropShadow(context),
        color: Theme.of(context).scaffoldBackgroundColor.withOpacity(0.9),
      ),
      child: Text(
        value,
        style: TextStyle(color: Theme.of(context).textTheme.bodyLarge!.color),
      ),
    );
  }

  Widget _pill(BuildContext context,
      {required String value, required bool isVerified}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green : Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 7,
        ),
      ),
    );
  }
}
