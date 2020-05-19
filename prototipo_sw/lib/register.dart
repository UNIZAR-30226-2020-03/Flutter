import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';


class ScreenArguments {
  final String email;
  final String pass;

  ScreenArguments(this.email, this.pass);
}

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
  bool _value1 = false;

  // Initially password is obscure
  bool _obscureText = true;
  String _email, _username, _name, _surname, _password, _description;
  Country _selected;

  // Toggles the password show status
  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  // Set Value from the checkbox
  void _value1Changed(bool value) => setState(() => _value1 = value);

  artistas(Map data) async {
    var jsonData = null;
    var response = await http.post("https://upbeatproyect.herokuapp.com/artista/save",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      setState(() {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (_) => false, arguments: ScreenArguments(_email, _password));
      });
    }
  }

  usuarios(Map data) async{
    var jsonData = null;
    var response = await http.post("https://upbeatproyect.herokuapp.com/usuario/save",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if(response.statusCode == 200){
      print("He entrado al decode");
      jsonData = json.decode(response.body);
      setState(() {
        Navigator.of(context).pushNamedAndRemoveUntil('home', (_) => false, arguments: ScreenArguments(_email, _password));
      });
    }
  }

  signUp() async {
    if (_value1){
      Map data = {
        'correo': _email,
        'nombre': _name,
        'apellidos': _surname,
        'pais': _selected.name,
        'username': _username,
        'contrasenya': _password,
        'nombre_artista': _username,
        'descripcion': _description
      };
      artistas(data);

    }
    else {
      print("He entrado a usuario");
      Map data = {
        'nombre': _name,
        'apellidos': _surname,
        'contrasenya': _password,
        'correo': _email,
        'username': _username,
        'pais': _selected.name,
      };
      print(_name);
      usuarios(data);
    }   
  }


  var image;
  String _path_image;

  void _openFileExplorer2() async {
    image = await FilePicker.getFile(
      type: FileType.image,
    );

    print('--------------------------------------');
    print(image.path);


    setState(() {
      _path_image=image.path;
      print(_path_image);
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
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: const Text("Registrarse como ARTISTA",style: TextStyle(fontSize: 16),),
                    ),
                    new Checkbox(value: _value1, onChanged: _value1Changed, activeColor: Colors.cyan,),
                  ],
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.alternate_email, color: Colors.cyan),
                    hintText: 'example@gmail.com',
                    labelText: 'Email *',
                    //font:
                  ),
                  onChanged: (val) => _email = val,
                  validator: (String value) {
                    if (!value.contains('@')) {
                      return 'Por favor, introduce un email válido';
                    }
                    else return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.cyan),
                    hintText: 'Juan',
                    labelText: 'Nombre *',
                    //font:
                  ),
                  onChanged: (val) => _name = val,
                  validator: (String value) {
                    print(_name);
                    if (value.isEmpty) {
                      return 'Por favor introduce un nombre correcto';
                    }
                    else return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.cyan),
                    hintText: 'Ruiz Pérez',
                    labelText: 'Apellidos *',
                    //font:
                  ),
                  onChanged: (val) => _surname = val,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Por favor, introduce un apellido correcto';
                    }
                    else return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(
                    icon: Icon(Icons.person, color: Colors.cyan),
                    hintText: 'Juan1234',
                    labelText: 'Nombre de usuario *',
                    //font:
                  ),
                  onChanged: (val) => _username = val,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return 'Por favor, introduce un nombre de usuario correcto';
                    }
                    else return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Contraseña *',
                    icon: Padding(
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
                  validator: (val) => val.length < 6 ? 'Contraseña demasiado corta(6 caracteres como mínimo).' : null,
                  onChanged: (val) => _password = val,
                  obscureText: _obscureText,
                  
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Repetir contraseña *',
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
                      print(_password);
                      ret = 'Las contraseñas no coinciden';
                    }
                    return ret;
                  },
                  obscureText: _obscureText,
                ),
                Row(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 38.0, top: 16, bottom: 16),
                      child: CountryPicker(
                        showDialingCode: false,
                        onChanged: (Country country) {
                          setState(() {
                            _selected = country;
                          });
                        },
                        selectedCountry: _selected,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    if (_value1) TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Descripción del artista',
                        hoverColor: Colors.blueGrey
                        //font:
                      ),
                      maxLines: 7,
                      onChanged: (val) => _description = val
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                  child: Column(
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () => _openFileExplorer2(),
                        child: Text("Escoger imagen"),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      // devolverá true si el formulario es válido, o falso si
                      // el formulario no es válido.
                      if (_formKey.currentState.validate()) {
                        // Si el formulario es válido, queremos mostrar un Snackbar
                        signUp();
                      }
                      else if (!_formKey.currentState.validate()) {
                      }
                    },
                    child: Text('Registrarse'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}