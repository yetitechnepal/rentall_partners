import 'package:flutter/material.dart';
import 'package:rental_partners/Theme/button.dart';
import 'package:rental_partners/Theme/dropshadows.dart';

class AEMPLTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final Widget? prefix, suffix;
  final double? paddingRight, margin;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final int? maxLines;
  final String? Function(String?)? validator;
  final bool obscureText, autofocus, disabled;
  final Function(String)? onSubmit, onChanged;
  final int? maxLength;

  const AEMPLTextField({
    Key? key,
    this.controller,
    this.hintText,
    this.margin,
    this.prefix,
    this.suffix,
    this.paddingRight,
    this.keyboardType,
    this.maxLines,
    this.validator,
    this.autofocus = false,
    this.obscureText = false,
    this.textInputAction = TextInputAction.next,
    this.onSubmit,
    this.onChanged,
    this.disabled = false,
    this.maxLength,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: margin ?? 16, vertical: 0),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0)
          .copyWith(right: 0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        textInputAction: textInputAction,
        autofocus: autofocus,
        enabled: !disabled,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 13),
          hintText: hintText,
          isDense: true,
          prefixIconConstraints: const BoxConstraints(maxHeight: 20),
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: paddingRight ?? 10.0),
            child: prefix,
          ),
          suffixIconConstraints: const BoxConstraints(minWidth: 20),
          suffixIcon: Material(
            color: Colors.transparent,
            child: suffix,
          ),
          counterText: "",
        ),
        maxLength: maxLength,
        onChanged: onChanged,
        obscureText: obscureText,
        validator: validator,
        onFieldSubmitted: onSubmit,
      ),
    );
  }
}

Widget textFieldText(String title) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    child: Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
    ),
  );
}

class AEMPLPopUpButton extends StatelessWidget {
  final String hintText;
  final String? value;
  final Widget? prefix;
  final Function()? onPressed;

  const AEMPLPopUpButton({
    Key? key,
    this.hintText = "",
    this.prefix,
    this.onPressed,
    this.value,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      decoration: BoxDecoration(
        color: onPressed == null
            ? Theme.of(context).disabledColor
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(13),
        boxShadow: BoxShadows.dropShadow(context),
      ),
      child: TextButton(
        onPressed: onPressed,
        style: TextButtonStyles.overlayButtonStyle().copyWith(
          foregroundColor: MaterialStateProperty.all(
            Theme.of(context).textTheme.bodyText1!.color,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          child: Row(
            children: [
              prefix != null
                  ? Padding(
                      padding: const EdgeInsets.only(right: 10), child: prefix)
                  : const SizedBox(),
              Expanded(
                child: Text(
                  value ?? hintText,
                  style: TextStyle(
                    color: value == null
                        ? Colors.grey[700]
                        : Theme.of(context).textTheme.bodyText1!.color,
                  ),
                ),
              ),
              RotatedBox(
                quarterTurns: 3,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.grey[700],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
