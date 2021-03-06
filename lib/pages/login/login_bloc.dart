import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/firebase/firebase_service.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/utils/simple_bloc.dart';

class LoginBloc extends SimpleBloc<bool> {
  final StreamController _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse<User>> login(Usuario usuario) async {
    _streamController.add(true);

    ApiResponse response = await FirebaseService().login(usuario);

    _streamController.add(false);

    return response;
  }

  Future<ApiResponse<Usuario>> create(Usuario user) async {
    _streamController.add(true);

    ApiResponse response = await FirebaseService().create(user);

    _streamController.add(false);

    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
