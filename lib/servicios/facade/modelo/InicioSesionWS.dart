import 'package:carrito/servicios/modelo/RespuestaGenerica.dart';

class InicioSesionWS extends RespuestaGenerica{
  String token = '';
  String user = '';
  String correo = '';
  InicioSesionWS({this.token='', this.correo='', this.user='' });
  InicioSesionWS.fromMap(Map<dynamic, dynamic> mapa, int code, String msg){
    if(mapa.isEmpty){
      token = "";
      user = "";
      correo = "";
    }else{
      token = mapa["token"];
      user = mapa["user"];
      correo = mapa["correo"];
    }
    this.msg = msg;
    this.code = code;
  }
}