import 'package:flutter/material.dart';
import 'package:notes/utilities/dialogs/generic_error_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: "Delete",
      content: "Are you sure you want to delete?",
      optionsBuilder: () => {
            "Delete": true,
            "Cancel": false,
          }).then((value) => value ?? false);
}
