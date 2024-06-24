import 'package:cloud_firestore/cloud_firestore.dart';

class ExpenseModel {
  String? id;
  double? expenseValue;
  Timestamp? timestamp;

  ExpenseModel({this.id, this.expenseValue, this.timestamp});

  factory ExpenseModel.fromDocument(DocumentSnapshot document) {
    final data = document.data() as Map<String, dynamic>?;
    return ExpenseModel(
      id: document.id,
      expenseValue: data?['value'],
      timestamp: data?['timestamp'],
    );
  }
}
