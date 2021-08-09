import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_list.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.pink,
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: GoogleFonts.quicksandTextTheme().copyWith(
          headline6: GoogleFonts.openSans(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.openSansTextTheme(
            ThemeData.light().textTheme.copyWith(
                  headline6: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.indigo,
        accentColor: Colors.indigo.shade300,
        brightness: Brightness.dark,
        fontFamily: GoogleFonts.quicksand().fontFamily,
        textTheme: GoogleFonts.quicksandTextTheme()
            .apply(
              bodyColor: Colors.white,
              displayColor: Colors.white,
            )
            .copyWith(
                headline6: GoogleFonts.openSans(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                subtitle2: GoogleFonts.quicksand().apply(color: Colors.yellow)),
        appBarTheme: AppBarTheme(
          textTheme: GoogleFonts.openSansTextTheme(
            ThemeData.dark().textTheme.copyWith(
                  headline6: GoogleFonts.openSans(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      "t1",
      "New Shoes",
      69.99,
      DateTime.now(),
    ),
    Transaction(
      "t2",
      "Weekly Groceries",
      16.54,
      DateTime.now(),
    )
  ];

  List<Transaction> get _recentTransactions => _userTransactions
      .where((tx) => tx.date.isAfter(
            DateTime.now().subtract(Duration(days: 7)),
          ))
      .toList();

  void _addNewTransaction(String title, double amount, DateTime dateTime) {
    final newTx = Transaction(Uuid().v1(), title, amount, dateTime);
    setState(() => _userTransactions.add(newTx));
  }

  void _deleteTransaction(Transaction tx) {
    setState(() => _userTransactions.remove(tx));
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return NewTransaction(_addNewTransaction);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Personal Expenses"),
        actions: [
          IconButton(
            onPressed: () => _startAddNewTransaction(context),
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Chart(_recentTransactions),
            TransactionList(_userTransactions, _deleteTransaction),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
