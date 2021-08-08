import 'package:flutter/material.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;

    widget.addTx(enteredTitle, enteredAmount);

    Navigator.of(context).pop();
  }

  Color _highlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Colors.white;
  }

  UnderlineInputBorder _inputBorder(BuildContext context) {
    return UnderlineInputBorder(
        borderSide: BorderSide(color: _highlightColor(context)));
  }

  InputDecoration _decoration(BuildContext context, String txt) {
    return InputDecoration(
      labelText: txt,
      labelStyle: TextStyle(color: _highlightColor(context)),
      enabledBorder: _inputBorder(context),
      focusedBorder: _inputBorder(context),
      border: _inputBorder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            TextField(
              decoration: _decoration(context, "Title"),
              controller: titleController,
              textInputAction: TextInputAction.next,
            ),
            TextField(
              keyboardType: TextInputType.numberWithOptions(
                decimal: true,
              ),
              onSubmitted: (_) => _submitData(),
              decoration: _decoration(context, "Amount"),
              controller: amountController,
            ),
            TextButton(
              child: Text("Add Transaction"),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(_highlightColor(context))),
              onPressed: _submitData,
            ),
          ],
        ),
      ),
    );
  }
}
