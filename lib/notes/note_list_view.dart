import 'package:flutter/material.dart';
import 'package:miniappflutter/services/crud/notes_service.dart';

import '../utilities/dialoge/delete_dialoge.dart';

typedef Notecallback=void Function(DatabaseNote note);

class NotesListView extends StatelessWidget {
  final List<DatabaseNote> notes;
  final Notecallback onDeleteNote;
  final Notecallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note=notes[index];
        return ListTile(
          onTap: () {
            onTap(note);

          },

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
