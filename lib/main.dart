import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/chart.dart';
import 'widgets/transaction_form.dart';
import 'widgets/transaction_list.dart';

void main() {
  //Set Preffered Screen Orientation
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  // DeviceOrientation.portraitDown,
  //   DeviceOrientation.portraitUp,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Poppins',
        primaryColor: Colors.pinkAccent,
        accentColor: Colors.purple,
        textTheme: ThemeData.light().textTheme.copyWith(
            title: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold),
            button: TextStyle(color: Colors.white)),
        appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  //class model of transaction
  final List<Transaction> _userTransactions = [
    //   Transaction(
    //       id: 't1', title: 'New Shoes', amount: 500, date: DateTime.now()),
    //   Transaction(
    //       id: 't2', title: 'Gucci Bag', amount: 200, date: DateTime.now()),
    //   Transaction(id: 't3', title: 'PS5', amount: 700, date: DateTime.now()),
    //   Transaction(
    //       id: 't1', title: 'New Shoes', amount: 500, date: DateTime.now()),
    //   Transaction(
    //       id: 't2', title: 'Gucci Bag', amount: 200, date: DateTime.now()),
    //   Transaction(id: 't3', title: 'PS5', amount: 700, date: DateTime.now())
  ];

  bool showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime formDate) {
    final newTx = Transaction(
        id: DateTime.now().toString(),
        title: txTitle,
        amount: txAmount,
        date: formDate);
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((element) => id == element.id);
    });
  }

  //open bottom sheet
  void openAddTransactionBottomSheet(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return TransactionForm(_addNewTransaction);
        });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  //context gives info about the widget
  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    final appBar = AppBar(
      title: Text("TrackIt"),
      actions: [
        //add button on appbar
        IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              openAddTransactionBottomSheet(context);
            })
      ],
    );
    final transWidget = Container(
        height: (MediaQuery.of(context).size.height -
                MediaQuery.of(context).padding.top -
                appBar.preferredSize.height) *
            0.7,
        child: TransactionList(_userTransactions, deleteTransaction));
//sufficient padding for child, so it doesnt clash with screen
    final appBody = SafeArea(
        child: SingleChildScrollView(
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isLandscape)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Show Chart'),
                //adaptive blends the ui element for ios/android
                Switch.adaptive(
                    value: showChart,
                    onChanged: (val) {
                      setState(() {
                        showChart = val;
                      });
                    })
              ],
            ),
          if (isLandscape)
            showChart
                ? Container(
                    //MediaQuery gives info about a screen
                    height: (MediaQuery.of(context).size.height -
                            MediaQuery.of(context).padding.top -
                            appBar.preferredSize.height) *
                        0.7,
                    child: Chart(_recentTransactions))
                : transWidget,
          if (!isLandscape)
            Container(
                //MediaQuery gives info about a screen
                height: (MediaQuery.of(context).size.height -
                        MediaQuery.of(context).padding.top -
                        appBar.preferredSize.height) *
                    0.3,
                child: Chart(_recentTransactions)),
          transWidget
        ],
      ),
    ));

    return Platform.isIOS
        ? CupertinoPageScaffold(child: appBody)
        : Scaffold(
            appBar: appBar,
            //makes the view scrollable
            body: appBody,
            //adding a floating button
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () {
                      openAddTransactionBottomSheet(context);
                    },
                  ));
  }
}
