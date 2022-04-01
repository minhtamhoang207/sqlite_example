import 'package:flutter/material.dart';
import 'package:sqlite_example/insert_note.dart';
import 'package:sqlite_example/note_model.dart';
import 'db_helper.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // reference to our single class that manages the database
  final dbHelper = DatabaseHelper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('sqflite'),
      ),
      body: FutureBuilder<List<Note>>(
        future: dbHelper.getAllNote(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data!.isEmpty
                ? const Center(child: Text('Chưa có note hãy thêm mới nha :D'))
                : ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onDoubleTap: () async {
                          await dbHelper.delete(
                              id: snapshot
                                  .data![snapshot.data!.length - 1 - index]
                                  .id!);
                          setState(() {});
                        },
                        onTap: () async {
                          await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => InsertNotePage(
                                        note: snapshot.data![
                                            snapshot.data!.length - 1 - index],
                                      )));
                          setState(() {});
                        },
                        child: Container(
                          margin: const EdgeInsets.all(20),
                          padding: const EdgeInsets.all(20),
                          decoration:
                              const BoxDecoration(color: Colors.blueAccent),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                snapshot
                                    .data![snapshot.data!.length - 1 - index]
                                    .title,
                                style: const TextStyle(color: Colors.white),
                              ),
                              Text(
                                snapshot
                                    .data![snapshot.data!.length - 1 - index]
                                    .content,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Đã xảy ra lỗi zui lòng thử lại sau :D"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context,
              MaterialPageRoute(builder: (context) => const InsertNotePage()));
          setState(() {});
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
