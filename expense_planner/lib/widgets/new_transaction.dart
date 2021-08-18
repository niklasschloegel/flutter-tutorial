import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function addTx;

  NewTransaction(this.addTx);

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime? _dateTime;

  void _submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    if (enteredTitle.isEmpty || enteredAmount <= 0) return;

    widget.addTx(enteredTitle, enteredAmount,
        _dateTime == null ? DateTime.now() : _dateTime);

    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.fromMicrosecondsSinceEpoch(0),
      lastDate: DateTime.now(),
    ).then((value) {
      if (value == null) return;
      setState(() => _dateTime = value);
    });
  }

  String get _dateTimeString {
    var date = _dateTime;
    return date == null ? 'No Date Chosen!' : DateFormat.yMd().format(date);
  }

  Color _highlightColor(BuildContext context) {
    return Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).primaryColor
        : Theme.of(context).colorScheme.secondary;
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
    return SingleChildScrollView(
      child: Card(
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 10,
          ),
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
                decoration: _decoration(context, "Amount"),
                controller: amountController,
              ),
              Container(
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_dateTimeString),
                    TextButton(
                      style: ButtonStyle(
                          foregroundColor: MaterialStateProperty.all(
                              _highlightColor(context))),
                      child: Text('Choose Date',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          )),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                child: Text("Add Transaction"),
                onPressed: _submitData,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
