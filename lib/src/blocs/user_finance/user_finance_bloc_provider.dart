import 'package:flutter/material.dart';

import 'user_finance_bloc.dart';

class UserFinanceBlocProvider extends InheritedWidget {
  final UserFinanceBloc bloc = UserFinanceBloc();

  UserFinanceBlocProvider({Key? key, required Widget child})
      : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static UserFinanceBloc of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<UserFinanceBlocProvider>();
    if (provider == null) {
      throw FlutterError('UserFinanceBlocProvider not found in the widget tree');
    }
    return provider.bloc;
  }
}
