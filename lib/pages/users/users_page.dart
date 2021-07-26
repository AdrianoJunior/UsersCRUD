import 'package:flutter/material.dart';
import 'package:users_crud/pages/users/users_list_view.dart';
import 'package:users_crud/pages/users/usuario.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  List<Usuario> users = [
    Usuario(
      nome: "Teste 01",
      email: "teste01@gmail.com",
      senha: "123456",
      uid: "sjaknasjknd",
      dataNascimento: DateTime.utc(1998, 06, 13),
    ),

    Usuario(
      nome: "Teste 02",
      email: "teste02@gmail.com",
      senha: "123456",
      uid: "sjaknasjknd",
      dataNascimento: DateTime.utc(1998, 06, 13),
    ),

    Usuario(
      nome: "Teste 03",
      email: "teste03@gmail.com",
      senha: "123456",
      uid: "sjaknasjknd",
      dataNascimento: DateTime.utc(1998, 06, 13),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
    );
  }

  _body() {
    return UsersListView(users: users);
  }
}
