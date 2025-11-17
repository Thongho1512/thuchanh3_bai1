import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction_model.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    await _db.collection('transactions').add(transaction.toMap());
  }

  // Get transactions stream for a user
  Stream<List<TransactionModel>> getTransactionsStream(String userId) {
    return _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .orderBy('date', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TransactionModel.fromFirestore(doc))
              .toList();
        });
  }

  // Delete transaction
  Future<void> deleteTransaction(String transactionId) async {
    await _db.collection('transactions').doc(transactionId).delete();
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id != null) {
      await _db
          .collection('transactions')
          .doc(transaction.id)
          .update(transaction.toMap());
    }
  }

  // Get transactions for analytics
  Future<List<TransactionModel>> getTransactionsForPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    QuerySnapshot snapshot = await _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate))
        .where('date', isLessThanOrEqualTo: Timestamp.fromDate(endDate))
        .get();

    return snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();
  }
}
