import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DatabaseAlreadyopenException implements Exception {}
class UnabletoGetDocuments implements Exception {}
class DatabaseIsNotOpen implements Exception {}
class couldNotDeleteUser implements Exception {}
class userAlreadyExists implements Exception {}
class couldNotFindeUser implements Exception {}
class couldNotFindNote implements Exception {}
class couldNotUpdateNote implements Exception {}


class NoteServices{
  Database? _db;

  List<DatabaseNote> _notes= [];

  static final NoteServices _shared=NoteServices._shareInstance();
  NoteServices._shareInstance(){
    _notesStreamController =StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  factory NoteServices() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  //final _notesStreamController=StreamController<List<DatabaseNote>>.broadcast();

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

  Future<void> ensureDbInopen() async{
    try{
      await open();
    }on DatabaseAlreadyopenException{

    }
  }

  Future<DatabaseUser> getorCreateuser({required String email}) async{
    try{
      final user=await getUser(email: email);
      return user;
    }on couldNotFindeUser{
      final createdUser=await createUser(email: email);
      return createdUser;
    } catch (e){
      rethrow;
    }
  }

  Future<void> _cacheNote()async{
    final allnotes=await getallNotes();
    _notes=allnotes.toList();
    _notesStreamController.add(_notes);
  }


  Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async {
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    await getNote(id: note.id);
    final updatecount=await db.update(noteTable, {
      textcolumn: text,
      isSyncedwithCloud: 0,
    });

    if(updatecount==0){
      throw couldNotUpdateNote();
    }else{
      final updateNote= await getNote(id: note.id);
      _notes.removeWhere((note) => note.id==updateNote.id);
      _notes.add(updateNote);
      _notesStreamController.add(_notes);
      return updateNote;
    }

  }

  Future< Iterable<DatabaseNote> > getallNotes() async{
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    final notes=await db.query(noteTable);


   return notes.map((noteRow) =>DatabaseNote.fromRow(noteRow) );
  }

  Future<DatabaseNote> getNote({ required int id}) async{
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    final notes=await db.query(
        noteTable,
      limit: 1,
      where: ' id = ? ',
      whereArgs: [id],
    );

    if(notes.isEmpty){
      throw couldNotFindNote();
    }else{
      final note= DatabaseNote.fromRow(notes.first);
      _notes.removeWhere((note) => note.id==id);
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }

  }

  Future<int> deleteallNotes() async {
    await ensureDbInopen();

    final db=_getDatabaseorThrow();
    final numberofDeletions= await db.delete(noteTable);
    _notes=[];
    _notesStreamController.add(_notes);
    return numberofDeletions;

  }



  Future<void> deleteNote({required int id})async{
    await ensureDbInopen();
    final db =_getDatabaseorThrow();
    final deleteCount=await db.delete(
        noteTable,
      where: 'id = ?',
      whereArgs: [id],

    );

    if(deleteCount==0){
      throw couldNotDeleteUser();
    }else{
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }

  }

  Future<DatabaseNote> createNote({required DatabaseUser owner})  async {
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    final dbuser=await getUser(email: owner.email);

    if(dbuser!=owner){
      throw couldNotFindeUser();
    }

    const text='';
    final noteId=await db.insert(
        noteTable, { userIdColumn: owner.id,
        textcolumn: text,
        isSyncedwithCloud: 1
        });

    final note=DatabaseNote(
        id: noteId,
        userId: owner.id,
        text: text,
        isSyncedwithcloud: true
    );

    _notes.add(note);
    _notesStreamController.add(_notes);


    return note;

  }

  Future<DatabaseUser> getUser ({ required String email }) async {
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    final result=await db.query(
      userTable,
      limit: 1,
      where:  ' email= ? ',
      whereArgs: [email.toLowerCase()],
    );

    if(result.isEmpty){
      throw couldNotFindeUser();
    }else{
      return DatabaseUser.fromRow(result.first);
    }

  }


  Future<DatabaseUser> createUser({ required String email })async{
    await ensureDbInopen();
    final db=_getDatabaseorThrow();
    final result=await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );

    if(result.isNotEmpty){
      throw userAlreadyExists();
    }

    final userId=await db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId, email: email);

  }

  Future<void> deleteUser({required String email}) async{
    await ensureDbInopen();

    final db=_getDatabaseorThrow();
    final deletecount= await db.delete(
      userTable,
      where: 'email = ? ',
      whereArgs: [email.toLowerCase()],
    );
    if(deletecount !=1){
      throw couldNotDeleteUser();
    }

  }

  Database  _getDatabaseorThrow(){
    final db=_db;
    if(db==null){
      throw DatabaseIsNotOpen();
    }else{
      return db;
    }
  }

  Future<void> close() async{
    final db=_db;

    if(db == null){
      throw  DatabaseIsNotOpen();
    }else{
      await db.close();
      _db=null;
    }

  }

  Future<void> open() async{
    if(_db != null){
      throw DatabaseAlreadyopenException();
    }else{
      try{
        final docsPath=await getApplicationDocumentsDirectory();
        final dbpath=join(docsPath.path,dbname);
        final db=await openDatabase(dbpath);
        _db=db;


        //create user table
        await db.execute(createUserTable);
        //create note table
        await db.execute(createNoteTable);
        await _cacheNote();


      }on  MissingPlatformDirectoryException{
        throw UnabletoGetDocuments();
      }
    }
  }
}



const createUserTable=''' CREATE TABLE IF NOT EXISTS "user" (
	          "id"	INTEGER NOT NULL,
	         "email"	TEXT NOT NULL UNIQUE,
	         PRIMARY KEY("id" AUTOINCREMENT
	         )
);  ''';

const createNoteTable=''' CREATE TABLE IF NOT EXISTS "note" (
	        "id"	INTEGER NOT NULL,
	        "user_id"	INTEGER NOT NULL,
	        "text"	TEXT,
	        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	         FOREIGN KEY("user_id") REFERENCES "user"("id"),
	         PRIMARY KEY("id" AUTOINCREMENT)
);  ''';

@immutable
class DatabaseUser{
  final int id;
  final String email;

  DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map) :
        id=map[idColumn] as int,
        email=map[emailColumn]  as String;

  @override
  String toString() => 'Person, ID=$id, email=$email';

  @override
  bool operator == (covariant DatabaseUser other) => id==other.id;

  @override
  int get hashCode => id.hashCode;


}



class DatabaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedwithcloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedwithcloud
  });

  // fromRow is defined DatabaseNote of constructor
  //mane fromRow holo DatabaseNote er constructor
  DatabaseNote.fromRow(Map<String,Object?> map) :
  id=map[idColumn] as int,
  text=map[textcolumn] as String,
  userId=map[userIdColumn] as int,

  isSyncedwithcloud=(map[isSyncedwithCloud] as int) ==1? true : false;

  @override
  String toString() => 'Note, ID=$id, user_id=$userId, isSyncedwithCloud=$isSyncedwithcloud, text=$text';

  @override
  bool operator == (covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

}

const dbname='notes.db';
const userTable='user';
const noteTable='note';

const idColumn='id';
const emailColumn='email';

const userIdColumn='user_id';
const textcolumn='text';
const isSyncedwithCloud='is_synced_with_cloud';
