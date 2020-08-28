import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTransaction extends StatefulWidget {
  final Function addNewTx;

  NewTransaction(this.addNewTx);
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  void submitData() {
    final enteredTitle = titleController.text;
    final enteredAmount = double.parse(amountController.text);

    //little validation
    if (enteredTitle.isEmpty || enteredAmount <= 0) {
      return;
    }

    // widget te da acceso a la funcion addNewTx que esta en statefullwidget.
    widget.addNewTx(
      titleController.text,
      double.parse(amountController.text),
    );

    //Esta parte lo que hace es cerrar la ventanita que se abrio con el widget.
    //Te cierra la ventanita de entrada de datos al llegar a esta linea (boton ok)
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: titleController,
              onSubmitted: (_) => submitData(),
            ),
            // onSubmitted de esta forma es para que al apretar enter al escribir
            // el texto te lo tome como un enter.
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: amountController,
              keyboardType: TextInputType.number,
              onSubmitted: (_) => submitData(),
            ),
            Container(
              //height para darle espacio respecto de los text inputs.
              height: 70,
              child: Row(
                children: <Widget>[
                  Text('No Date Chosen!'),
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    child: Text(
                      'Choose Date',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
            RaisedButton(
              child: Text('Add Transaction'),
              color: Theme.of(context).primaryColor,
              textColor: Theme.of(context).textTheme.button.color,
              onPressed: submitData,
            )
          ],
        ),
      ),
    );
  }
}
