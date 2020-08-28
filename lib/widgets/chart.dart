import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:first_app/models/Transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);
  List<Map<String, Object>> get groupedTransactionValues {
    //aqui tendre una lista de 7 elementos con index que va de 0 a 6
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );
      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        if (recentTransactions[i].date.day == weekDay.day &&
            recentTransactions[i].date.month == weekDay.month &&
            recentTransactions[i].date.year == weekDay.year) {
          totalSum += recentTransactions[i].amount;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay).substring(0, 1),
        'amount': totalSum
      };
    }).reversed.toList();
  }

  double get totalSpending {
    return groupedTransactionValues.fold(0.0, (sum, item) {
      return sum + item['amount'];
    });
  }

  @override
  Widget build(BuildContext context) {
    print(groupedTransactionValues);
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Padding(
        //este padding es para que no se toquen con el texto del dinero el borde
        //de la card.
        padding: EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: groupedTransactionValues.map((data) {
            return Flexible(
              //flexible y ese fit es para forzar el numero a utilizar el espacio
              //que se tiene y no mas.
              fit: FlexFit.tight,
              child: ChartBar(
                data['day'],
                data['amount'],
                data['amount'] as double >= 0.0001
                    ? (data['amount'] as double) / totalSpending
                    : 0.0,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
