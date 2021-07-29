import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/utils/utils.dart';

class FirebaseApi {
  static Future<String> createUser(Usuario usuario) async {
    final docUser = FirebaseFirestore.instance.collection('users').doc();

    usuario.id = docUser.id;

    await docUser.set(usuario.toMap());

    return docUser.id;
  }

  static Stream<List<Usuario>> readUsers() => FirebaseFirestore.instance
      .collection('users')
      .orderBy('nome', descending: false)
      .snapshots()
      .transform(Utils.transformer(Usuario.fromMap));

  static Future<ApiResponse> updateUser(Usuario usuario) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(usuario.id);

    await docUser.update(usuario.toMap());
  }

  static Future deleteUser(Usuario usuario) async {
    final docUser =
        FirebaseFirestore.instance.collection('users').doc(usuario.id);
    await docUser.delete();
  }
}
