import 'package:flutter/cupertino.dart';
import 'package:miniappflutter/utilities/dialoge/generic_dialoge.dart';

Future<bool> showDeleteDialoge(BuildContext context){
  return showGenericDialoge(
      context: context,
      title: 'Delete this item',
      content: 'Are you sure this item is deleted?',
      optionBuilder: () => {
        'Cancel' : false,
        'Delete' : true,
      },
  ).then((value) => value ?? false,);

}