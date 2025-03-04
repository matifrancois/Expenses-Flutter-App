import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:first_app/models/Transaction.dart';

class TransactionList extends StatelessWidget {
  //Defino la lista de transacciones
  final List<Transaction> transactions;
  //defino el puntero a la funcion que se pasa como parametro del constructor.
  final Function deleteTx;

  TransactionList(this.transactions, this.deleteTx);

  @override
  Widget build(BuildContext context) {
    // #region Comentario
    // si la lista de transaccion esta vacía mostra el texto y la foto, sino
    // mostra la lista de cards.
    // como tenemos una lista scrolleable media larga, lo mejor es utilizar
    // un container con el height fijado (importante) y un ListView.builder
    // este tiene 2 argumentos, el itemBuilder que es una funcion que toma ctx
    // al cual no le damos mucha bola y index que es el que te dice el indice de
    // la repeticion del widget, y dentro en return de la funcion el widget a
    // repetir. De esta manera se refiere al widget como transactions[index].
    // y el segundo parametro de listview.buider es itemCount, que representa la
    // cantidad de veces que queremos que se repita el item.
    // #endregion
    return transactions.isEmpty
        ? LayoutBuilder(
            builder: (ctx, constraints) {
              return Column(
                children: <Widget>[
                  Text(
                    'No transactions added yet',
                    style: Theme.of(context).textTheme.title,
                  ),
                  // Esto es para dar un espaciado de 10 px
                  SizedBox(
                    height: 10,
                  ),
                  // Esto es para meter la imagen, fit para que se acople al tamaño
                  Container(
                      height: constraints.maxHeight * 0.6,
                      child: Image.asset(
                        'Assets/Images/waiting.png',
                        fit: BoxFit.cover,
                      )),
                ],
              );
            },
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Container(
                child: Card(
                  elevation: 5,
                  margin: EdgeInsets.symmetric(
                    vertical: 5,
                    horizontal: 5,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Padding(
                          //padding aca es el espacio vacio hacia adentro en el circulo.
                          padding: EdgeInsets.all(6),
                          child: Text('\$${transactions[index].amount}')),
                    ),
                    title: Text(
                      transactions[index].title,
                      style: Theme.of(context).textTheme.title,
                    ),
                    subtitle: Text(
                        DateFormat.yMMMd().format(transactions[index].date)),
                    //si el tamaño del ancho de pantalla es mayor a 360 entonces
                    //mostra el texto delete al lado del tacho de basura, sino no.
                    trailing: MediaQuery.of(context).size.width > 360
                        ? FlatButton.icon(
                            onPressed: () => deleteTx(transactions[index].id),
                            icon: Icon(Icons.delete),
                            textColor: Theme.of(context).errorColor,
                            label: Text('Delete'),
                          )
                        : IconButton(
                            icon: Icon(Icons.delete),
                            color: Theme.of(context).errorColor,
                            onPressed: () => deleteTx(transactions[index].id),
                          ),
                  ),
                ),
              );
            },
            itemCount: transactions.length,
          );
  }
}

// #region Opcion diferente para mostrar las cards
//Esta era otra opcion diferente para mostrar las cards,
//en lugar de circulos usa cuadrados y un estilo algo distinto.
//
//Esto iria en el lugar de listTile
//
// return Card(
//   child: Row(
//     children: <Widget>[
//       Container(
//         margin:
//             EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//         decoration: BoxDecoration(
//           border: Border.all(
//             color: Colors.purple,
//             width: 2,
//           ),
//         ),
//         padding: EdgeInsets.all(10),
//         child: Text(
//           //la notacion que sigue es string interpolation
//           //es similar a hacer: '\$' + tx.amount.toString()
//           '\$${transactions[index].amount.toStringAsFixed(2)}',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 20,
//             color: Colors.purple,
//           ),
//         ),
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             transactions[index].title,
//             style: TextStyle(
//               fontSize: 16,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             DateFormat('dd-MMM-yyyy')
//                 .format(transactions[index].date),
//             style: TextStyle(color: Colors.grey),
//           ),
//         ],
//       ),
//     ],
//   ),
// );
// #endregion
