import 'package:flutter/material.dart';
import 'package:miniappflutter/services/crud/notes_service.dart';

import '../utilities/dialoge/delete_dialoge.dart';

typedef DeleteNotecallback=void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final DeleteNotecallback onDeleteNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note=notes[index];
        return ListTile(

          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,

          ),

          trailing: IconButton(
              onPressed: () async {
                final Deletedialoge= await showDeleteDialoge(context);
                if(Deletedialoge){
                  onDeleteNote(note);
                }

              }, icon: const Icon(Icons.delete),
          ),



        );
      },
    );
  }
}
