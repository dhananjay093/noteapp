import 'package:flutter/cupertino.dart';
import 'package:newapp/pages/utilities/dailog/generic_dailog.dart';

Future<bool> showLogOutDialog(BuildContext context){
  return showGenericDialog<bool>(context: context, title: 'Log Out', content: 'Are you sure you want to log out?', optionsBuilder: () => {
    'ok': true,
    'cancel': false,
  }).then((value) => value ?? false,);
}