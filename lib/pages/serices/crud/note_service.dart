import 'dart:html';
import 'package:newapp/pages/serices/crud/crud_exception.drat';
import 'package:flutter/cupertino.dart';
import 'package:newapp/pages/serices/auth/authexceptions.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' show join;



class UnableToGetDocumentDirectory {}

class NotesService {
  Database? _db;

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();
    //await getNote(id: note.id);
    final updateCount = await db.update(notetable, {
      textcolumn: text,
    });
    if (updateCount == 0) {
      throw CoulNotUpdateNote();
    }
    else {
      return await getNote(id: note.id);
    }
  }

  Future<Iterable<DatabaseNote>> getAllNote() async {
    final db = _getDatabaseOrThrow();
    final note = await db.query(
      notetable,
    );
    return note.map((noteRow) => DatabaseNote.fromrow(noteRow));
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final note = await db.query(
      notetable,
      limit: 1,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (note.isEmpty) {
      throw CouldNotFindNote();
    } else {
      return DatabaseNote.fromrow(note.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(notetable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletecount = await db.delete(
      notetable,
      where: 'id= ?',
      whereArgs: [id],
    );
    if (deletecount == 0) {
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNote> CreateNote({required DatabaseUser owner}) async {
    final db = _getDatabaseOrThrow();
    final dbuser = getUser(email: owner.email);
    if (dbuser != owner) {
      throw CouldNotFindUser();
    }
    const text = '';

    final noteid = await db.insert(notetable, {
      userIdcolumn: owner.id,
      textcolumn: text,
    });
    final note = DatabaseNote(id: noteid, userId: owner.id, text: text);
    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usertable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isEmpty) {
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromrow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      usertable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (results.isNotEmpty) {
      throw UserAlreadyExists();
    }
    final userId = await db.insert(
      usertable,
      {emailcolumn: email.toLowerCase()},
    );

    return DatabaseUser(id: userId, email: email);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletecount = await db.delete(
      usertable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletecount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      return db;
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpenException();
    } else {
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docspath = await getApplicationDocumentsDirectory();
      final dbpath = join(docspath.path, dbname);
      final db = await openDatabase(dbpath);
      _db = db;

      await db.execute(createUserTable);
      await db.execute(createNoteTable);
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentDirectory();
    }
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;
  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromrow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        email = map[emailcolumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
  });
  DatabaseNote.fromrow(Map<String, Object?> map)
      : id = map[idcolumn] as int,
        userId = map[userIdcolumn] as int,
        text = map[textcolumn] as String;

  @override
  String toString() => 'note, $id, $userId, ';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const idcolumn = 'id';
const emailcolumn = 'email';
const textcolumn = 'text';
const userIdcolumn = 'user_id';
const dbname = 'test.db';
const notetable = 'note';
const usertable = 'user';
const createNoteTable = '''CREATE TABLE "Note" (
	"id"	INTEGER NOT NULL,
	"user_id"	INTEGER NOT NULL,
	"text"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT),
	FOREIGN KEY("user_id") REFERENCES "user"("Id")
);
''';
const createUserTable = '''CREATE TABLE "user" (
	"Id"	INTEGER NOT NULL,
	"Email"	TEXT NOT NULL UNIQUE,
	PRIMARY KEY("Id" AUTOINCREMENT)
);
''';
