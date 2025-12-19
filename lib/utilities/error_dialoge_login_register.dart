import 'package:flutter/cupertino.dart';
import 'package:miniappflutter/utilities/dialoge/generic_dialoge.dart';

Future<void>showErrorDialoge(
   BuildContext context, String text
) {
  return showGenericDialoge(
      context: context, title: 'An error occured',
      content: text,
      optionBuilder: () => {
        'ok': null
      },
  );
}