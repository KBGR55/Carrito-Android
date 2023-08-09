import 'dart:convert';
import 'dart:developer';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/facade/modelo/InicioSesionWS.dart';
import 'package:carrito/servicios/modelo/RespuestaGenerica.dart';

class InicioSesionFacade{
  conexion conn = new conexion();
  Future<InicioSesionWS> inicioSesion(Map<dynamic, dynamic> mapa)async{
    log("InicioSesionFacade");
    RespuestaGenerica response = await conn.solicitudPost('sesion', mapa, "NO");
    return _response((response.code == 200) ? response.info : null);
  }
}

InicioSesionWS _response(dynamic data){
  var sesion = InicioSesionWS();
  if(data != null){
    Map<String, dynamic> mapa = jsonDecode(data);
    log("InicioSesionFAcade: _response");
    log(mapa.toString());
    if(mapa.containsKey("info")){
      sesion = InicioSesionWS.fromMap(mapa["info"], mapa["code"], mapa["msg"]);
    }else{
      sesion = InicioSesionWS.fromMap(new Map(), mapa["code"], mapa["msg"]);
    }
  }
  return sesion;
}