import 'dart:convert' as convert;

import 'package:users_crud/utils/prefs.dart';

class Usuario {
  String nome;
  String uid;
  String email;
  String senha;
  DateTime dataNascimento;

  Usuario({
    this.nome,
    this.uid,
    this.email,
    this.senha,
    this.dataNascimento,
  });

  Usuario.fromMap(Map<String, dynamic> user) {
    nome = user['nome'];
    uid = user['uid'];
    email = user['email'];
    senha = user['senha'];
    dataNascimento = user['dataNascimento'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['uid'] = this.uid;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['dataNascimento'] = this.dataNascimento;
    return data;
  }

  String toJson() {
    String json = convert.json.encode(toMap());
    return json;
  }

  static void clear() {

    Prefs.setString("user.prefs", "");
  }

  void save() {
    Map map = toMap();
    String json = convert.json.encode(map);
    Prefs.setString("user.prefs", json);
  }

  static Future<Usuario> get() async {
    String json = await Prefs.getString("user.prefs");

    if (json.isEmpty) {
      return null;
    }
    Map map = convert.json.decode(json);

    Usuario user = Usuario.fromMap(map);

    return user;
  }
}
