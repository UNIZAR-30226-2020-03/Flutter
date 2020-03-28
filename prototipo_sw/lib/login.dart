import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:prototipo_sw/main.dart';

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
              onSaved: (val) => _email = val,
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
                  child: const Icon(Icons.lock, color: Colors.cyan)),
                suffixIcon: IconButton(
                    icon : Icon(_obscureText ? Icons.remove_red_eye : Icons.visibility_off),
                    color : Colors.blueGrey ,
                    onPressed: (){
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    ),),
              validator: (val) => val.length < 6 ? 'Contraseña demasiado corta( 6 caracteres como mínimo).' : null,
              onSaved: (val) => _password = val,
              obscureText: _obscureText,
            ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Mostrar" : "Ocultar")),
            Center(
              child: RaisedButton(
                onPressed: () {
                  // devolverá true si el formulario es válido, o falso si
                  // el formulario no es válido.
                  if (_formKey.currentState.validate()) {
                    // Si el formulario es válido, queremos mostrar un Snackbar
                    Scaffold.of(context).
                    showSnackBar(SnackBar(content: Text('Processing Data')));
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home(), fullscreenDialog: true));
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