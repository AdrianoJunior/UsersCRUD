import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:users_crud/api_response.dart';
import 'package:users_crud/firebase/firebase_api.dart';
import 'package:users_crud/firebase/firebase_service.dart';
import 'package:users_crud/pages/users/usuario.dart';
import 'package:users_crud/utils/simple_bloc.dart';

class UsersBloc extends SimpleBloc<bool> {
  final StreamController _streamController = StreamController<bool>();

  get stream => _streamController.stream;

  Future<ApiResponse<Usuario>> update(Usuario user) async {
    _streamController.add(true);

    ApiResponse response = await FirebaseApi.updateUser(user);

    _streamController.add(false);

    return response;
  }

  void dispose() {
    _streamController.close();
  }
}
