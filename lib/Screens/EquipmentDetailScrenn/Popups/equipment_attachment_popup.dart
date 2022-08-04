import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_detail_model.dart';
import 'package:rental_partners/Screens/EquipmentDetailScrenn/Model/equipment_link_attachments.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';
import 'package:rental_partners/Utils/image_icon.dart';
import 'package:rental_partners/Utils/loading_widget.dart';

Future showEquipmentAttachmentPopup(
    BuildContext context, List<EquipmentAttractmentModel> attachments, int id) {
  return showGeneralDialog(
    context: context,
    pageBuilder: (ctx, a, aa) {
      return _EquipmentAttachmentBoxx(attachments: attachments, id: id);
    },
  );
}

class _EquipmentAttachmentBoxx extends StatelessWidget {
  final int id;

  final EquipmentAttachments _equipmentAttachments = EquipmentAttachments();

  final List<EquipmentAttractmentModel> attachments;

  _EquipmentAttachmentBoxx({
    Key? key,
    required this.attachments,
    required this.id,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: loader(context),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Link Attachment".toUpperCase()),
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
        body: FutureBuilder<EquipmentAttachments>(
            future: _equipmentAttachments.fetchAttachments(id),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              } else if (snapshot.hasData) {
                return _EquipmentAttachmentBox(
                  attachments: attachments,
                  linkingAttachments: snapshot.data!.attachments,
                  id: id,
                );
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}

class _EquipmentAttachmentBox extends StatefulWidget {
  final List<EquipmentAttractmentModel> attachments;
  final List<EquipmentAttachment> linkingAttachments;
  final int id;

  const _EquipmentAttachmentBox({
    Key? key,
    required this.attachments,
    required this.id,
    required this.linkingAttachments,
  }) : super(key: key);
  @override
  State<_EquipmentAttachmentBox> createState() =>
      _EquipmentAttachmentBoxState();
}

class _EquipmentAttachmentBoxState extends State<_EquipmentAttachmentBox> {
  List<int> selectedIds = [];

  @override
  void initState() {
    for (var element in widget.attachments) {
      selectedIds.add(element.id);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: GridView.builder(
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 200,
                  childAspectRatio: 1,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20),
              itemCount: widget.linkingAttachments.length,
              itemBuilder: (BuildContext context, int index) {
                var attachment = widget.linkingAttachments[index];
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
                                placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator()),
                                errorWidget: (_, __, ___) => Image.asset(
                                    "assets/images/placeholder.png"),
                              ),
                            ),
                          ),
                          Container(
                            color:
                                Theme.of(context).brightness == Brightness.light
                                    ? Colors.transparent
                                    : Colors.black26,
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
                EquipmentAttachments _equipmentAttachments =
                    EquipmentAttachments();
                if (await _equipmentAttachments.update(
                    context, selectedIds, widget.id)) {
                  EquipmentDetailModel equipmentDetailModel =
                      EquipmentDetailModel();
                  await equipmentDetailModel.fetchEquipmentDetail(
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
    );
  }
}
