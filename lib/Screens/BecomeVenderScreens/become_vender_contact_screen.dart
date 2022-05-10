import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rental_partners/Screens/BecomeVenderScreens/become_vender_documents_screen.dart';
import 'package:rental_partners/Utils/text_field.dart';

class BecomeVenderContactScreen extends StatelessWidget {
  final controllers = List.generate(3, (index) => TextEditingController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("ADD CONTACT")),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                textFieldText("Primary Email"),
                AEMPLTextField(
                  controller: controllers[0],
                  hintText: "Primary email",
                  prefix: const Icon(Icons.email),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                textFieldText("Primary Phone Number"),
                AEMPLTextField(
                  controller: controllers[0],
                  hintText: "Primary phone number",
                  prefix: const Icon(CupertinoIcons.phone_solid),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 10),
                textFieldText("Secondary Phone Number"),
                AEMPLTextField(
                  controller: controllers[0],
                  hintText: "Secondary phone number(Optional)",
                  prefix: const Icon(Icons.phone_android_rounded),
                  keyboardType: TextInputType.phone,
                ),
                const SizedBox(height: 50),
                Center(
                  child: TextButton(
                    child: const Text("Next"),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BecomeVenderDocumentScreen(),
                      ),
                    ),
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
