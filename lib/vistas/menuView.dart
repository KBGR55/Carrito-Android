import 'dart:developer';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/facade/ListaAutoFacade.dart';
import 'package:carrito/servicios/facade/modelo/AutosWS.dart';
import 'package:carrito/servicios/facade/modelo/ListaAutoWS.dart';
import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:carrito/vistas/MenuBarP.dart';
import 'package:carrito/vistas/sessionView.dart';
import 'package:flutter/material.dart';

class menuView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _menuViewState();
  }
}

class _menuViewState extends State<menuView> {
  Future<List<AutosWS>> _listar() async {
    ListaAutoFacade laf = ListaAutoFacade();
    ListaAutoWS lista = await laf.listaAuto();

    if (lista.code != 200) {
      Utilidades util = new Utilidades();
      util.removeAllValue();
      Navigator.pushNamed(context, '/home');
    }
    return lista.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Autos Disponibles",
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.w500, fontSize: 22),
        ),
        elevation: 10,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.tealAccent[50],
        actions: const [MenuBarP()],
      ),
      body: Container(
        padding: EdgeInsets.all(8),
        child: FutureBuilder<List<AutosWS>>(
          future: _listar(),
          initialData: [],
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            log(snapshot.toString());
           if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return AutosCard(snapshot.data[index]);
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}

class AutosCard extends StatelessWidget {
  AutosWS auto = AutosWS();
  AutosCard(AutosWS auto) {
    super.key;
    this.auto = auto;
    print(auto);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        color: Colors.white,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Image(
                  image: NetworkImage(conexion.URL + '/imagen/' + auto.foto)),
              title: Text(auto.marca + ' | ' + auto.modelo),
              subtitle: Text('Precio: ' +
                  auto.costo.toString() +
                  ' Año: ' +
                  auto.anio.toString()),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                TextButton(
                  child: const Text('Ver mas', ),
                  onPressed: () {},
                ),
                const SizedBox(width: 8),
                TextButton(
                  child: const Text('Añadir al carrito de compra'),
                  onPressed: () {
                    Utilidades u = new Utilidades();
                    var aux = auto;
                    u.addCarrito(aux);
                  },
                ),
                const SizedBox(width: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
