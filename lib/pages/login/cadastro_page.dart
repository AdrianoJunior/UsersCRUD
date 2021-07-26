import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/pages/users/users_page.dart';
import 'package:users_crud/utils/alert.dart';
import 'package:users_crud/utils/nav.dart';
import 'package:users_crud/widgets/button_widget.dart';
import 'package:users_crud/widgets/header_container.dart';
import 'package:users_crud/widgets/text_input.dart';

import 'login_bloc.dart';
import 'login_page.dart';

class CadastroPage extends StatefulWidget {
  @override
  _CadastroPageState createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _tLogin = TextEditingController();

  final _tSenha = TextEditingController();

  final _tNome = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _bloc = LoginBloc();

  bool _showProgress = false;

  final _focusEmail = FocusNode();
  final _focusSenha = FocusNode();

  final _focusData = FocusNode();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: _body(),
    );
  }

  _body() {
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.only(bottom: 30),
        child: Column(
          children: <Widget>[
            HeaderContainer("Registre-se"),
            Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 30),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
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
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                        focusNode: _focusData,
                        dateLabelText: 'Data de nascimento',
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Data de nascimento',
                          prefixIcon: Icon(Icons.calendar_today_rounded),
                        ),
                        onChanged: (val) => print(val),
                        validator: (val) {
                          print(val);
                          return null;
                        },
                        onSaved: (val) => print(val),
                        dateMask: 'dd/MM/yyyy',
                        cancelText: 'Cancelar',

                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: StreamBuilder<bool>(
                            stream: _bloc.stream,
                            initialData: false,
                            builder: (context, snapshot) {
                              return ButtonWidget(
                                btnText: "REGISTRE-SE",
                                onClick: _onClickCadastro,
                                showProgress: snapshot.data,
                              );
                            }),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        push(context, LoginPage(), replace: true);
                      },
                      child: RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: "Já possui uma conta? ",
                              style: TextStyle(color: Colors.black)),
                          TextSpan(
                              text: "Faça login",
                              style: TextStyle(color: Colors.pink)),
                        ]),
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  _onClickCadastro() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    String login = _tLogin.text;
    String senha = _tSenha.text;
    String nome = _tNome.text;

    ApiResponse response = await _bloc.create(login, senha, nome);
    if (response.ok) {
      alert(context, "Conta criada com sucesso", callback: () async {
        ApiResponse loginResponse = await _bloc.login(login, senha);
        if (loginResponse.ok) {
          push(context, UsersPage(), replace: true);
        } else {
          alert(context, "Não foi possível realizar o login, tente novamente",
              callback: () {
            pop(context);
          });
        }
      });
    } else {
      alert(context, response.msg);
    }
  }

  String _validateLogin(text) {
    if (text.isEmpty) {
      return "Digite seu e-mail";
    }
    return null;
  }

  String _validateSenha(text) {
    if (text.isEmpty) {
      return "Digite a senha";
    }
    return null;
  }

  @override
  void dispose() {
    super.dispose();

    _bloc.dispose();
  }

  String _validateNome(String text) {
    if (text.isEmpty) {
      return "Digite o seu nome";
    }
    return null;
  }
}
