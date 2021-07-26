import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/pages/users/usuario.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<ApiResponse<User>> login(String email, String senha) async {
    try {
      // Usuario do Firebase
      final authResult =
          await _auth.signInWithEmailAndPassword(email: email, password: senha);
      final User fUser = authResult.user;
      print("signed in ${authResult.user.displayName}");

      // Cria um usuario do app
      final user = Usuario(
        nome: fUser.displayName,
        email: fUser.email,
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

  Future<ApiResponse<User>> create(
      String email, String senha, String nome) async {
    try {
      // Usuario do Firebase
      final authResult = await _auth.createUserWithEmailAndPassword(
          email: email, password: senha);
      final User fUser = authResult.user;
      print("created user ${authResult.user.displayName}");

      fUser.updateProfile(displayName: nome);

      // Cria um usuario do app
      final user = Usuario(
        nome: fUser.displayName,
        email: fUser.email,
      );
      user.save();

      FirebaseFirestore.instance
          .collection('users')
          .doc(fUser.uid)
          .set(user.toMap());

      // Resposta genérica

      if (user != null) {
        return ApiResponse.ok(
            /*result: true, msg: "Login efetuado com sucesso"*/);
      } else {
        return ApiResponse.error(
            msg: "Não foi possível criar sua conta, tente novamente!");
      }
    } on FirebaseAuthException catch (e) {
      print(" >>> CODE : ${e.code}\n>>> ERRO : $e");
      return ApiResponse.error(
          msg: "Não foi possível criar sua conta, tente novamente!");
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Usuario.clear();
  }

  static Future<ApiResponse<bool>> saveUserData(
      Map<String, dynamic> mapUser, String uid) async {
    try {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(uid).set(mapUser);
      return ApiResponse.ok();
    } catch (e) {
      print("ERRO FIRESTORE SAVE >>>>> $e");

      return ApiResponse.error();
    }
  }
}
