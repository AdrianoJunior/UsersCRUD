import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_crud/pages/users/users_bloc.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/provider/users_provider.dart';
import 'package:users_crud/utils/alert.dart';
import 'package:users_crud/utils/nav.dart';
import 'package:users_crud/widgets/button_widget.dart';
import 'package:users_crud/widgets/text_input.dart';

class EditUserPage extends StatefulWidget {
  Usuario usuario;

  EditUserPage({@required this.usuario});

  @override
  _EditUserPageState createState() => _EditUserPageState();
}

class _EditUserPageState extends State<EditUserPage> {
  bool _showProgress = false;

  Usuario get usuario => widget.usuario;

  final _formKey = GlobalKey<FormState>();

  final _tNome = TextEditingController();

  final _focusData = FocusNode();

  final _bloc = UsersBloc();

  String dataNascimentoString;

  @override
  void initState() {
    super.initState();

    _tNome.text = usuario.nome;

    dataNascimentoString = DateTime.fromMillisecondsSinceEpoch(
            usuario.dataNascimento.millisecondsSinceEpoch)
        .toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Editar usuário"),
      ),
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              TextInput(
                hint: "Nome",
                icon: Icons.person,
                inputAction: TextInputAction.next,
                keyboardType: TextInputType.name,
                validator: (s) => _validateNome(s),
                controller: _tNome,
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: Colors.white,
                ),
                padding: EdgeInsets.only(left: 10),
                child: DateTimePicker(
                  type: DateTimePickerType.date,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  initialValue: dataNascimentoString,
                  focusNode: _focusData,
                  dateLabelText: 'Data de nascimento',
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Data de nascimento',
                    prefixIcon: Icon(Icons.calendar_today_rounded),
                  ),
                  onChanged: (val) {
                    print(val);
                    dataNascimentoString = val;
                  },
                  validator: (val) {
                    print(val);
                    if (val.isEmpty)
                      return "Selecione a data de nascimento do usuário";
                    dataNascimentoString = val;
                    return null;
                  },
                  onSaved: (val) {
                    print(val);
                    dataNascimentoString = val;
                  },
                  dateMask: 'dd/MM/yyyy',
                  cancelText: 'Cancelar',
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ButtonWidget(
                  btnText: "ATUALIZAR",
                  onClick: _onClickUpdate,
                  showProgress: _showProgress,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickUpdate() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String nome = _tNome.text;
    DateTime dataNascimento = DateTime.parse(dataNascimentoString);
    Usuario user = Usuario(
      email: usuario.email,
      nome: nome,
      senha: usuario.senha,
      dataNascimento: Timestamp.fromDate(dataNascimento),
      id: usuario.id,
    );

    final provider = Provider.of<UsersProvider>(context, listen: false);
    provider.updateUser(user);
    alert(context, "Os dados do usuário foram atualizados com sucesso.",
        callback: () {
      pop(context);
    });
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Digite o nome do usuário";
    }
    return null;
  }
}
