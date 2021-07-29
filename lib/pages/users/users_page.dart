import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_crud/firebase/firebase_api.dart';
import 'package:users_crud/firebase/firebase_service.dart';
import 'package:users_crud/pages/login/login_page.dart';
import 'package:users_crud/pages/users/add_user_page.dart';
import 'package:users_crud/pages/users/users_list_view.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/provider/users_provider.dart';
import 'package:users_crud/utils/nav.dart';

class UsersPage extends StatefulWidget {
  @override
  _UsersPageState createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuários"),
        actions: [
          PopupMenuButton<String>(
            onSelected: _handleClick,
            itemBuilder: (BuildContext context) {
              return {'Logout'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          push(context, AddUserPage());
        },
        child: Icon(
          Icons.person_add,
          color: Colors.white,
        ),
      ),
    );
  }

  _body() {
    return StreamBuilder<List<Usuario>>(
        stream: FirebaseApi.readUsers(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return Center(child: CircularProgressIndicator());
            default:
              if (snapshot.hasError) {
                print('ERRO >>>>>>>>>>> ${snapshot.error}');
                return buildText('Algo deu errado, tente novamente.',
                    color: Colors.red);
              } else if (!snapshot.hasData) {
                return Center(child: CircularProgressIndicator());
              }
              final users = snapshot.data ?? [];

              final provider = Provider.of<UsersProvider>(context);
              provider.setUsers(users);

              return UsersListView(users: users);
          }
        });
  }

  void _handleClick(String value) {
    switch (value) {
      case 'Logout':
        _onClickLogout();
        break;
    }
  }

  void _onClickLogout() async {
    await FirebaseService().logout();
    push(context, LoginPage(), replace: true);
  }

  Widget buildText(String text, {Color color = Colors.white}) => Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24, color: color),
        ),
      );
}
