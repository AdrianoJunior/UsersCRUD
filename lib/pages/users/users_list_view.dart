import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/utils/alert.dart';

class UsersListView extends StatefulWidget {
  List<Usuario> users;

  UsersListView({@required this.users});

  @override
  _UsersListViewState createState() => _UsersListViewState();
}

class _UsersListViewState extends State<UsersListView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(16),
        itemCount: widget.users != null ? widget.users.length : 0,
        itemBuilder: (context, index) {
          Usuario user = widget.users[index];

          String dataNascimentoUser =
              DateFormat("dd/MM/yyyy").format(user.dataNascimento);

          return ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Slidable(
              actionPane: SlidableDrawerActionPane(),
              actions: [
                IconSlideAction(
                  color: Colors.green,
                  onTap: () {},
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
                        setState(() {
                          widget.users.remove(user);
                        });
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
                    children: [
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
                            dataNascimentoUser ??
                                "Data de nascimento do usuário",
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
          );
        },
      ),
    );
  }

  _onClickUser(BuildContext context, Usuario user) {}
}
