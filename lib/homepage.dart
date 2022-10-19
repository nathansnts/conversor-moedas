import 'package:cripto_moedas_2/main.dart';
import 'package:flutter/material.dart';

// ignore: camel_case_types
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

//Controladores para captura de valor durante o input
final TextEditingController _realController = TextEditingController();
final TextEditingController _dolarController = TextEditingController();
final TextEditingController _euroController = TextEditingController();

//Variável para cada moeda
double? real;
double? dolar;
double? euro;

//Funcoes de conversao de cada moeda
void _onchangedReal(String tx) {
  var re = double.tryParse(tx);
  if (tx.isNotEmpty) {
    _dolarController.text = (re! / dolar!).toStringAsFixed(2);
    _euroController.text = (re / euro!).toStringAsFixed(2);
  } else {
    _cleanAll();
  }
}

void _onchangedDolar(String tx) {
  var dol = double.tryParse(tx);
  if (tx.isNotEmpty) {
    _realController.text = (dolar! * dol!).toStringAsFixed(2);
    _euroController.text = (dolar! * dol / euro!).toStringAsFixed(2);
  } else {
    _cleanAll();
  }
}

void _onchangedEuro(String tx) {
  var eu = double.tryParse(tx);
  if (tx.isNotEmpty) {
    _realController.text = (euro! * eu!).toStringAsFixed(2);
    _dolarController.text = (euro! * eu / dolar!).toStringAsFixed(2);
  } else {
    _cleanAll();
  }
}

void _cleanAll() {
  _realController.clear();
  _dolarController.clear();
  _euroController.clear();
}

// ignore: camel_case_types
class _homepageState extends State<homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversor de criptomoedas'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 192, 59, 117),
      ),
      body: FutureBuilder<Map>(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting ||
              snapshot.connectionState == ConnectionState.none) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 9,
                ),
                Center(
                  child: Text(
                    'Carregando Dados...',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.00,
                      color: Color(0xFF393C3F),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(
                  Icons.error_outline,
                  size: 33.00,
                  color: Color(0xFFF55742),
                ),
                Divider(
                  color: Color(0xFFFFFFFF),
                ),
                Center(
                  child: Text(
                    'Falha ao obter os dados'
                    '\nVerifique sua conexão!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.00,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }

          //real = snapshot.data!['results']['currencies']['BRL']['buy'];
          dolar = snapshot.data!['results']['currencies']['USD']['buy'];
          euro = snapshot.data!['results']['currencies']['EUR']['buy'];
          return SingleChildScrollView(
            padding: const EdgeInsets.all(11.00),
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Icon(
                    Icons.monetization_on,
                    size: 90,
                    color: Color(0xFFECB719),
                  ),
                  const SizedBox(
                    height: 10.00,
                  ),
                  //Passagem de parâmetros para composição de cada input com suas características
                  buildTextField(
                      'Real', 'R\$ ', _realController, _onchangedReal),
                  const Divider(
                    color: Color(0xFFFFFFFF),
                  ),
                  buildTextField(
                      'Dolar', 'U\$ ', _dolarController, _onchangedDolar),
                  const Divider(
                    color: Color(0xFFFFFFFF),
                  ),
                  buildTextField('Euro', '€ ', _euroController, _onchangedEuro)
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

//Contruindo um textfield para ser reutilizado em mais de um input de dados
Widget buildTextField(
    String label, String prefix, TextEditingController ct, f) {
  return TextField(
    controller: ct,
    keyboardType: TextInputType.number,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      prefixText: prefix,
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        borderSide: BorderSide(
          color: Color(0xFFF55742),
        ),
      ),
    ),
    onChanged: f,
  );
}
