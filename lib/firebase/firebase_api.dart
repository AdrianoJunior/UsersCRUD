import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseApi {
  /*static Future<String> createTodo(Todo todo, String uid) async {
    final docTodo =
        FirebaseFirestore.instance.collection('users/$uid/todos').doc();

    todo.id = docTodo.id;

    await docTodo.set(todo.toMap());

    return docTodo.id;
  }

  static Stream<List<Todo>> readTodos(String uid) => FirebaseFirestore.instance
      .collection('users/$uid/todos')
      .orderBy(TodoField.createdTime, descending: true)
      .snapshots()
      .transform(Utils.transformer(Todo.fromMap));

  static Future updateTodo(Todo todo, String uid) async {
    final docTodo =
        FirebaseFirestore.instance.collection('users/$uid/todos').doc(todo.id);

    await docTodo.update(todo.toMap());
  }

  static Future deleteTodo(Todo todo, String uid) async {
    final docTodo =
        FirebaseFirestore.instance.collection('users/$uid/todos').doc(todo.id);

    await docTodo.delete();
  }*/
}
