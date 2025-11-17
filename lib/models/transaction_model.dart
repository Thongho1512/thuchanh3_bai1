import 'package:cloud_firestore/cloud_firestore.dart';

class TransactionModel {
  String? id;
  String userId;
  double amount;
  String description;
  String category;
  DateTime date;

  TransactionModel({
    this.id,
    required this.userId,
    required this.amount,
    required this.description,
    required this.category,
    required this.date,
  });

  // Convert to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'amount': amount,
      'description': description,
      'category': category,
      'date': Timestamp.fromDate(date),
    };
  }

  // Create from Firestore document
  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return TransactionModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      description: data['description'] ?? '',
      category: data['category'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }
}
