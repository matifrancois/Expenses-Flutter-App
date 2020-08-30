import 'package:first_app/widgets/new_transaction.dart';
import 'package:flutter/material.dart';
import 'widgets/transaction_list.dart';
import 'widgets/new_transaction.dart';
import 'models/Transaction.dart';
import 'widgets/chart.dart';

// Aquí empieza el Programa.
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      //Esto te permite modificar el tema de la app.
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
      //aqui le decis que clase queres que sea el home de tu app
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
    // #region Comentario con Transaccion dummy ejemplo
    //
    // Aqui se crean la lista de transacciones que se vayan creado
    // Por ejemplo la siguiente seria una posible transaccion.
    //
    // Transaction(
    //     id: 't1', title: 'New Shoes', amount: 6.99, date: DateTime.now()),
    // Transaction(
    //     id: 't2',
    //     title: 'Weekly Groceries',
    //     amount: 16.53,
    //     date: DateTime.now()),
    // #endregion
  ];

  //Esta variable se utiliza luego en Landscape para mostrar o no el grafico
  bool _showChart = false;

  // Devuelve true si el dia es de los ultimos 7 días, vendria a ser la condicion
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

  // Esta funcion crea y agrega una nueva transaccion a la lista creada
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

  // Esta funcion se activa al pulsar los botones + (para crear una nueva trans)
  void _startAddNewTransaction(BuildContext ctx) {
    showModalBottomSheet(
        context: ctx,
        builder: (_) {
          //retorna la clase (widget en realidad) New transaction del archivo
          // transaction_list, y le pasa puntero a la funcion _addNewTransaction
          return NewTransaction(_addNewTransaction);
        });
  }

  // Esta funcion borra una transaccion al apretar el "delete" de ella.
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
    // de esta para controlar "responsivemente" el tamaño
    final appBar = AppBar(
      title: Text('Personal Expenses'),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => _startAddNewTransaction(context),
        ),
      ],
    );

    //otra variable con un widget dentro para evitar repetir codigo
    final txList = Container(
        //De esta manera controlo de forma responsive el tamaño basandome en la
        //pantalla del dispositivo.
        height: (MediaQuery.of(context).size.height -
                appBar.preferredSize.height -
                MediaQuery.of(context).padding.top) *
            0.75,
        child: TransactionList(_userTransactions, _deleteTransaction));
    //Scaffold define el tipo de formato basico de nuestra app que es el que
    //vamos a utilizar.
    return Scaffold(
      appBar: appBar,
      //Singlechildscrollview permite una vista scrolleable de la pantalla
      body: SingleChildScrollView(
        child: Column(
          // #region Comentario
          //
          //las siguientes lineas controlan el layout de los comp de la columna.
          //mainAxisAlignment: MainAxisAlignment.start,
          //
          //En una columna crossAxisAlignment controla el ancho de la misma y
          //stretch hace que todo ocupe el maximo ancho disponible.
          // #endregion
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            //En este caso se utilizan sentencias if antes de cada widget para
            //indicar si se muestra o no el mismo.
            if (isLandscape)
              Row(
                //En la row se van a poner las cosas centradas horizontalmente
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //se pone un switch con la leyenda Show Chart
                  Text('Show Chart'),
                  Switch(
                    value: _showChart,
                    //al activar el boton se iguala la variable _showChart a val
                    //setState se utiliza allí para actualizar el contenido en pantalla
                    onChanged: (val) {
                      setState(() {
                        _showChart = val;
                      });
                    },
                  ),
                ],
              ),
            //si no se esta en landscape (celular en forma horizontal)
            if (!isLandscape)
              Container(
                  // #region Comentario
                  //
                  //aca lo que se hace es, al tamaño de la pantalla se le resta el tamaño
                  // de la appBar utilizado y el tamaño de la barrita de notificaciones
                  // que todos los celulares tienen donde se indica bateria hora etc
                  // y a eso se le calcula un % del total que se utilizará para ello
                  // #endregion
                  height: (MediaQuery.of(context).size.height -
                          appBar.preferredSize.height -
                          MediaQuery.of(context).padding.top) *
                      0.3,
                  child: Chart(_recentTransactions)),
            //aqui se hace uso de la variable txList que es un widget.
            if (!isLandscape) txList,
            if (isLandscape)
              _showChart
                  ? Container(
                      // #region Comentario
                      //
                      //aca lo que se hace es, al tamaño de la pantalla se le resta el tamañp
                      // de la appBar utilizado y el tamaño de la barrita de notificaciones
                      // que todos los celulares tienen donde se indica bateria hora etc
                      // y a eso se le calcula un % del total que se utilizará para ello
                      // #endregion
                      height: (MediaQuery.of(context).size.height -
                              appBar.preferredSize.height -
                              MediaQuery.of(context).padding.top) *
                          0.6,
                      child: Chart(_recentTransactions))
                  : txList,
          ],
        ),
      ),
      //Aqui se define la posicion que luego tendra el floating button que creemos.
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _startAddNewTransaction(context),
      ),
    );
  }
}
