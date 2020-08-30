import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  // aqui se almacena el puntero a la funcion pasada como parametro al constructor
  final Function addNewTx;

  NewTransaction(this.addNewTx);
  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime _selectedDate;

  // #region Comentario
  //Esta funcion se encarga de validar que se haya encontrado un texto y guarda el mismo
  //en las variables dadas, ademas se verifica si las mismas cumplen las condiciones
  //requeridas, si no las cumple se sale de la funcion con return, si las cumple se
  //llama a addNewTx con los valores ingresados por el usuario
  // #endregion
  void _submitData() {
    if (_amountController.text.isEmpty) {
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    //little validation
    if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
      return;
    }

    // widget te da acceso a la funcion addNewTx que esta en statefullwidget.
    widget.addNewTx(
      _titleController.text,
      double.parse(_amountController.text),
      _selectedDate,
    );

    //Esta parte lo que hace es cerrar la ventanita que se abrio con el widget.
    //Te cierra la ventanita de entrada de datos al llegar a esta linea (boton ok)
    Navigator.of(context).pop();
  }

  void _presentDatePicker() {
    //esto habilita seleccionar una fecha y then indica la funcion a realizar.
    //lo piola de then es que no es bloqueante.
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2017),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        //el usuario pulso cancelar
        return;
      }
      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //contenido scrolleable con todas las tarjeras
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          //aqui con padding lo que se busca es tener en consideracion el tamaño del
          //panel que aparece en la app para el teclado.
          padding: EdgeInsets.only(
              top: 10,
              left: 10,
              right: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                onSubmitted: (_) => _submitData(),
              ),
              // onSubmitted de esta forma es para que al apretar enter al escribir
              // el texto te lo tome como un enter.
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                onSubmitted: (_) => _submitData(),
              ),
              Container(
                //height para darle espacio respecto de los text inputs.
                height: 70,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(_selectedDate == null
                          ? 'No Date Chosen!'
                          : 'Picked Day: '
                              '${DateFormat('dd-MMM-yyyy').format(_selectedDate)}'),
                    ),
                    FlatButton(
                      textColor: Theme.of(context).primaryColor,
                      child: Text(
                        'Choose Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      onPressed: _presentDatePicker,
                    ),
                  ],
                ),
              ),
              RaisedButton(
                child: Text('Add Transaction'),
                color: Theme.of(context).primaryColor,
                textColor: Theme.of(context).textTheme.button.color,
                onPressed: _submitData,
              )
            ],
          ),
        ),
      ),
    );
  }
}
