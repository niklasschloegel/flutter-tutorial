import 'package:expense_planner/models/daily_spending.dart';
import 'package:expense_planner/widgets/chart_bar.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<DailySpending> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      final weekDayShort = DateFormat.E().format(weekDay);

      var totalSum = 0.0;
      for (var transaction in recentTransactions) {
        if (transaction.date.day == weekDay.day &&
            transaction.date.month == weekDay.month &&
            transaction.date.year == weekDay.year) {
          totalSum += transaction.amount;
        }
      }

      return DailySpending(weekDayShort, totalSum);
    });
  }

  double get totalSpending =>
      groupedTransactionValues.fold(0.0, (sum, item) => sum += item.totalSum);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Container(
        padding: EdgeInsets.all(10),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues
                .map(
                  (e) => Flexible(
                    fit: FlexFit.loose,
                    child: ChartBar(
                        e.weekDay,
                        e.totalSum,
                        totalSpending == 0.0
                            ? 0.0
                            : e.totalSum / totalSpending),
                  ),
                )
                .toList()),
      ),
    );
  }
}
