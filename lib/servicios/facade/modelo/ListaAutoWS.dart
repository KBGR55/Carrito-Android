import 'package:carrito/servicios/modelo/RespuestaGenerica.dart';

import 'AutosWS.dart';

class ListaAutoWS extends RespuestaGenerica{
  late List<AutosWS> data = [];
  ListaAutoWS();
  ListaAutoWS.fromMap(List datos, String msg, int code){
    datos.forEach((item) {
      Map<dynamic, dynamic> mapa = item;
      AutosWS aux = AutosWS.fromMap(mapa);
      data.add(aux);
    });
    this.msg = msg;
    this.code = code;
  }
}