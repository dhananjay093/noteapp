import 'package:flutter/cupertino.dart';
import 'package:newapp/pages/utilities/dailog/generic_dailog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog(
      context: context,
      title: 'An Error Occured',
      content: text,
      optionsBuilder: () => {
            'ok': null,
          });
}
