import 'dart:developer';

import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:carrito/servicios/facade/InicioSesionFacade.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class registroView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _registroViewState();
  }
}

class _registroViewState extends State<registroView> {
  final _formKey = GlobalKey<FormState>();
  String tipo_iddent = "CEDULA";
  final TextEditingController idenControl = TextEditingController();
  final TextEditingController apeControl = TextEditingController();
  final TextEditingController nomControl = TextEditingController();
  final TextEditingController dirControl = TextEditingController();
  final TextEditingController correoControl = TextEditingController();
  final TextEditingController claveControl = TextEditingController();
  final Utilidades util = Utilidades();

  void _iniciar()  {

    setState(()  {
      if(_formKey.currentState!.validate()) {
        InicioSesionFacade sesion =  InicioSesionFacade();
        Map<dynamic, dynamic> mapa = {
          "dni":idenControl.text,
          "tipo": tipo_iddent,
          "direccion": dirControl.text,
          "apellidos": apeControl.text,
          "nombres" : nomControl.text,
          "email":correoControl.text,
          "clave": claveControl.text
        };
        //log(mapa.toString());
        /*sesion.registro(mapa).then((value) async {

          if(value.code == 200) {
            Widget toast = Container(

              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.green,
              ),
              child: const Text(
                "Se ha registrado correctamente",
                style: TextStyle(color: Colors.white),
              ),
            );
            FToast? fToast = FToast();
            fToast?.init(context);
            fToast?.showToast(
              child: toast,
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 3),
            );


            Navigator.pushNamed(context, '/home');
          } else {

            Widget toast = Container(

              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25.0),
                color: Colors.red,
              ),
              child:  Text(
                value.msg,
                style: TextStyle(color: Colors.white),
              ),
            );
            FToast? fToast = FToast();
            fToast?.init(context);
            fToast?.showToast(
              child: toast,
              gravity: ToastGravity.CENTER,
              toastDuration: const Duration(seconds: 3),
            );


          }
        }).catchError((error) {
          log("Hay un error");
          log(error.toString());
        });*/
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    util.getValue("token").then((value)  {
      if(value != null) {
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
              'Registro de usuarios',
              style: TextStyle(fontSize: 20),
            )),
        Container(
          padding: const EdgeInsets.all(10),
          child: DropdownButtonFormField(
            items: dropdownItemsI,
            decoration: InputDecoration(
              labelText: 'Tipo Identificacion',
              suffixIcon: Icon(Icons.bloodtype_rounded),
            ),
            validator: (value){
              if(value == null) {
                return 'Tipo Identifiacion requerida';
              }
              if(value!.trim().isEmpty) {
                return 'Tipo Identifiacion requerida';
              }
            }, onChanged: (String? value) {
             if(value != null) {
               setState(() {
                 this.tipo_iddent = value!;
               });
             }
          },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: idenControl,
            decoration: InputDecoration(
              labelText: 'Identificacion',
              suffixIcon: Icon(Icons.person),
            ),
            validator: (value){
              if(value!.trim().isEmpty) {
                return 'Identifiacion requerida';
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: apeControl,
            decoration: InputDecoration(
              labelText: 'Apellidos',
              suffixIcon: Icon(Icons.person_2),
            ),
            validator: (value){
              if(value!.trim().isEmpty) {
                return 'Apellidos requerida';
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: nomControl,
            decoration: InputDecoration(
              labelText: 'Nombres',
              suffixIcon: Icon(Icons.person_3),
            ),
            validator: (value){
              if(value!.trim().isEmpty) {
                return 'Nombres requerida';
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: dirControl,
            decoration: InputDecoration(
              labelText: 'Direccion',
              suffixIcon: Icon(Icons.umbrella),
            ),
            validator: (value){
              if(value!.trim().isEmpty) {
                return 'Direccion requerida requerida';
              }
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child: TextFormField(
            controller: correoControl,
            decoration: InputDecoration(
              labelText: 'Correo',
              suffixIcon: Icon(Icons.alternate_email),
            ),
            validator: (value){
              if(value!.isEmpty) {
                return 'Correo requerido';
              }
              if(!isEmail(value)) {
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
              labelText: 'Clave',
              suffixIcon: Icon(Icons.password),
            ),
            validator: (value){
              if(value!.isEmpty) {
                return 'Clave requerida';
              }
            },
          ),
        ),

        Container(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: ElevatedButton(
              child: const Text('Registrar'),
              onPressed: _iniciar,
            )),
        Row(
          children: <Widget>[
            const Text('Ya tienes cuenta'),
            TextButton(
              child: const Text(
                'Inicia sesion',
                style: TextStyle(fontSize: 20),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            )
          ],
          mainAxisAlignment: MainAxisAlignment.center,
        ),
      ],
    )));
  }
  List<DropdownMenuItem<String>> get dropdownItemsI{
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(child: Text("CEDULA"),value: "CEDULA"),
      DropdownMenuItem(child: Text("RUC"),value: "RUC"),
      DropdownMenuItem(child: Text("PASAPORTE"),value: "PASAPORTE"),

    ];
    return menuItems;
  }
}
