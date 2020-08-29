import 'package:first_app/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';
import 'models/Transaction.dart';
import 'widgets/chart.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber,
          errorColor: Colors.blueGrey[800],
          //asi se puede poner una fuente general para el doc
          fontFamily: 'Quicksand',
          textTheme: ThemeData.light().textTheme.copyWith(
                title: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                button:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
          //asi se podria dar una font particular a la appbar en este caso.
          appBarTheme: AppBarTheme(
            textTheme: ThemeData.light().textTheme.copyWith(
                  title: TextStyle(
                    fontFamily: 'OpenSans',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          )),
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
    //
    //dummy transactions
    //
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 6.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
  ];

  bool _showChart = false;

  //Devuelve true si el dia es de los ultimos 7
  List<Transaction> get _recentTransactions {
    return _userTransactions.where((tx) {
      //esto retorna true si la fecha de tx es despues de 7 dias antes de hoy
      return tx.date.isAfter(
        DateTime.now().subtract(
          Duration(days: 7),
        ),
      );
    }).toList();
  }

  void _addNewTransaction(
      String txTitle, double txAmount, DateTime chosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: chosenDate,
      id: DateTime.now().toString(),
    );
    setState(() {
      _userTransactions.add(newTx);
    });
  }

  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          return NewTransaction(_addNewTransaction);
        });
  }

  void _deleteTransaction(String id) {
    setState(() {
      _userTransactions.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //final debido a que cada vez que se renderiza la app no cambia.
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    //guardo la appBar en una variable ya que asi podemos tener info del tamaño
    // de esta para controlar responsivemente el tamaño
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    final txList = Container(
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.75,
        child: TransactionList(_userTransactions, _deleteTransaction));

    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          //las siguientes lineas controlan el layout de los comp de la columna.
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            if (!isLandscape)
              Container(
                  //aca lo que se hace es, al tamaño de la pantalla se le resta el tamañp
                  // de la appBar utilizado y el tamaño de la barrita de notificaciones
                  // que todos los celulares tienen donde se indica bateria hora etc
                  // y a eso se le calcula un % del total que se utilizará para ello
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            if (!isLandscape) txList,
            if (isLandscape)
              _showChart
                  ? Container(
                      //aca lo que se hace es, al tamaño de la pantalla se le resta el tamañp
                      // de la appBar utilizado y el tamaño de la barrita de notificaciones
                      // que todos los celulares tienen donde se indica bateria hora etc
                      // y a eso se le calcula un % del total que se utilizará para ello
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      child: Chart(_recentTransactions))
                  : txList,
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
