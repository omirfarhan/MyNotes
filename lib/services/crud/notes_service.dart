import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

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


const idColumn='id';
const emailColumn='email';

const userIdColumn='user_id';
const isSyncedwithCloud='isSynced_with_email';
