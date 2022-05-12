import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:system_settings/system_settings.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

checkImagePermission(BuildContext context) async {
  PermissionState permission = await AssetPicker.permissionCheck();
  if (permission == PermissionState.restricted) {
    showCupertinoDialog(
      context: context,
      builder: (ctx) => CupertinoAlertDialog(
        title: const Text(
          "Permission for photos is permanently denied, want to add permission manually?",
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              "Yes",
              style: TextStyle(
                color: Colors.green,
              ),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              await SystemSettings.privacy();
            },
          ),
          CupertinoDialogAction(
            child: const Text(
              "Cancel",
              style: TextStyle(
                color: Colors.red,
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
            },
          ),
        ],
      ),
    );
  }
}
