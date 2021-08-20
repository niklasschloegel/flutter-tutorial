import '../models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TransactionItem extends StatelessWidget {
  const TransactionItem({
    Key? key,
    required this.tx,
    required this.deleteTx,
  }) : super(key: key);

  final Transaction tx;
  final Function deleteTx;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 14,
      ),
      child: Dismissible(
        key: Key(tx.id),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).brightness == Brightness.light
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
              color: Theme.of(context).brightness == Brightness.light
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
  }
}
