import 'package:flutter/material.dart';
import 'package:users_crud/firebase/firebase_api.dart';
import 'package:users_crud/pages/users/usuario.dart';

class UsersProvider extends ChangeNotifier {
  List<Usuario> _users = [];

  List<Usuario> get users =>
      _users.where((usuario) => usuario.id != null).toList();

  void setUsers(List<Usuario> users) =>
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _users = users;
        notifyListeners();
      });

  Future<void> addUser(Usuario usuario) => FirebaseApi.createUser(usuario);

  void removeUser(Usuario usuario) => FirebaseApi.deleteUser(usuario);

  void updateUser(Usuario usuario) {
    FirebaseApi.updateUser(usuario);
  }
}
