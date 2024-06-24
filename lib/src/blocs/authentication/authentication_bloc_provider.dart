import 'package:flutter/material.dart';
import 'authentication_bloc.dart';

class AuthenticationBlocProvider extends InheritedWidget {
  final AuthenticationBloc bloc = AuthenticationBloc();

  AuthenticationBlocProvider({Key? key, required Widget child}) 
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static AuthenticationBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AuthenticationBlocProvider>();
    if (provider == null) {
      throw FlutterError('AuthenticationBlocProvider not found in the widget tree');
    }
    return provider.bloc;
  }
}
