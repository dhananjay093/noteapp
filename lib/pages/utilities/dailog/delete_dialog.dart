import 'package:flutter/cupertino.dart';
import 'package:newapp/pages/utilities/dailog/generic_dailog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
      context: context,
      title: 'Delete',
      content: 'Are you sure you want to delete this note?',
      optionsBuilder: () => {
            'Cancel': false,
            'Yes': true,
          }).then(
    (value) => value ?? false,
  );
}
