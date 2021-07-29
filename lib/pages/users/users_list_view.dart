import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:users_crud/pages/users/edit_user_page.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/provider/users_provider.dart';
import 'package:users_crud/utils/alert.dart';
import 'package:users_crud/utils/nav.dart';
import 'package:users_crud/utils/utils.dart';

class UsersListView extends StatelessWidget {
  List<Usuario> users;

  UsersListView({@required this.users});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: users != null ? users.length : 0,
        itemBuilder: (context, index) {
          Usuario user = users[index];

          DateTime dataNascimento = DateTime.fromMillisecondsSinceEpoch(
              user.dataNascimento.millisecondsSinceEpoch);

          return InkWell(
            onTap: () => _onClickUser(context),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Slidable(
                actionPane: SlidableDrawerActionPane(),
                actions: [
                  IconSlideAction(
                    color: Colors.green,
                    onTap: () {
                      push(context, EditUserPage(usuario: user));
                    },
                    caption: 'Editar',
                    icon: Icons.edit,
                  ),
                ],
                secondaryActions: [
                  IconSlideAction(
                    color: Colors.red,
                    caption: 'Excluir',
                    onTap: () {
                      alertCancel(
                        context,
                        "Deseja excluir o usuário: ${user.nome}?"
                        "\nA ação não pode ser desfeita",
                        callback: () {
                          deleteUser(context, user);
                        },
                      );
                    },
                    icon: Icons.delete,
                  ),
                ],
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  color: Colors.grey[100],
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 16),
                          child: Image.asset(
                            'assets/images/default_image.png',
                            width: 50,
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              user.nome ?? "Nome do usuário",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 25,
                              ),
                            ),
                            Text(
                              dataNascimento != null
                                  ? DateFormat('dd/MM/yyyy')
                                      .format(dataNascimento)
                                  : "Data de nascimento do usuário",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              user.email ?? "E-mail do usuário",
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void deleteUser(BuildContext context, Usuario user) {
    final provider = Provider.of<UsersProvider>(context, listen: false);
    provider.removeUser(user);

    Utils.showSnackBar(
        context, 'O usuário ${user.nome} foi excluido com sucesso.');
  }

  void _onClickUser(BuildContext context) {
    alert(context,
        "Para excluir um usuário deslize o card para a esquerda.\nPara editar, deslize para a direita.");
  }
}
