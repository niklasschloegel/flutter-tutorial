import 'dart:io';

import 'package:expense_planner/widgets/new_transaction.dart';
import 'package:flutter/cupertino.dart';
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
        backgroundColor: Colors.white,
        errorColor: Colors.pink,
        colorScheme: ColorScheme.light().copyWith(onBackground: Colors.black),
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
        backgroundColor: Colors.grey.shade900,
        colorScheme: ColorScheme.dark().copyWith(onBackground: Colors.white),
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
      DateTime.now().subtract(Duration(days: 2)),
    ),
    Transaction(
      "t2",
      "Weekly Groceries",
      16.54,
      DateTime.now().subtract(Duration(days: 4)),
    )
  ];

  List<Transaction> get _recentTransactions => _userTransactions
      .where((tx) => tx.date.isAfter(
            DateTime.now().subtract(Duration(days: 7)),
          ))
      .toList();

  bool _showChart = false;

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
    final _mediaQuery = MediaQuery.of(context);
    final _isLandscape = _mediaQuery.orientation == Orientation.landscape;
    final _deviceHeight = _mediaQuery.size.height;

    final _title = Text(
      "Personal Expenses",
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
    );

    final _appBar = AppBar(
      title: _title,
      actions: [
        IconButton(
          onPressed: () => _startAddNewTransaction(context),
          icon: Icon(Icons.add),
        )
      ],
    );

    final _iOSNavBar = CupertinoNavigationBar(
      middle: _title,
      backgroundColor: Theme.of(context).colorScheme.background,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
              onTap: () => _startAddNewTransaction(context),
              child: Icon(CupertinoIcons.add)),
        ],
      ),
    );

    final _txListWidget = Container(
      height: (_deviceHeight -
              _appBar.preferredSize.height -
              _mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    List<Widget> _buildLanscapeContent() {
      return [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _showChart ? "Show List" : "Show Chart",
              style: Theme.of(context).textTheme.headline6,
            ),
            Switch.adaptive(
              value: _showChart,
              onChanged: (value) {
                setState(() => _showChart = value);
              },
            ),
          ],
        ),
        _showChart
            ? Container(
                height: (_deviceHeight -
                        _appBar.preferredSize.height -
                        _mediaQuery.padding.top) *
                    0.7,
                child: Chart(_recentTransactions),
              )
            : _txListWidget
      ];
    }

    List<Widget> _buildPortraitContent() {
      return [
        Container(
          height: (_deviceHeight -
                  _appBar.preferredSize.height -
                  _mediaQuery.padding.top) *
              0.3,
          child: Chart(_recentTransactions),
        ),
        _txListWidget
      ];
    }

    final _body = SafeArea(
      child: SingleChildScrollView(
        child: Column(
            children: _isLandscape
                ? _buildLanscapeContent()
                : _buildPortraitContent()),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: _body,
            navigationBar: _iOSNavBar,
          )
        : Scaffold(
            appBar: _appBar,
            body: _body,
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => _startAddNewTransaction(context),
            ),
          );
  }
}
