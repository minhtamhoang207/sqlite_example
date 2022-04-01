import 'package:flutter/material.dart';

import 'db_helper.dart';
import 'note_model.dart';

class InsertNotePage extends StatefulWidget {
  final Note? note;
  const InsertNotePage({Key? key, this.note}) : super(key: key);

  @override
  _InsertNotePageState createState() => _InsertNotePageState();
}

class _InsertNotePageState extends State<InsertNotePage> {

  final dbHelper = DatabaseHelper.instance;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();


  @override
  void initState() {
    if(widget.note != null){
      titleController.text = widget.note!.title;
      contentController.text = widget.note!.content;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('enter your note :D'),
        automaticallyImplyLeading: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Note title:'),
          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              hintText: 'enter note title here'
            ),
          ),
          const SizedBox(height: 100),

          const Text('Note content'),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(
                hintText: 'enter note content here'
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if(titleController.text.isNotEmpty || contentController.text.isNotEmpty){
            widget.note != null?
            await dbHelper.update(
                Note(id: widget.note!.id, title: titleController.text, content: contentController.text)
            ):
            await dbHelper.createNote(
                Note(title: titleController.text, content: contentController.text)
            );
            Navigator.pop(context);
          }
        },
        child: const Icon(Icons.save),
      ),
    );
  }
}
