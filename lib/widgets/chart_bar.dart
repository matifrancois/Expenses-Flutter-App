import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPctOfTotal;

  ChartBar(this.label, this.spendingAmount, this.spendingPctOfTotal);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (ctx, constraints) {
        return Column(
          children: <Widget>[
            // #region Comentario
            //
            //fittedBox cambia el tamaño del texto para que pueda entrar en el tamaño
            //que se tiene, trabaja en conjunto con el flexfit en chart_bar, es decir
            //flexfit impide que se sobrepase el tamaño que se le otorga al hijo incluso
            //cuando este lo necesita, y fittedbox se encarga de que si no alcanza el
            //espacio disminuir la letra para que entre.
            // #endregion
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(
                child: Text('\$${spendingAmount.toStringAsFixed(0)}'),
              ),
            ),
            //espaciado
            SizedBox(
              height: constraints.maxHeight * 0.05,
            ),
            //todo lo que sigue crea las barras de proporcion de gastos semanales
            Container(
              height: constraints.maxHeight * 0.5,
              width: 10,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey, width: 1.0),
                      color: Color.fromRGBO(220, 220, 220, 1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  FractionallySizedBox(
                    heightFactor: spendingPctOfTotal,
                    child: Container(
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            //espacido
            SizedBox(
              height: 4,
            ),
            //Testo con la letra del dia
            Container(
              height: constraints.maxHeight * 0.15,
              child: FittedBox(child: Text(label)),
            ),
          ],
        );
      },
    );
  }
}
