// import 'package:flutter/material.dart';
// import 'package:newapp/pages/serices/auth/auth_service.dart';
// import 'package:newapp/pages/serices/crud/note_service.dart';

// class NewNotesView extends StatefulWidget {
//   const NewNotesView({Key? key}) : super(key: key);

//   @override
//   State<NewNotesView> createState() => _NewNotesViewState();
// }

// class _NewNotesViewState extends State<NewNotesView> {
//   DatabaseNote? _note;
//   late final NotesService _notesService;
//   late final TextEditingController _textcontroller;

//   Future<DatabaseNote> createNewNote() async {
//     final existingNote = _note;
//     if (existingNote != null) {
//       return existingNote;
//     }
//     final currentUser = AuthService.firebase().currentuser!;
//     final email = currentUser.email!;
//     final owner = await _notesService.getUser(email: email);
//     return await _notesService.createNote(owner: owner);
//   }

//   void _deleteNoteIfTextIsEmpty() {
//     final note = _note;
//     if (_textcontroller.text.isEmpty && note != null) {
//       _notesService.deleteNote(id: note.id);
//     }
//   }

//   void _saveNotIfNotSaved() async {
//     final note = _note;
//     final text = _textcontroller.text;
//     if (note != null && text.isNotEmpty) {
//       await _notesService.updateNote(
//         note: note,
//         text: text,
//       );
//     }
//   }

//   void _textControllerListener() async {
//     final note = _note;
//     if (note == null) {
//       return;
//     }
//     final text = _textcontroller.text;
//     await _notesService.updateNote(
//       note: note,
//       text: text,
//     );
//   }

//   void _setupTextControllerListener() {
//     _textcontroller.removeListener(_textControllerListener);
//     _textcontroller.addListener(_textControllerListener);
//   }

//   @override
//   void dispose() {
//     _deleteNoteIfTextIsEmpty();
//     _saveNotIfNotSaved();
//     _textcontroller.dispose();

//     super.dispose();
//   }

//   @override
//   void initState() {
//     _notesService = NotesService();
//     _textcontroller = TextEditingController();
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('new note'),
//         ),
//         body: FutureBuilder(
//           future: createNewNote(),
//           builder: (context, snapshot) {
//             switch (snapshot.connectionState) {
//               case ConnectionState.done:
//                 _note = snapshot.data as DatabaseNote?;
//                 _setupTextControllerListener();
//                 return TextField(
//                   controller: _textcontroller,
//                   keyboardType: TextInputType.multiline,
//                   maxLines: null,
//                   decoration: const InputDecoration(
//                     hintText: 'Start typing your note......',
//                   ),
//                 );
//               default:
//                 return CircularProgressIndicator();
//             }
//           },
//         ));
//   }
// }

import 'package:flutter/material.dart';
import 'package:newapp/pages/serices/auth/auth_service.dart';
import 'package:newapp/pages/utilities/dailog/cannot_share_empty_note_dialog.dart';
import 'package:newapp/pages/utilities/dailog/generics/get_arguments.dart';
import 'package:newapp/pages/serices/cloud/clou_note.dart';
import 'package:newapp/pages/serices/cloud/cloud_storage_exception.dart';
import 'package:newapp/pages/serices/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentuser!;
    final userId = currentUser.id;

    final newNote = await _notesService.createNewNote(ownerUserId: userId);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Note'),
        actions: [
          IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share)),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setupTextControllerListener();
              return TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: const InputDecoration(
                  hintText: 'Start typing your note...',
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
