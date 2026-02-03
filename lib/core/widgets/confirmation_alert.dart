import 'package:flutter/material.dart';
import 'package:workspace/core/constants/app_dimensions.dart';

class ConfirmationAlertDialog {
  final void Function()? onPressed;
  final String button1;
  final String button2;
  final String confirmationMessage;

  const ConfirmationAlertDialog({
    this.onPressed,
    required this.button1,
    required this.button2,
    required this.confirmationMessage,
  });

  static Future<bool?> showConfirmation(
    BuildContext context, {
    final void Function()? onPressed,
    final String? button1,
    final String? button2,
    final IconData? icon,
    final String? confirmationMessage,
  }) {
    Widget cancelButton = TextButton(
      onPressed: () => Navigator.pop(context),
      child: Text(
        button1!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );

    Widget continueButton = TextButton(
      onPressed: onPressed,
      child: Text(
        button2!,
        style: TextStyle(
          color: Theme.of(context).colorScheme.error,
        ),
      ),
    );

    AlertDialog alert = AlertDialog(
      actions: [
        cancelButton,
        continueButton,
      ],
      title: Icon(
        icon,
        size: iconSize30,
        color: Theme.of(context).colorScheme.error,
      ),
      content: Text(
        confirmationMessage!,
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
