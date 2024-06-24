import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finance/src/utils/prefs_manager.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../resources/repository.dart';
import '../../utils/validator.dart';
import '../../utils/values/string_constants.dart';
import '../bloc.dart';

class UserFinanceBloc implements Bloc {
  final _repository = Repository();
  final _financeValue = BehaviorSubject<String?>();

  Stream<String?> get financeValue => _financeValue.stream.transform(_validateFinanceValue);

  Function(String) get changeFinanceValue => _financeValue.sink.add;

  final _validateFinanceValue = StreamTransformer<String?, String?>.fromHandlers(handleData: (value, sink) {
    if (value != null && Validator.validateFinanceValue(value)) {
      sink.add(value);
    } else {
      sink.addError(StringConstants.financeValueValidateMessage);
    }
  });

  bool validateFinance() {
    final value = _financeValue.valueOrNull;
    return value != null && value.isNotEmpty;
  }
  
  Stream<User?> get currentUser => _repository.onAuthStateChange;
  Future<String?> getUserUID() => _repository.getUserUID();
  Future<void> signOut() => _repository.signOut();

  String getCurrentUserDisplayNameFromPrefs(SharedPreferences prefs) {
    PrefsManager prefsMang = PrefsManager();
    String displayName = prefsMang.getCurrentUserDisplayName(prefs);
    print("CURRENT DISPLAYNAME: $displayName");
    return displayName;
  }

  Stream<DocumentSnapshot> userFinanceDoc(String userUID) => _repository.userFinanceDoc(userUID);

  Future<void> setUserBudget() async {
    String userUID = getUserUID();
    final value = _financeValue.valueOrNull;

    if (value != null) {
      return _repository.setUserBudget(userUID, double.parse(value));
    } else {
      // Trate o caso onde o valor é nulo, talvez lançando uma exceção ou lidando de outra forma.
      throw Exception('Finance value is null');
    }
  }

  Stream<QuerySnapshot> expenseList(String userUID) => _repository.expensesList(userUID);
  Stream<QuerySnapshot> lastExpense(String userUID) => _repository.lastExpense(userUID);

  Future<void> addNewExpense() async {
    String userUID = await getUserUID();
    final value = _financeValue.valueOrNull;

    if (value != null) {
      return _repository.addNewExpense(userUID, double.parse(value));
    } else {
      // Trate o caso onde o valor é nulo, talvez lançando uma exceção ou lidando de outra forma.
      throw Exception('Finance value is null');
    }
  }

  @override
  void dispose() async {
    await _financeValue.drain();
    _financeValue.close();
  }
}
