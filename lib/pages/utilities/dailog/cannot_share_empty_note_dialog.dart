import 'package:flutter/cupertino.dart';
import 'package:newapp/pages/utilities/dailog/generic_dailog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Share',
    content: 'You cannot share an empty note',
    optionsBuilder: () => {
      'ok': null,
    },
  );
}
