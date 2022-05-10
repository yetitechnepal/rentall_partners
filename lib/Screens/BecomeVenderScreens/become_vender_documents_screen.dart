import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class BecomeVenderDocumentScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ADD DOCUMENTS"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width > 450 ? 20 : 0,
              ).copyWith(top: 20, bottom: 20),
              itemCount: 3,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 450,
                childAspectRatio: 1.6,
                mainAxisSpacing: 16,
                crossAxisSpacing:
                    MediaQuery.of(context).size.width > 450 ? 16 : 0,
              ),
              itemBuilder: (context, index) {
                return _docBox(context);
              },
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: TextButton(
              onPressed: () {},
              child: const Text("Next"),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _docBox(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(10)),
                  child: Image.asset(
                    "assets/images/placeholder.png",
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const Divider(
                indent: 0,
                height: 0,
              ),
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 3),
                    Text(
                      "Image",
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "1234567",
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff707070)),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Expiration",
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      DateFormat("MMM dd, yyyy").format(DateTime.now()),
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xff707070)),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            right: 0,
            child: ClipOval(
              child: Material(
                color: Colors.transparent,
                child: IconButton(
                  onPressed: () {},
                  icon: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Colors.white,
                        boxShadow: BoxShadows.selectedDropShadow(context),
                      ),
                      child: const Icon(Icons.close)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
