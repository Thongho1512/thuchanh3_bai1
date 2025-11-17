import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';
import '../services/firestore_service.dart';

class TransactionListItem extends StatelessWidget {
  final TransactionModel transaction;
  final FirestoreService _firestoreService = FirestoreService();

  TransactionListItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final categoryColor =
        AppConstants.categoryColors[transaction.category] ?? Colors.grey;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: Dismissible(
        key: Key(transaction.id ?? DateTime.now().toString()),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 32),
        ),
        confirmDismiss: (direction) async {
          return await showDialog<bool>(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Xác nhận xóa'),
                content: const Text('Bạn có chắc chắn muốn xóa giao dịch này?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(foregroundColor: Colors.red),
                    child: const Text('Xóa'),
                  ),
                ],
              );
            },
          );
        },
        onDismissed: (direction) async {
          if (transaction.id != null) {
            await _firestoreService.deleteTransaction(transaction.id!);
          }
        },
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: categoryColor.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(transaction.category),
              color: categoryColor,
            ),
          ),
          title: Text(
            transaction.description,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                transaction.category,
                style: TextStyle(
                  color: categoryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM/yyyy - HH:mm').format(transaction.date),
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          trailing: Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
            ).format(transaction.amount),
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Ăn uống':
        return Icons.restaurant;
      case 'Di chuyển':
        return Icons.directions_car;
      case 'Mua sắm':
        return Icons.shopping_bag;
      case 'Giải trí':
        return Icons.movie;
      case 'Sức khỏe':
        return Icons.medical_services;
      case 'Giáo dục':
        return Icons.school;
      case 'Hóa đơn':
        return Icons.receipt;
      default:
        return Icons.more_horiz;
    }
  }
}
