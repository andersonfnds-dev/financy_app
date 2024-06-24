import 'dart:async';
import 'package:flutter_finance/src/resources/repository.dart';
import 'package:flutter_finance/src/utils/prefs_manager.dart';
import 'package:flutter_finance/src/utils/validator.dart';
import 'package:flutter_finance/src/utils/values/string_constants.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../bloc.dart';

class AuthenticationBloc implements Bloc {
  final _repository = Repository();
  final _email = BehaviorSubject<String?>();
  final _displayName = BehaviorSubject<String?>();
  final _password = BehaviorSubject<String?>();
  final _isSignedIn = BehaviorSubject<bool>();

  Stream<String?> get email => _email.stream.transform(_validateEmail);
  Stream<String?> get displayName => _displayName.stream.transform(_validateDisplayName);
  Stream<String?> get password => _password.stream.transform(_validatePassword);
  Stream<bool> get signInStatus => _isSignedIn.stream;

  // Change data
  Function(String) get changeEmail => _email.sink.add; 
  Function(String) get changeDisplayName => _displayName.sink.add;
  Function(String) get changePassword => _password.sink.add;
  Function(bool) get showProgressBar => _isSignedIn.sink.add;

  final _validateEmail = StreamTransformer<String?, String?>.fromHandlers(handleData: (email, sink) {
    if (email != null && Validator.validateEmail(email)) {
      sink.add(email);
    } else {
      sink.addError(StringConstants.emailValidateMessage);
    }
  });

  final _validatePassword = StreamTransformer<String?, String?>.fromHandlers(
    handleData: (password, sink) {
      if (password != null && Validator.validatePassword(password)) {
        sink.add(password);
      } else {
        sink.addError(StringConstants.passwordValidateMessage);
      }
    }
  );

  final _validateDisplayName = StreamTransformer<String?, String?>.fromHandlers(handleData: (displayName, sink) {
    if (displayName != null && displayName.length > 5) {
      sink.add(displayName);
    } else {
      sink.addError(StringConstants.displayNameValidateMessage);
    }
  });

  bool validateEmailAndPassword() {
    final email = _email.valueOrNull;
    final password = _password.valueOrNull;
    if (email != null && email.isNotEmpty && email.contains("@") && password != null && password.isNotEmpty && password.length > 5) {
      return true;
    }
    return false;
  }

  void saveCurrentUserDisplayName(SharedPreferences prefs) {
    final displayName = _displayName.valueOrNull;
    if (displayName != null) {
      print("SAVED DISPLAYNAME: $displayName");
      PrefsManager prefsManager = PrefsManager();
      prefsManager.setCurrentUserDisplayName(prefs, displayName);
    }
  }

  bool validateDisplayName() {
    final displayName = _displayName.valueOrNull;
    return displayName != null && displayName.isNotEmpty && displayName.length > 5;
  }

  // Firebase methods
  Future<int> loginUser() async {
    showProgressBar(true);
    final email = _email.valueOrNull;
    final password = _password.valueOrNull;
    if (email != null && password != null) {
      int response = await _repository.loginWithEmailAndPassword(email, password);
      showProgressBar(false);
      return response;
    } else {
      showProgressBar(false);
      throw Exception("Email or Password is null");
    }
  }

  Future<int> registerUser() async {
    showProgressBar(true);
    final email = _email.valueOrNull;
    final password = _password.valueOrNull;
    final displayName = _displayName.valueOrNull;
    if (email != null && password != null && displayName != null) {
      int response = await _repository.signUpWithEmailAndPassword(email, password, displayName);
      showProgressBar(false);
      return response;
    } else {
      showProgressBar(false);
      throw Exception("Email, Password or DisplayName is null");
    }
  }

  @override
  void dispose() async {
    await _email.drain();
    _email.close();
    await _displayName.drain();
    _displayName.close();
    await _password.drain();
    _password.close();
    await _isSignedIn.drain();
    _isSignedIn.close();
  }
}
