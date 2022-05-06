import 'package:flutter/material.dart';

enum AEMPLIcons {
  equipment,
  attachment,
  home,
  search,
  add,
  camera,
  price,
  category,
  description,
  dimension,
  weight,
  model,
  drop,
  filter,
  email,
  password,
  profile,
  trash,
  verified,
  link,
  lock,
  edit,
  delete,
  state,
  country,
  location,
  numbers,
  notification,
  operator,
}

_getAssetImage(AEMPLIcons icon) {
  String imagePath = "";
  if (icon == AEMPLIcons.equipment) {
    imagePath = "assets/icons/equipment.png";
  } else if (icon == AEMPLIcons.attachment) {
    imagePath = "assets/icons/attachment.png";
  } else if (icon == AEMPLIcons.home) {
    imagePath = "assets/icons/home.png";
  } else if (icon == AEMPLIcons.search) {
    imagePath = "assets/icons/search.png";
  } else if (icon == AEMPLIcons.add) {
    imagePath = "assets/icons/add.png";
  } else if (icon == AEMPLIcons.price) {
    imagePath = "assets/icons/price.png";
  } else if (icon == AEMPLIcons.category) {
    imagePath = "assets/icons/category.png";
  } else if (icon == AEMPLIcons.description) {
    imagePath = "assets/icons/description.png";
  } else if (icon == AEMPLIcons.dimension) {
    imagePath = "assets/icons/dimension.png";
  } else if (icon == AEMPLIcons.weight) {
    imagePath = "assets/icons/weight.png";
  } else if (icon == AEMPLIcons.model) {
    imagePath = "assets/icons/model.png";
  } else if (icon == AEMPLIcons.drop) {
    imagePath = "assets/icons/dropdown.png";
  } else if (icon == AEMPLIcons.filter) {
    imagePath = "assets/icons/filter.png";
  } else if (icon == AEMPLIcons.email) {
    imagePath = "assets/icons/email.png";
  } else if (icon == AEMPLIcons.password) {
    imagePath = "assets/icons/password.png";
  } else if (icon == AEMPLIcons.profile) {
    imagePath = "assets/icons/profile.png";
  } else if (icon == AEMPLIcons.trash) {
    imagePath = "assets/icons/trash.png";
  } else if (icon == AEMPLIcons.camera) {
    imagePath = "assets/icons/camera.png";
  } else if (icon == AEMPLIcons.verified) {
    imagePath = "assets/icons/verified.png";
  } else if (icon == AEMPLIcons.link) {
    imagePath = "assets/icons/link.png";
  } else if (icon == AEMPLIcons.lock) {
    imagePath = "assets/icons/lock.png";
  } else if (icon == AEMPLIcons.edit) {
    imagePath = "assets/icons/edit.png";
  } else if (icon == AEMPLIcons.delete) {
    imagePath = "assets/icons/delete.png";
  } else if (icon == AEMPLIcons.state) {
    imagePath = "assets/icons/state.png";
  } else if (icon == AEMPLIcons.location) {
    imagePath = "assets/icons/location.png";
  } else if (icon == AEMPLIcons.country) {
    imagePath = "assets/icons/country.png";
  } else if (icon == AEMPLIcons.numbers) {
    imagePath = "assets/icons/numbers.png";
  } else if (icon == AEMPLIcons.notification) {
    imagePath = "assets/icons/notification.png";
  } else if (icon == AEMPLIcons.operator) {
    imagePath = "assets/icons/operator.png";
  }

  return AssetImage(imagePath);
}

// ignore: non_constant_identifier_names
class AEMPLIcon extends StatelessWidget {
  final AEMPLIcons icon;
  final Color? color;
  final double? size;
  final String? semanticLabel;

  // ignore: use_key_in_widget_constructors
  const AEMPLIcon(this.icon, {this.color, this.size, this.semanticLabel});

  @override
  Widget build(BuildContext context) {
    return ImageIcon(
      _getAssetImage(icon),
      color: color,
      size: size,
      semanticLabel: semanticLabel,
    );
  }
}
