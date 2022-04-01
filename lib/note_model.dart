class Note{
  int? id;
  String title = '';
  String content = '';

  Note({this.id, required this.title, required this.content});

  Note.fromMap(Map map) {
    id = map['_id'];
    title = map['title'];
    content = map['content'];
  }
}