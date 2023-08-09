import 'dart:developer';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/facade/InicioSesionFacade.dart';
import 'package:carrito/servicios/facade/modelo/InicioSesionWS.dart';
import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class sessionView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _sessionViewState();
  }
}

class _sessionViewState extends State<sessionView> {
  final _formKey = GlobalKey<FormState>();
  //InicioSesionWS sesionWS = new InicioSesionWS();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  final Utilidades util = Utilidades();
  void _iniciar(){
    setState(()async {
      if(_formKey.currentState!.validate()){
        InicioSesionFacade sesion = new InicioSesionFacade();
        //conexion conn = new conexion();
        Map<dynamic, dynamic> mapa = {
          "usuario": correoControl.text,
          "clave": claveControl.text
        };
        sesion.inicioSesion(mapa).then((value) async{
          if (value.token != "") {
            log(value.correo);
            Utilidades util = new Utilidades();
            util.saveValue("token", value.token);
            final SnackBar mensaje = SnackBar(
                content: Text('Binevenido!! ' + value.user));
            ScaffoldMessenger.of(context).showSnackBar(mensaje);
            Navigator.pushNamed(context, '/principal', arguments: {"mensaje":"Hola"});
          } else {
            final SnackBar mensaje = SnackBar(content: Text(value.msg));
            ScaffoldMessenger.of(context).showSnackBar(mensaje);
          }

        }).catchError((error){
          log("Hay un error");
          log(error.toString());
        });
        //sesionWS = await sesion.inicioSesion(mapa);
        //log(sesionWS.msg);
       //conn.solicitudPost("sesion", mapa, "NO");
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    util.getValue("token").then((value){
      if(value != null){
        Navigator.pushNamed(context, '/principal');
      }
    });
    return Form(
      key: _formKey,
        child: Scaffold(
    body:
        ListView(
          padding: const EdgeInsets.all(32),
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  "Noche's cars",
                  style: TextStyle(
                      color: Colors.teal,
                      fontWeight: FontWeight.w500,
                      fontSize: 30),
                )),
            Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'Inicio de sesion',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              padding: const EdgeInsets.all(10),
              child: TextFormField(
                controller: correoControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Correo',
                  suffixIcon: Icon(Icons.alternate_email),
                ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Correo requerido';
                    }
                    if (!isEmail(value)) {
                      return 'Debe ser un correo valido';
                    }
                  },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
              child: TextFormField(
                obscureText: true,
                controller: claveControl,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Clave',
                ),
                validator: (value){
                  if(value!.isEmpty){
                    return'Clave requerida';
                  }
                },
              ),
            ),
            TextButton(
              onPressed: () {
                //forgot password screen
              },
              child: const Text('Forgot Password',),
            ),
            Container(
                height: 50,
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: ElevatedButton(
                  child: const Text('Iniciar'),
                  onPressed: _iniciar,
                    //print(nameController.text);
                    //print(passwordController.text
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text('No tienes cuenta?'),
                TextButton(
                  child: const Text(
                    'Crea una cuenta',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/registro');
                  },
                )
              ],
            ),
          ],
        )));
  }
}
