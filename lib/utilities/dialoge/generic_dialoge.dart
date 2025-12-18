
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

typedef DialogeOptionBuilder<T> = Map<String, T?> Function();

Future<T?> showGenericDialoge<T> ({
  required BuildContext context,
  required String title,
  required String content,
  required DialogeOptionBuilder optionBuilder,
}) {
  final  option = optionBuilder();

  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: option.keys.map( (optionTitle) {
            final value =option[optionTitle];

            return TextButton(
                onPressed: () {
                  if(value != null){
                    Navigator.of(context).pop(value);
                  }else{
                    Navigator.of(context).pop();
                  }
                },
                child: Text(optionTitle) );

          }).toList(),
        );
      },
  );

}