import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:carrito/servicios/modelo/RespuestaGenerica.dart';
class conexion  {
  final String NAME = "conexion";
  final String URL_BASE = "http://192.168.140.140:3006/api/";
  static String URL = "http://192.168.140.140:3006/api";
  static String NO_TOKEN = "NO";

  Future<RespuestaGenerica> solicitudPost(String dir_recurso, Map<dynamic, dynamic> data,String token) async{
    log("${this.NAME}:Solicitud en Post");
    Map<String, String> _header = {'Content-Type':'application/json'};
    if(token != NO_TOKEN){
      _header = {'Content-Type':'applicaion/json', 'x-api-token': token};
    }
    final String url = URL_BASE+dir_recurso;
    final uri = Uri.parse(url);
    try{
      final response = await http.post(uri, headers: _header, body: jsonEncode(data));
      log(response.body);
      log(response.statusCode.toString());
      if(response.statusCode != 200){
        return _responseJson(0, response.body, "No data");
      }else{
        return _responseJson(200, response.body, "Ok");
      }
    }catch(e){
      Map<dynamic, dynamic> mapa = {"info": e.toString()};
      return _responseJson(0, mapa, "Hubo un error");
    }
  }

  Future<RespuestaGenerica> solicitudGet(String dir_recurso, String token) async{
    log("${this.NAME}:Solicitud en Get");
    Map<String, String> _header = {'Content-Type':'application/json'};
    if(token != NO_TOKEN){
      _header = {'Content-Type':'applicaion/json', 'x-api-token': token};
    }
    final String url = URL_BASE+dir_recurso;
    final uri = Uri.parse(url);
    log(url);
    try{
      final response = await http.get(uri, headers: _header);
      log(response.body);
      log(response.statusCode.toString());
      if(response.statusCode != 200){
        return _responseJson(200, response.body, "No data");
      }else{
        return _responseJson(200, response.body, "Ok");
      }
    }catch(e){
      Map<dynamic, dynamic> mapa = {"info": e.toString()};
      return _responseJson(0, mapa, "Hubo un error");
    }
  }

  RespuestaGenerica _responseJson(int code, dynamic data, String msg){
    var respuesta = RespuestaGenerica();
    respuesta.code = code;
    respuesta.msg = msg;
    respuesta.info = data;
    return respuesta;
  }
}

