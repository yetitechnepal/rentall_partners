import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/become_vender_contact_screen.dart';
import 'package:rental_partners/Utils/profile_upload_box.dart';
import 'package:rental_partners/Utils/text_field.dart';

class BecomeVenderScreen extends StatelessWidget {
  BecomeVenderScreen({Key? key}) : super(key: key);

  List<TextEditingController> controllers =
      List.generate(8, (index) => TextEditingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("BECOME VENDER")),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const ProfileUploadBox(),
                const SizedBox(height: 10),
                textFieldText(
                  "General",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
                textFieldText("Company Name"),
                AEMPLTextField(
                  controller: controllers[0],
                  hintText: "Company name",
                  prefix: const Icon(Icons.business),
                ),
                const SizedBox(height: 10),
                textFieldText("Personal Account Number"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "PAN",
                  prefix: const Icon(Icons.card_giftcard),
                ),
                const SizedBox(height: 10),
                textFieldText("About Company"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "Company information",
                  maxLines: 10,
                  prefix: const Icon(Icons.info),
                ),
                const SizedBox(height: 30),
                textFieldText(
                  "Address",
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Theme.of(context).primaryColor,
                ),
                textFieldText("State"),
                AEMPLTextField(
                  controller: controllers[0],
                  hintText: "State",
                  prefix: const Icon(Icons.map),
                ),
                const SizedBox(height: 10),
                textFieldText("District"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "District",
                  prefix: const Icon(Icons.location_city),
                ),
                const SizedBox(height: 10),
                textFieldText("Ward"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "Ward",
                  prefix: const Icon(Icons.location_on),
                ),
                const SizedBox(height: 10),
                textFieldText("Tole"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "Tole",
                  prefix: const Icon(Icons.local_library_sharp),
                ),
                const SizedBox(height: 10),
                textFieldText("Country"),
                AEMPLTextField(
                  controller: controllers[1],
                  hintText: "Country",
                  prefix: const Icon(CupertinoIcons.globe),
                ),
                const SizedBox(height: 30),
                Center(
                  child: TextButton(
                    onPressed: () =>Navigator.push(context, MaterialPageRoute(builder: (context) => BecomeVenderContactScreen(),)),
                    child: Text("Next"),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
