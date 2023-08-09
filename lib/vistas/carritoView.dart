import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/facade/modelo/CarritoWS.dart';
import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:carrito/vistas/MenuBarP.dart';
import 'package:flutter/material.dart';

import '../servicios/modelo/RespuestaGenerica.dart';

/// Flutter code sample for [DataTable].
class carreitoView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _carreitoView();
  }
}

class _carreitoView extends State<carreitoView> {

  var refreshKey = GlobalKey<RefreshIndicatorState>();
  double subtotal = 0.0;
  double iva = 0.0;
  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _listar();
    _sumar();
    //fetchCartData();
  }

  Future<List<CarritoWS>> _listar() async {
    double total = 0.0;
    double subTotal = 0.0;
    double iva = 0.0;
    List<CarritoWS> lista = [];
    Utilidades u = new Utilidades();
    String datos = await u.getCarrito();
    Map<dynamic, dynamic> mapa = jsonDecode(datos);
    for (Map<dynamic, dynamic> v in mapa.values) {
      CarritoWS c = CarritoWS.fromMap(v);
      lista.add(c);
      total += c.pt;
      subTotal = c.ptc;
      iva = c.iva;
    }
    this.total = total;
    this.subtotal = subTotal;
    this.iva = iva;
    return lista;
  }

  void _sumar() async {
    await _listar();
    setState(() {
      subtotal = subtotal;
      iva = iva;
      total=subtotal+iva;
    });
  }
  void _pagar() async{
    Map<dynamic, dynamic> data = {
      'amount': total,
    };

    Utilidades u = new Utilidades();
    conexion conn = new conexion();

    RespuestaGenerica response = await conn.solicitudPost("checkout/guardar", data, "NO");
    var sss = response.msg;
    Map<String, dynamic> mapa = jsonDecode(response.info);
    Map<String, dynamic> info = mapa["info"];  // Accede directamente al mapa "info"
    if(response.code != 200){
      //log("AQUI 1");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.msg),),);
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(response.msg),),);
      // Acceder al campo 'id' dentro de la estructura anidada
      var checkoutId = info["result"]["id"];
      u.saveCheckoutId(checkoutId);
      Navigator.pushNamed(context, '/creditCard');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Carrito de compras"),
        elevation: 10,
        automaticallyImplyLeading: false,
        actions: const [MenuBarP()],
      ),
      body: Column(
        children: [
          ClipOval(
            child: Image(
              image: NetworkImage(
                  'https://images.vexels.com/media/users/3/200097/isolated/preview/942820836246f08c2d6be20a45a84139-icono-de-carrito-de-compras-carrito-de-compras.png'),
              alignment: Alignment.center,
              width: 100,
              height: 100,
            ),
          ),
          Container(
            child: const Text(
              "Carrito de compras",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.teal,
                  fontWeight: FontWeight.w500,
                  fontSize: 30),
            ),
            padding: const EdgeInsets.all(20),
          ),
          Flexible(
            child: FutureBuilder(
              key: refreshKey,
              future: _listar(),
              builder: (context, snapshot) {
                //log("dddd"+snapshot.toString());
                if (!snapshot.hasData) {
                  return Center(
                      child:
                      Text('El carrito esta cargado o no tiene productos'));
                  //return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData) {
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    verticalDirection: VerticalDirection.down,
                    children: <Widget>[
                      Flexible(
                        child: Container(
                            padding: EdgeInsets.all(5),
                            child: dataBody(context,snapshot.data)),
                      )
                    ],
                  );
                }

                return Center();
              },
            ),
          ),
          Flexible(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                verticalDirection: VerticalDirection.down,
                children: [
                  Expanded(
                    child: Container(
                        padding: EdgeInsets.all(5),
                        child: dataFooter(subtotal, iva, total)),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      onPressed: () {
                        _pagar();
                      },
                      child: Text('Pagar'),
                    ),
                  ),
                ],
              ))
        ],
      ),
    );
  }
}

SingleChildScrollView dataBody(BuildContext context, List<CarritoWS>? listSales) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: DataTable(
      headingRowColor: MaterialStateColor.resolveWith(
            (states) {
          return Colors.black;
        },
      ),
      columnSpacing: 12,
      dividerThickness: 5,
      dataRowMaxHeight: 80,
      dataTextStyle:
      const TextStyle(fontStyle: FontStyle.normal, color: Colors.black),
      headingRowHeight: 50,
      headingTextStyle:
      const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
      horizontalMargin: 10,
      showBottomBorder: true,
      showCheckboxColumn: false,
      columns: [
        DataColumn(
            label: Expanded(child: Center(child: Text("cant"))),
            numeric: true,
            tooltip: "Cantidad"),
        DataColumn(
          label: Expanded(child: Center(child: Text("Detalle"))),
          numeric: false,
          tooltip: "Detalle",
        ),
        DataColumn(
          label: Expanded(child: Center(child: Text("PU"))),
          numeric: true,
          tooltip: "Precio unitario",
        ),
        DataColumn(
          label: Expanded(child: Center(child: Text("PT"))),
          numeric: true,
          tooltip: "Precio total",
        ),
        DataColumn(
          label: Expanded(child: Center(child: Text("Acciones"))),
          numeric: false,
          tooltip: "Acciones",
        ),
      ],
      rows: listSales!
          .map(
            (sale) => DataRow(
            onSelectChanged: (b) {
              log(sale.toString());
            },
            cells: [
              DataCell(
                  Text(sale.cant.toString(), textAlign: TextAlign.center)),
              DataCell(
                Text(sale.desc, textAlign: TextAlign.center),
              ),
              DataCell(
                Text("\$" + sale.pu.toString(),
                    textAlign: TextAlign.center),
              ),
              DataCell(
                Text("\$" + sale.pt.toString(),
                    textAlign: TextAlign.center),
              ),
              DataCell(
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.add),
                      onPressed: () {
                        Utilidades u = new Utilidades();
                        u.ajustarCantidad(sale, true);
                        Navigator.pushNamed(context, '/carrito');
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.remove),
                      onPressed: () {
                        Utilidades u = new Utilidades();
                        u.ajustarCantidad(sale, false);
                        Navigator.pushNamed(context, '/carrito');
                      },
                    ),
                  ],
                ),
              ),

            ]),
      )
          .toList(),
    ),
  );
}

GridView dataFooter(double subtotal, double iva, double total) {
  return GridView.count(
    crossAxisCount: 2,
    mainAxisSpacing: 10.0,
    crossAxisSpacing: 10.0,
    childAspectRatio: 4.0,
    children: [
      Container(
          child: Text('SUBTOTAL',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          alignment: Alignment.centerRight),
      Container(
          child: Text("\$" + subtotal.toStringAsFixed(2)),
          alignment: Alignment.centerRight),
      Container(
          child: Text('IVA',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          alignment: Alignment.centerRight),
      Container(
          child: Text("\$" + iva.toStringAsFixed(2)),
          alignment: Alignment.centerRight),
      Container(
          child: Text('TOTAL',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontSize: 15)),
          alignment: Alignment.centerRight),
      Container(
          child: Text("\$" + total.toStringAsFixed(2)),
          alignment: Alignment.centerRight),
    ],
  );
}