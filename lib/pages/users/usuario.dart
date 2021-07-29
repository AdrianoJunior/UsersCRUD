import 'dart:convert' as convert;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:users_crud/utils/prefs.dart';

class Usuario {
  String nome;
  String id;
  String uid;
  String email;
  String senha;
  Timestamp dataNascimento;

  Usuario({
    this.nome,
    this.id,
    this.email,
    this.senha,
    this.dataNascimento,
    this.uid,
  });

  static Usuario fromMap(Map<String, dynamic> user) => Usuario(
        nome: user['nome'],
        id: user['id'],
        email: user['email'],
        senha: user['senha'],
        dataNascimento: user['dataNascimento'],
    uid: user['uid'],
      );

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['nome'] = this.nome;
    data['id'] = this.id;
    data['email'] = this.email;
    data['senha'] = this.senha;
    data['dataNascimento'] = this.dataNascimento;
    data['uid'] = this.uid;
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
    // Map map = toMap();

    final Map<String, dynamic> userData = new Map<String, dynamic>();
    // userData['nome'] = this.nome;
    // userData['id'] = this.id;
    userData['email'] = this.email;
    userData['senha'] = this.senha;

    String json = convert.json.encode(userData);
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

  @override
  String toString() {
    return 'Usuario{UID: $uid, id: $id, login: $email, nome: $nome, senha: $senha, Data: $dataNascimento}';
  }
}
