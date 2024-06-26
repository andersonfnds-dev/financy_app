import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_finance/src/resources/authentication_resources.dart';
import 'package:flutter_finance/src/resources/firestore_resources.dart';

class Repository {
  final _authResources = AuthenticationResources();
  final _userFinanceResources = FirestoreResources();

  /// Authentication
  Stream<User?> get onAuthStateChange => _authResources.onAuthStateChange;
  Future<int> loginWithEmailAndPassword(String email, String password) => _authResources.loginWithEmailAndPassword(email, password);
  Future<int> signUpWithEmailAndPassword(String email, String password, String displayName) => _authResources.signUpWithEmailAndPassword(email, password, displayName);
  Future<void> signOut() => _authResources.signOut();
  Future<String?> getUserUID() async {
  final user = FirebaseAuth.instance.currentUser;
  return user?.uid;
}

  /// User Finance - Firestore
  Stream<DocumentSnapshot<Map<String, dynamic>>> userFinanceDoc(String userUID) => _userFinanceResources.userFinanceDoc(userUID);
  Future<void> setUserBudget(String userUID, double budget) => _userFinanceResources.setUserBudget(userUID, budget);
  Future<void> addNewExpense(String userUID, double expenseValue) => _userFinanceResources.addNewExpense(userUID, expenseValue);
  Stream<QuerySnapshot<Map<String, dynamic>>> expensesList(String userUID) => _userFinanceResources.expensesList(userUID);
  Stream<QuerySnapshot<Map<String, dynamic>>> lastExpense(String userUID) => _userFinanceResources.lastExpense(userUID);
}
