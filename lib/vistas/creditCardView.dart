import 'dart:async';
import 'dart:convert';

import 'package:carrito/servicios/conexion.dart';
import 'package:carrito/servicios/utiles/Utilidades.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class creditCardView extends StatefulWidget {
  const creditCardView({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _creditCardViewState();
  }
}

class _creditCardViewState extends State<creditCardView> {
  Utilidades u = new Utilidades();
  late String? checkoutId;

  @override
  void initState() {
    super.initState();
    checkCheckoutId();
  }

  void checkCheckoutId() async {
    checkoutId = await u.getCheckoutId();
    setState(() {}); // Actualiza el estado para que se cargue el HTML
  }

  String getHtmlWithCheckoutId() {
    return """<!DOCTYPE html>
<html lang="en">

<head>
    <style id="customPageStyle">
        body {
            background-color: #f6f6f5;
        }
    </style>
    <style>
        .centrar {
            margin-right: 150px;
            margin-left: 100px;
            border: 1px solid #808080;
            padding: 10px;
        }
    </style>
    <script src="https://eu-test.oppwa.com/v1/paymentWidgets.js?checkoutId=$checkoutId"></script>
</head>

<body>
    <div class="centrar">
        <form action="https://flutter.dev" class="paymentWidgets" data-brands="VISA MASTER"></form>
    </div>
</body>

</html>
<html>""";
  }
  final Completer<WebViewController> _controller = Completer<WebViewController>();
  void cargarHtml() async {
    final url = Uri.dataFromString(
      getHtmlWithCheckoutId(),
      mimeType: 'text/html',
      encoding: Encoding.getByName('utf-8'),
    ).toString();

    final webViewController = await _controller.future;
    webViewController.loadUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Compra Exitosa'),
                  content: Text('¡Compra realizada con éxito!'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        u.eliminarCarrito();
                        Navigator.pushNamed(context, '/home'); // Cerrar el diálogo
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          },
          child: const Text('Credit Card'),
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
          cargarHtml();
        },
      ),
    );
  }
}