import 'package:flutter/material.dart';
import 'package:prototipo_sw/login.dart';
import 'package:prototipo_sw/main.dart';

class Register extends StatefulWidget {
  @override
  RegisterState createState() {
    return RegisterState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class RegisterState extends State<Register> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  // Initially password is obscure
  bool _obscureText = true;
  String _email, _username, _password;

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
                labelText: 'Email *',
                //font:
              ),
              onSaved: (val) => _email = val,
              validator: (String value) {
                if (!value.contains('@')) {
                  return 'Please enter a valid email';
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person, color: Colors.cyan),
                hintText: 'Juan1234',
                labelText: 'Username *',
                //font:
              ),
              onSaved: (val) => _username = val,
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Please enter a valid name';
                }
                else {
                  return '';
                }
              },
            ),
            TextFormField(
              decoration: const InputDecoration(
                  labelText: 'Password *',
                  icon: const Padding(
                      padding: const EdgeInsets.only(top: 15.0),
                      child: const Icon(Icons.lock, color: Colors.cyan,))),
              validator: (val) => val.length < 6 ? 'Password too short.' : null,
              onSaved: (val) => _password = val,
              obscureText: _obscureText,
            ),
            new FlatButton(
                onPressed: _toggle,
                child: new Text(_obscureText ? "Show" : "Hide")),
            Center(
              child: RaisedButton(
                onPressed: () {
                  // devolverá true si el formulario es válido, o falso si
                  // el formulario no es válido.
                  if (_formKey.currentState.validate()) {
                    // Si el formulario es válido, queremos mostrar un Snackbar
                    Scaffold.of(context).
                    showSnackBar(SnackBar(content: Text('Processing Data')));
                    Navigator.push(context, MaterialPageRoute(
                        builder: (context) => Login(), fullscreenDialog: true));
                  }
                  else if (!_formKey.currentState.validate()) {
                    Scaffold.of(context).
                    showSnackBar(
                        SnackBar(content: Text('Incorrect credentials')));
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}