import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreResources {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<DocumentSnapshot<Map<String, dynamic>>> userFinanceDoc(String userUID) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .snapshots();

  Future<void> setUserBudget(String userUID, double budget) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .set({
        'budget': budget
      }, SetOptions(merge: true));

  Future<void> addNewExpense(String userUID, double expenseValue) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .doc()
      .set({
        'value': expenseValue,
        'timestamp': FieldValue.serverTimestamp()
      });

  Stream<QuerySnapshot<Map<String, dynamic>>> expensesList(String userUID) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .orderBy('timestamp', descending: true)
      .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> lastExpense(String userUID) => _firestore
      .collection("userFinance")
      .doc(userUID)
      .collection("expenses")
      .orderBy('timestamp', descending: true)
      .limit(1)
      .snapshots();
}
