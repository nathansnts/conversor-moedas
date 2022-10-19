import 'package:cripto_moedas_2/homepage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const request = 'https://api.hgbrasil.com/finance?key=0b87a600';

void main() async {
  runApp(const MyApp());
}

Future<Map> getData() async {
  //Requisitando dados via api com a cotação das moedas
  http.Response response = await http.get(Uri.parse(request));
  //print(response.body);
  //print(jsonDecode(response.body)['results']['currencies']);
  return jsonDecode(response.body);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Aplicação Criptomoedas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: const homepage(),
    );
  }
}
