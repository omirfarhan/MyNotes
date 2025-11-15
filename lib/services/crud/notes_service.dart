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

  Future<DatabaseNote> updateNote({required DatabaseNote note, required String text}) async {
    final db=_getDatabaseorThrow();
    await getNote(id: note.id);
    final updatecount=await db.update(noteTable, {
      textcolumn: text,
      isSyncedwithCloud: 0,
    });

    if(updatecount==0){
      throw couldNotUpdateNote();
    }else{
      return await getNote(id: note.id);
    }

  }

  Future< Iterable<DatabaseNote> > getallNotes() async{
    final db=_getDatabaseorThrow();
    final notes=await db.query(noteTable);

    // here code could not complete
   return notes.map((noteRow) =>DatabaseNote.fromRow(noteRow) );
  }

  Future<DatabaseNote> getNote({ required int id}) async{
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
      return DatabaseNote.fromRow(notes.first);
    }

  }

  Future<int> deleteallNotes() async {
    final db=_getDatabaseorThrow();
    return await db.delete(noteTable);
  }

  Future<void> deleteNote({required int id})async{
    final db =_getDatabaseorThrow();
    final deleteCount=await db.delete(
        noteTable,
      where: 'id = ?',
      whereArgs: [id],

    );

    if(deleteCount==0){
      throw couldNotDeleteUser();
    }

  }

  Future<DatabaseNote> createNote({required DatabaseUser owner})async{

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

    return note;

  }

  Future<DatabaseUser> getUser({required String email}) async{
    final db=_getDatabaseorThrow();
    final result=await db.query(
        userTable,
      limit: 1,
      where:  'email=?',
      whereArgs: [email.toLowerCase()],
    );

    if(result.isEmpty){
      throw couldNotFindeUser();
    }else{
      return DatabaseUser.fromRow(result.first);
    }

  }


  Future<DatabaseUser> createUser({ required String email })async{

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

  DatabaseUser.fromRow(Map<String, Object?> map) : id=map[idColumn] as int,
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

  DatabaseNote.fromRow(Map<String,Object?> map) :
  id=map[idColumn] as int,
  text=map[emailColumn] as String,
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
const isSyncedwithCloud='isSynced_with_email';
