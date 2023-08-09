import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MenuBarP extends StatelessWidget {
  const MenuBarP({super.key});
  @override
  Widget build(BuildContext context) {

    return PopupMenuButton(

        itemBuilder: (context){
          return [

            PopupMenuItem<int>(
              value: 3,
              child: Text("inicio"),

            ),
            PopupMenuItem<int>(
              value: 0,
              child: Text("Carrito de compras"),
            ),

            PopupMenuItem<int>(
              value: 1,
              child: Text("Mi cuenta"),
            ),

            PopupMenuItem<int>(
              value: 2,
              child: Text("Cerrar sesion"),

            ),
          ];
        },
        onSelected:(value){
          if(value == 0){
            Navigator.pushNamed(context, '/carrito');
            //print("My account menu is selected.");
          }else if(value == 1){
            print("Settings menu is selected.");
          }else if(value == 2){
            Utilidades util = Utilidades();
            util.removeAllValue();
            final SnackBar mensaje = SnackBar(content: Text('Hasta luego!'));
            ScaffoldMessenger.of(context).showSnackBar(mensaje);
            Navigator.pushNamed(context, '/home');
          } else if(value == 3) {
            Navigator.pushNamed(context, '/principal');
          }
        }
    );
  }
}