import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:ui';

/*class Estado {
  static const String vendido = 'VENDIDO';
  static const String disponible = 'DISPONIBLE';
  static const String reparacion = 'REPARACION';
}*/

class AutosWS {
  String modelo = '';
  String external_id = '';
  String placa = '';
  String color = '';
  //String duenio = '';
  String foto = '';
  int anio= 0;
  String marca = '';
  String pais= '';
  double costo = 0.0;
  //String estado = Estado.disponible;
  AutosWS();

  AutosWS.fromMap(Map<dynamic, dynamic> mapa){
    modelo = mapa ['marca']['modelo'];
    external_id = mapa ['external_id'];
    foto = mapa ['foto'];
    placa = mapa ['placa'];
    color = mapa ['color'];
    marca = mapa ['marca']['nombre'];
    pais = mapa ['marca']['pais'];
    costo = double.parse(mapa ['costo'].toString());
    anio = int.parse(mapa ['anio'].toString());


  }

  static Map<String, dynamic> toMap(AutosWS model) =>
      <String, dynamic> {
        "modelo": model.modelo,
        "external_id": model.external_id,
        "costo": model.costo,
        "anio": model.anio,
        "marca": model.marca,
        "placa": model.placa,
        "foto": model.foto,
        "pais": model.pais,
        "color": model.color
      };

  static String serialize(AutosWS model) =>
      json.encode(AutosWS.toMap(model));
}