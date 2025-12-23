import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:miniappflutter/services/auth/auth_services.dart';
import 'package:miniappflutter/services/auth/auth_user.dart';
import 'package:miniappflutter/services/crud/notes_service.dart';
import 'package:miniappflutter/utilities/generics/get_arguments.dart';

class CreateUpdateNote extends StatefulWidget {
  const CreateUpdateNote({super.key});

  @override
  State<CreateUpdateNote> createState() => _CreateUpdateNoteState();
}

class _CreateUpdateNoteState extends State<CreateUpdateNote> {

  DatabaseNote? _note;

  late final NoteServices _noteServices;
  late final TextEditingController _textcontroller;

  Future<DatabaseNote> createNote(BuildContext context)async{

    final widgetNote=context.arguments<DatabaseNote>();
    if(widgetNote != null){
      _note = widgetNote;
      _textcontroller.text=widgetNote.text;
      return widgetNote;
    }

    final existingNote=_note;

    if(existingNote != null){
      return existingNote;
    }

    final currentUser=  AuthServices.firebase().currentuser!;
    final email= currentUser.Email!;
    final owner=await _noteServices.getUser(email: email);
    final newnote= await _noteServices.createNote(owner: owner);
    _note=newnote;
    return newnote;

  }

  void _deleteNoteifTextIsEmpty(){
    final note=_note;

    if(_textcontroller.text.isEmpty && note != null){
      _noteServices.deleteNote(id: note.id);
    }

  }

  void saveNoteifTextNoteEmpty() async{
    final note =_note;
    final text= _textcontroller.text;

    if(note != null && text.isNotEmpty){
      await _noteServices.updateNote(note: note, text: text);
    }

  }

  void _textControllerListener() async{
    final note=_note;
    if(note == null){
      return;
    }

    final text=_textcontroller.text;
    await _noteServices.updateNote(note: note, text: text);

  }

  void _setupTextControllerlistener(){
    _textcontroller.removeListener(_textControllerListener);
    _textcontroller.addListener(_textControllerListener);
  }


  @override
  void initState() {
    _noteServices=NoteServices();
    _textcontroller=TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    saveNoteifTextNoteEmpty();
    _deleteNoteifTextIsEmpty();
    _textcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: const Text('New Note'),
      ),
      body: FutureBuilder(
          future: createNote(context),
          builder: (context, snapshot) {
            switch(snapshot.connectionState){

              case ConnectionState.done:

                _setupTextControllerlistener();

                return TextField(
                  controller: _textcontroller,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: 'Start type your note'
                  ),
                );

              default:
                return const CircularProgressIndicator();
            }
          },
      ),

    );
  }
}
