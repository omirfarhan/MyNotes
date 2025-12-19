import 'package:flutter/cupertino.dart';
import 'package:miniappflutter/utilities/dialoge/generic_dialoge.dart';

Future<bool> showLogoutDialoge(BuildContext context){
  return showGenericDialoge(
      context: context,
      title: 'Sign Out',
      content: 'Are you sure you want to signout?',
      optionBuilder: () => {
        'Cancel': false,
        'Log Out': true
      },
  ).then((value) => value ?? false,);
}