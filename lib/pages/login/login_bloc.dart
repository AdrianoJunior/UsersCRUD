import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/firebase/firebase_service.dart';
import 'package:users_crud/utils/simple_bloc.dart';


class LoginBloc extends SimpleBloc<bool> {
  final StreamController _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse<User>> login(String login, String senha) async {
    _streamController.add(true);

    ApiResponse response = await FirebaseService().login(login, senha);

    _streamController.add(false);

    return response;
  }

  Future<ApiResponse<User>> create(String login, String senha, String nome) async {
    _streamController.add(true);

    ApiResponse response = await FirebaseService().create(login, senha, nome);

    _streamController.add(false);

    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
