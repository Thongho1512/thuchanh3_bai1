import 'package:flutter/material.dart';
import '../models/transaction_model.dart';
import '../utils/constants.dart';

class ExpenseChart extends CustomPainter {
  final List<TransactionModel> transactions;
  final Map<String, double> categoryTotals;

  ExpenseChart({required this.transactions, required this.categoryTotals});

  @override
  void paint(Canvas canvas, Size size) {
    if (categoryTotals.isEmpty) return;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2.5;

    double total = categoryTotals.values.fold(0, (sum, value) => sum + value);
    double startAngle = -90 * (3.14159 / 180); // Start from top

    categoryTotals.forEach((category, amount) {
      final sweepAngle = (amount / total) * 2 * 3.14159;

      final paint = Paint()
        ..color = AppConstants.categoryColors[category] ?? Colors.grey
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    });

    // Draw white circle in center to create donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius * 0.6, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class ExpenseChartWidget extends StatelessWidget {
  final List<TransactionModel> transactions;

  const ExpenseChartWidget({super.key, required this.transactions});

  Map<String, double> _calculateCategoryTotals() {
    Map<String, double> totals = {};

    for (var transaction in transactions) {
      totals[transaction.category] =
          (totals[transaction.category] ?? 0) + transaction.amount;
    }

    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final categoryTotals = _calculateCategoryTotals();

    if (categoryTotals.isEmpty) {
      return const Center(child: Text('Không có dữ liệu để hiển thị'));
    }

    return Column(
      children: [
        SizedBox(
          height: 250,
          child: CustomPaint(
            size: const Size(250, 250),
            painter: ExpenseChart(
              transactions: transactions,
              categoryTotals: categoryTotals,
            ),
          ),
        ),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 12,
          alignment: WrapAlignment.center,
          children: categoryTotals.entries.map((entry) {
            final percentage =
                (entry.value /
                    categoryTotals.values.fold(0, (sum, val) => sum + val)) *
                100;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppConstants.categoryColors[entry.key],
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${entry.key} (${percentage.toStringAsFixed(1)}%)',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
