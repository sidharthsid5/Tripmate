import 'package:flutter/material.dart';

class ActionButtonModel {
  late final VoidCallback onPress;
  late final BuildContext context;
  late final String text;
  ActionButtonModel({
    String? text,
    required this.onPress,
    required this.context,
  }) {
    this.text = text ?? "Ok";
  }
}

class CustomAlert {
  /// Show Success Message
  static void successMessage(String? message, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      backgroundColor: Colors.green,
      content: Text(message ?? "No Message"),
      duration: const Duration(seconds: 3),
      // action: SnackBarAction(
      //   label: 'Ok',
      //   onPressed: () {
      //     Navigator.pop(context);
      //   },
      // ),
    ));
  }

  /// Show Error Message
  static void errorMessage(String? title, BuildContext context,
      {String? subTitle, String? appbarTitle, ActionButtonModel? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(title ?? "No Message"),
        action: action != null
            ? SnackBarAction(
                label: action.text,
                onPressed: action.onPress,
              )
            : null,
      ),
    );
  }

  /// Show Warning Message
  static void warningMessage(String? title, BuildContext context,
      {ActionButtonModel? action}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.orange,
        content: Text(title ?? "No Message"),
        action: action != null
            ? SnackBarAction(
                label: action.text,
                onPressed: action.onPress,
              )
            : null,
      ),
    );
  }
}
