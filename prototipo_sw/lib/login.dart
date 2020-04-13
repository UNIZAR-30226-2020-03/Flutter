import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'model/usuario.dart';

class Login extends StatefulWidget {
  @override
  LoginState createState() {
    return LoginState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class LoginState extends State<Login> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;
  String _email, _password;

  // Toggles the password show status
    void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future<Usuario> futureUsuario;

  signIn() async{
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/get/$_password/$_email');
    SharedPreferences sharedPreferences= await SharedPreferences.getInstance();
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      var jsonData = json.decode(response.body);
      print(jsonData['username']);
      setState(() {
        sharedPreferences.setString("token", jsonData['token']);
        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (BuildContext context) => Home()),(Route<dynamic> route) => false);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Correo o contraseña incorrectos');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Cree un widget Form usando el _formKey que creamos anteriormente
    return Scaffold(
      appBar: AppBar(
      centerTitle: true,
      title: Center(
          child: AppBarImage()
      ),
    ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.alternate_email, color: Colors.cyan),
                hintText: 'example@gmail.com',
                labelText: 'Email',
                //font:
              ),
              onChanged: (val) => _email = val,
              validator: (String value) {
                if (!value.contains('@')) {
                  return 'Por favor, introduce un email válido';
                }
              },
            ),
            TextFormField(
              decoration:  InputDecoration(
                labelText: 'Contraseña',
                icon:  Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: const Icon(Icons.lock, color: Colors.cyan)
                ),
                suffixIcon: IconButton(
                  icon : Icon(_obscureText ? Icons.remove_red_eye : Icons.visibility_off),
                  color : Colors.blueGrey ,
                  onPressed: (){
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
              validator: (val) => val.length < 6 ? 'Contraseña demasiado corta( 6 caracteres como mínimo).' : null,
              onChanged: (val) => _password = val,
              obscureText: _obscureText,
            ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Mostrar" : "Ocultar")),
            Center(
              child: RaisedButton(
                onPressed: () async {
                  // devolverá true si el formulario es válido, o falso si
                  // el formulario no es válido.
                  if (_formKey.currentState.validate()) {
                    futureUsuario = signIn();
                  }
                  else if (!_formKey.currentState.validate()) {
                    Scaffold.of(context).
                    showSnackBar(
                        SnackBar(content: Text('Incorrect credentials')));
                  }
                },
                child: Text('Iniciar Sesión'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}