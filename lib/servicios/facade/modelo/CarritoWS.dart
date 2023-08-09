import 'dart:convert';
import 'dart:developer';

class CarritoWS{
  int cant = 0;
  double pu = 0.0;
  double ptc = 0.0;
  double pt = 0.0;
  double iva = 0.0;
  String desc = "";
  String envio = "";
  String external_id = "";
  CarritoWS();
  CarritoWS.fromMap(Map<dynamic, dynamic> mapa) {
    if (mapa.isNotEmpty) {
      Map<dynamic, dynamic> map = jsonDecode(mapa['valor']);
      cant = int.parse(mapa['cant'].toString());
      desc = 'Vehiculo: ' + map['marca']+ ' ' + map['modelo'] + ' ' + map['anio'].toString() + ' placa: ' + map['placa'];
      external_id = map['external_id'];
      pu = double.parse(map['costo'].toString());
      ptc = pu * cant;
      iva = ptc*0.12;
      pt=ptc+iva;
      envio = map['external_id'] + ':' + cant.toString();
    } else {
      log('El carrito está vacío en el mapa');
    }
    log('fin carritows');
  }

}