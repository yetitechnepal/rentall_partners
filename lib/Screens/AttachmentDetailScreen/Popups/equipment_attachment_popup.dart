import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/AttachmentDetailScreen/Models/attachment_details_model.dart';
import 'package:rental_partners/Singletons/api_call.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';

class _Equipment {
  final int id;
  final String image, name;
  _Equipment(this.id, this.image, this.name);
}

class _AvailableEquipments {
  List<_Equipment> equipments = [];
  Future<_AvailableEquipments> fetchAvailableEquipments(int id) async {
    Response response = await API()
        .get(endPoint: "equipment/$id/list-equipment/", useToken: true);
    if (response.statusCode == 200) {
      var data = response.data['data'];
      for (var element in data) {
        equipments.add(
          _Equipment(element['id'], element['image'], element['name']),
        );
      }
    }
    return this;
  }

  static Future<bool> update(BuildContext context,
      {required int id, required List<int> equipIds}) async {
    context.loaderOverlay.show();
    Response response = await API().post(
        endPoint: "equipment/$id/link-equipment/", data: {"id": equipIds});
    context.loaderOverlay.hide();
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}

Future showAttachmentLinkedEquipmentPopup(
    BuildContext context, List<int> equipIds, int id) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) {
      return _EquipmentAttachmentBoxx(equipIds: equipIds, id: id);
    },
  );
}

class _EquipmentAttachmentBoxx extends StatelessWidget {
  final int id;

  final _AvailableEquipments _availableEquipments = _AvailableEquipments();

  final List<int> equipIds;

  _EquipmentAttachmentBoxx({
    Key? key,
    required this.equipIds,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Link Equipment".toUpperCase()),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (cnt) => CupertinoAlertDialog(
                title: const Text("Any changes will be discard"),
                actions: [
                  CupertinoDialogAction(
                    child: const Text(
                      "Discard",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(cnt);
                      Navigator.pop(context);
                    },
                  ),
                  CupertinoDialogAction(
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.green),
                    ),
                    onPressed: () {
                      Navigator.pop(cnt);
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<_AvailableEquipments>(
          future: _availableEquipments.fetchAvailableEquipments(id),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            } else if (snapshot.hasData) {
              return _EquipmentAttachmentBox(
                equipIds: equipIds,
                equipments: snapshot.data!.equipments,
                id: id,
              );
            } else {
              return const SizedBox();
            }
          }),
    );
  }
}

class _EquipmentAttachmentBox extends StatefulWidget {
  final List<_Equipment> equipments;
  final List<int> equipIds;
  final int id;

  const _EquipmentAttachmentBox({
    Key? key,
    required this.equipments,
    required this.id,
    required this.equipIds,
  }) : super(key: key);
  @override
  State<_EquipmentAttachmentBox> createState() =>
      _EquipmentAttachmentBoxState();
}

class _EquipmentAttachmentBoxState extends State<_EquipmentAttachmentBox> {
  List<int> selectedIds = [];

  @override
  void initState() {
    selectedIds = widget.equipIds;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                    childAspectRatio: 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20),
                itemCount: widget.equipments.length,
                itemBuilder: (BuildContext context, int index) {
                  var attachment = widget.equipments[index];
                  return Column(
                    children: [
                      Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: BoxShadows.dropShadow(context),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: attachment.image,
                                  width: double.infinity,
                                  height: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                if (selectedIds.contains(attachment.id)) {
                                  selectedIds.remove(attachment.id);
                                } else {
                                  selectedIds.add(attachment.id);
                                }
                                setState(() => selectedIds);
                              },
                              style: TextButtonStyles.overlayButtonStyle(),
                              child: const SizedBox(
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                            Visibility(
                              visible: selectedIds.contains(attachment.id),
                              child: Positioned(
                                top: 0,
                                right: 0,
                                child: AEMPLIcon(
                                  AEMPLIcons.verified,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        attachment.name,
                        maxLines: 1,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  );
                },
              ),
            ),
            Center(
              child: TextButton(
                onPressed: () async {
                  if (await _AvailableEquipments.update(
                    context,
                    equipIds: selectedIds,
                    id: widget.id,
                  )) {
                    AttachmentDetailsModel attachmentDetailsModel =
                        AttachmentDetailsModel();
                    await attachmentDetailsModel.fetchAttachmentDetails(
                      context,
                      widget.id,
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text("Update"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
