import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/pages/users/usuario.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse<User>> login(Usuario usuario) async {
    try {
      // Usuario do Firebase
      final authResult = await _auth.signInWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);
      final User fUser = authResult.user;
      print("signed in ${authResult.user.displayName}");

      // Cria um usuario do app
      final user = Usuario(
        nome: fUser.displayName,
        email: fUser.email,
        senha: usuario.senha,
        dataNascimento: usuario.dataNascimento,
        uid: fUser.uid,
      );
      user.save();

      // Resposta genérica

      if (user != null) {
        return ApiResponse.ok(
          /*result: true, msg: "Login efetuado com sucesso"*/);
      } else {
        return ApiResponse.error(
            msg: "Não foi possível fazer o login, tente novamente!");
      }
    } on FirebaseAuthException catch (e) {
      print(" >>> CODE : ${e.code}\n>>> ERRO : $e");
      return ApiResponse.error(
          msg: "Não foi possível fazer o login, tente novamente!");
    }
  }

  Future<ApiResponse<Usuario>> create(Usuario usuario) async {
    try {
      // Usuario do Firebase
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: usuario.email, password: usuario.senha);
      final User fUser = authResult.user;
      print("created user ${authResult.user.displayName}");

      fUser.updateDisplayName(usuario.nome);

      // Cria um usuario do app
      final user = Usuario(
        nome: usuario.nome,
        email: fUser.email,
        senha: usuario.senha,
        dataNascimento: usuario.dataNascimento,
        uid: fUser.uid,
      );
      // user.save();

      if (user != null) {
        return ApiResponse.ok(result: user);
      } else {
        return ApiResponse.error(
            msg: "Não foi possível criar sua conta, tente novamente!");
      }
    } on FirebaseAuthException catch (e) {
      print(" >>> CODE : ${e.code}\n>>> ERRO : $e");

      if (e.code == 'email-already-in-use') {
        return ApiResponse.error(
            msg: 'Já existe um usuário cadastrado com este e-mail.');
      } else {
        return ApiResponse.error(
            msg: "Não foi possível criar sua conta, tente novamente!");
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Usuario.clear();
  }
}
