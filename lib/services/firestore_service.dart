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

  // Get transactions for analytics - FIXED VERSION
  Future<List<TransactionModel>> getTransactionsForPeriod(
    String userId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    // Query all transactions for the user first
    QuerySnapshot snapshot = await _db
        .collection('transactions')
        .where('userId', isEqualTo: userId)
        .get();

    // Filter by date in memory to avoid composite index requirement
    List<TransactionModel> allTransactions = snapshot.docs
        .map((doc) => TransactionModel.fromFirestore(doc))
        .toList();

    // Filter by date range
    return allTransactions.where((transaction) {
      return transaction.date
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          transaction.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }
}
