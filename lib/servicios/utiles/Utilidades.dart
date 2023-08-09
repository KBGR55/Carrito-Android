import 'dart:convert';
import 'package:carrito/servicios/facade/modelo/AutosWS.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../facade/modelo/CarritoWS.dart';

class Utilidades {
  final _storage = const FlutterSecureStorage();

  Future<String?> getValue(valor) async {
    return await _storage.read(key: valor);
  }

  void saveValue(llave, valor) async {
    await _storage.write(key: llave, value: valor);
  }

  void removeAllValue() async {
    await _storage.deleteAll();
  }

  void eliminarCarrito() async {
    await _storage.delete(key: 'carrito');
  }

  void addCarrito(valor) async {
    var carrito = await _storage.read(key: 'carrito');

    if(carrito != null){
      Map<dynamic, dynamic> carro = jsonDecode(carrito.toString());

      var data = carro[valor.external_id];
      if(data != null){
        data['cant'] = data['cant']+1;
        carro[valor.external_id] = data;
        await _storage.write(key: 'carrito', value: jsonEncode(carro));
      }else{
        carro[valor.external_id] = {"valor": AutosWS.serialize(valor), "cant":1};
        await _storage.write(key: 'carrito', value: jsonEncode(carro));
      }
    }else{
      Map<dynamic, dynamic> carro = {};
      carro[valor.external_id] = {"valor": AutosWS.serialize(valor), "cant":1};
      await _storage.write(key: 'carrito', value: jsonEncode(carro));
    }
  }

  Future<String> getCarrito() async {
    var carrito = await _storage.read(key: 'carrito');
    //print(carrito);
    if(carrito != null){
      return carrito.toString();

    }
    return "";
  }

  void ajustarCantidad(CarritoWS producto, bool aumentar) async {
    var carrito = await _storage.read(key: 'carrito');

    if (carrito != null) {
      Map<dynamic, dynamic> carro = jsonDecode(carrito.toString());

      var data = carro[producto.external_id]; // Reemplaza con la propiedad correcta
      if (data != null) {
        if (aumentar) {
          data['cant'] = data['cant'] + 1;
        } else {
          if (data['cant'] > 1) {
            data['cant'] = data['cant'] - 1;
          } else {
            carro.remove(producto.external_id); // Elimina el producto si la cantidad es 1 o menos
          }
        }
        carro[producto.external_id] = data;
        await _storage.write(key: 'carrito', value: jsonEncode(carro));
        //_listar(); // Refresca la lista
      }
    }
  }
  //FACTURA
  Future<void> saveExternalFactura(String externalFactura) async {
    await _storage.write(key: "external_Factura", value: externalFactura);
  }

  Future<void> saveCheckoutId(String checkoutId) async {
    await _storage.write(key: "checkoutId", value: checkoutId);
  }

  Future<String?> getExternalFactura() async {
    return await _storage.read(key: "external_Factura");
  }

  Future<String?> getCheckoutId() async {
    return await _storage.read(key: "checkoutId");
  }

  Future<void> borrarFactura() async {
    await _storage.delete(key: "external_Factura");
    await _storage.delete(key: "checkoutId");
  }

  Future<void> saveIdentificacion(String identificacion) async {
    await _storage.write(key: "identificacion", value: identificacion);
  }

  Future<String?> getIdentificacion() async {
    return await _storage.read(key: "identificacion");
  }
}