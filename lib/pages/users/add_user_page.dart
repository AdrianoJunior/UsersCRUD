import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/pages/login/login_bloc.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/provider/users_provider.dart';
import 'package:users_crud/utils/alert.dart';
import 'package:users_crud/utils/nav.dart';
import 'package:users_crud/widgets/button_widget.dart';
import 'package:users_crud/widgets/text_input.dart';

class AddUserPage extends StatefulWidget {
  @override
  _AddUserPageState createState() => _AddUserPageState();
}

class _AddUserPageState extends State<AddUserPage> {
  final _formKey = GlobalKey<FormState>();

  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _tNome = TextEditingController();

  final _focusEmail = FocusNode();
  final _focusSenha = FocusNode();

  final _focusData = FocusNode();

  final _bloc = LoginBloc();

  String dataNascimentoString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Cadastrar usuário"),
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
                nextFocus: _focusEmail,
              ),
              TextInput(
                hint: "E-mail",
                icon: Icons.email,
                inputAction: TextInputAction.next,
                keyboardType: TextInputType.emailAddress,
                validator: (s) => _validateLogin(s),
                controller: _tLogin,
                nextFocus: _focusSenha,
                focusNode: _focusEmail,
              ),
              // _textInput(hint: "Phone Number", icon: Icons.call),
              TextInput(
                hint: "Senha",
                icon: Icons.vpn_key,
                inputAction: TextInputAction.done,
                keyboardType: TextInputType.text,
                validator: (s) => _validateSenha(s),
                controller: _tSenha,
                focusNode: _focusSenha,
                nextFocus: _focusData,
                password: true,
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
                child: StreamBuilder<bool>(
                    stream: _bloc.stream,
                    initialData: false,
                    builder: (context, snapshot) {
                      return ButtonWidget(
                        btnText: "CADASTRAR",
                        onClick: _onClickCreate,
                        showProgress: snapshot.data,
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onClickCreate() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String email = _tLogin.text;
    String senha = _tSenha.text;
    String nome = _tNome.text;
    DateTime dataNascimento = DateTime.parse(dataNascimentoString);
    Usuario user = Usuario(
      email: email,
      nome: nome,
      senha: senha,
      dataNascimento: Timestamp.fromDate(dataNascimento),
    );

    ApiResponse<Usuario> userResponse = await _bloc.create(user);
    final provider = Provider.of<UsersProvider>(context, listen: false);
    if (userResponse.ok) {
      user = userResponse.result;


      provider.addUser(user).then((value) {
        alert(context, "Usuário criado com sucesso!", callback: () {
          pop(context);
        });
      });
    } else {
      if(userResponse.msg == 'Já existe um usuário cadastrado com este e-mail.') {
        provider.addUser(user).then((value) {
          alert(context, "Usuário cadastrado comm sucesso.", callback: (){
            pop(context);
          });
        });
      }
      alert(context, userResponse.msg);
    }
  }

  String _validateLogin(text) {
    if (text.isEmpty) {
      return "Digite o e-mail do usuário";
    }
    return null;
  }

  String _validateSenha(text) {
    if (text.isEmpty) {
      return "Digite a senha do usuário";
    }
    return null;
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Digite o nome do usuário";
    }
    return null;
  }
}
