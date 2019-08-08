import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

//reais_por_dollar
//reais_por_euro
const request = "https://api.hgbrasil.com/finance?format=json&key=49699d9c";

void main() async {
  runApp(new MyApp());
}

Future<Map> recebeDados() async {
  http.Response resposta = await http.get(request);
  return json.decode(resposta.body);
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Generated App',
      theme: new ThemeData(
        //primarySwatch: Colors.blue,
        hintColor: Colors.amber,
        primaryColor: const Color(0xFF2196f3),
        //accentColor: const Color(0xFF2196f3),
        //canvasColor: const Color(0xFFfafafa),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double reais_por_dolar = 0.0;
  double reais_por_euro = 0.0;

  void _clearfields() {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  void _changeReal(String texto) {
    if (texto.isEmpty) {
      _clearfields();
      return;
    }
    double real = double.parse(texto);
    dolarController.text = (real / reais_por_dolar).toStringAsFixed(2);
    euroController.text = (real / reais_por_euro).toStringAsFixed(2);
  }

  void _changeDolar(String texto) {
    if (texto.isEmpty) {
      _clearfields();
      return;
    }
    double dolar = double.parse(texto);
    double real = dolar * reais_por_dolar;
    realController.text = (real).toStringAsFixed(2);
    euroController.text = (real / reais_por_euro).toStringAsFixed(2);
  }

  void _changeEuro(String texto) {
    if (texto.isEmpty) {
      _clearfields();
      return;
    }
    double euro = double.parse(texto);
    double real = euro * reais_por_euro;
    realController.text = (real).toStringAsFixed(2);
    dolarController.text = (real / reais_por_dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Conversor de Moedas - AlanLab'),
        ),
        body: FutureBuilder<Map>(
            future: recebeDados(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return Center(
                      child: Text(
                    "Carregando Dados...",
                    style: TextStyle(color: Colors.amber, fontSize: 25.0),
                    textAlign: TextAlign.center,
                  ));
                default:
                  if (snapshot.hasError) {
                    return Center(
                        child: Text(
                      "Erro ao Carregar Dados :(",
                      style: TextStyle(color: Colors.amber, fontSize: 25.0),
                      textAlign: TextAlign.center,
                    ));
                  } else {
                    reais_por_dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                    reais_por_euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];

                    return SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      padding: const EdgeInsets.all(10.0),
                      child: new Column(
                          //mainAxisAlignment: MainAxisAlignment.start,
                         // mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: <Widget>[
                            new Icon(Icons.monetization_on,
                                color: Colors.blue, size: 48.0),
                            new Divider(),
                            new TextField(
                              controller: realController,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Real',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                prefixText: 'R\$  ',
                              ),
                              onChanged: _changeReal,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                            new Divider(),
                            new TextField(
                              controller: dolarController,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Dolar',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                prefixText: 'US\$  ',
                              ),
                              onChanged: _changeDolar,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                            new Divider(),
                            new TextField(
                              controller: euroController,
                              style: new TextStyle(
                                fontSize: 20.0,
                                color: Colors.black,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Euro',
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                                prefixText: 'EU\$  ',
                              ),
                              onChanged: _changeEuro,
                              keyboardType: TextInputType.numberWithOptions(
                                  decimal: true),
                            ),
                            new Divider(),
                          ]),
                    );
                  }
              }
            }));
  }
}
