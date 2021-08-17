import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'package:flutter/material.dart';

class TransactionList extends StatelessWidget {
  final List<Transaction> transactions;
  final Function deleteTx;

  const TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: transactions.isEmpty
          ? LayoutBuilder(builder: (ctx, constraints) {
              return Column(
                children: [
                  Text(
                    "No transactions added yet!",
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: constraints.maxHeight * 0.6,
                    child: Image.asset(
                      'assets/images/waiting.png',
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              );
            })
          : ListView.builder(
              itemBuilder: (ctx, index) {
                final tx = transactions[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 5,
                  ),
                  child: Dismissible(
                    key: Key(tx.id),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor:
                            Theme.of(context).brightness == Brightness.light
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).accentColor,
                        foregroundColor: Colors.white,
                        radius: 30,
                        child: Padding(
                          padding: EdgeInsets.all(6),
                          child: FittedBox(
                            child: Text('\$${tx.amount}'),
                          ),
                        ),
                      ),
                      title: Text(
                        tx.title,
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      subtitle: Text(
                        DateFormat.yMMMd().format(tx.date),
                        style: TextStyle(
                          color:
                              Theme.of(context).brightness == Brightness.light
                                  ? Colors.grey
                                  : Colors.grey.shade400,
                        ),
                      ),
                    ),
                    background: Container(
                      padding: EdgeInsets.only(right: 20.0),
                      color: Theme.of(context).errorColor,
                      child: Icon(Icons.delete),
                      alignment: Alignment.centerRight,
                    ),
                    onDismissed: (direction) {
                      if (direction == DismissDirection.endToStart) {
                        deleteTx(tx);
                      }
                    },
                  ),
                );
              },
              itemCount: transactions.length,
            ),
    );
  }
}
