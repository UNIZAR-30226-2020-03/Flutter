import 'package:flutter/material.dart';
import 'package:prototipo_sw/Profile.dart';
import 'package:prototipo_sw/home.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class ChangePass extends StatefulWidget {
  @override
  ChangePassState createState() {
    return ChangePassState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class ChangePassState extends State<ChangePass> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  var args;

  // Initially password is obscure
  bool _obscureText = true;
  String _oldPass, _password;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  Future update() async{
    Map data = {
        'nombre': args['nombre'],
        'apellidos': args['apellidos'],
        'contrasenya': _password,
        'correo': args['correo'],
        'username': args['username'],
        'pais': args['pais']
    };
    String email = args['correo'];
    var response = await http.put("https://upbeatproyect.herokuapp.com/usuario/update/$email",  
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {

    args = ModalRoute.of(context).settings.arguments;
   
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
              decoration:  InputDecoration(
                labelText: 'Contraseña antigua *',
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
              validator: (val){
                var ret;
                if (val.length < 6) {
                  ret = 'Contraseña demasiado corta( 6 caracteres como mínimo).';
                } 
                if(val != args['contrasenya']){
                  ret = 'Contraseña errónea';
                }
                return ret;
              },
              onChanged: (val) => _oldPass = val,
              obscureText: _obscureText,
            ),
            TextFormField(
              decoration:  InputDecoration(
                labelText: 'Nueva Contraseña *',
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
            TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Repetir nueva contraseña *',
                    icon: const Padding(
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
                    )
                  ),
                  validator: (val) {
                    var ret;
                    if (val.length < 6) {
                      ret = 'Contraseña demasiado corta( 6 caracteres como mínimo).';
                    } 
                    if(val != _password){
                      ret = 'Las contraseñas no coinciden';
                    }
                    return ret;
                  },
                  obscureText: _obscureText,
                ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Mostrar" : "Ocultar")),
            Center(
              child: RaisedButton(
                onPressed: ()  {
                  // devolverá true si el formulario es válido, o falso si
                  // el formulario no es válido.
                  if (_formKey.currentState.validate()) {
                    update();
                  }
                  else if (!_formKey.currentState.validate()) {
                    Scaffold.of(context).
                    showSnackBar(
                        SnackBar(content: Text('Incorrect credentials')));
                  }
                },
                child: Text('Actualizar contraseña'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}