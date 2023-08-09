import 'dart:convert';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/facade/modelo/ListaAutoWS.dart';
import 'package:carrito/servicios/utiles/Utilidades.dart';

class ListaAutoFacade{
  conexion _conn = new conexion();
  Utilidades _util = new Utilidades();
  Future<ListaAutoWS> listaAuto() async{
    String token = await _util.getValue("token") as String;
    var response = await _conn.solicitudGet('autos/disponibles', token);
    return _response((response.code != 0)? response.info: null);
  }
}

ListaAutoWS _response(dynamic data){
  var sesion = ListaAutoWS();
  if(data!=null){
    Map<String, dynamic> mapa = jsonDecode(data);
    if(mapa.containsKey("info")){
      List datos = jsonDecode(jsonEncode(mapa["info"]));
      sesion = ListaAutoWS.fromMap(datos, mapa["msg"], int.parse(mapa["code"].toString()));
    }else{
      List myList = List.empty();
      sesion = ListaAutoWS.fromMap(myList, mapa["msg"], int.parse(mapa["code"].toString()));
    }
  }
  return sesion;
}