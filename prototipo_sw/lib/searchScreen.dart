import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/Profile.dart';


class SearchList extends StatefulWidget {

  final String _email;
  SearchList(this._email);
  @override
  _SearchListState createState() => new _SearchListState();

}

class _SearchListState extends State<SearchList>
{
  Widget appBarTitle = new Text("Explora...", style: new TextStyle(color: Colors.white),);
  Widget _leading;
  Icon actionIcon = new Icon(Icons.search, color: Colors.white,);
  final key = new GlobalKey<ScaffoldState>();
  final TextEditingController _searchQuery = new TextEditingController();
  List<String> _list;
  bool _IsSearching;
  String _searchText = "";

  var jsonData;

  _SearchListState() {
    _searchQuery.addListener(() {
      if (_searchQuery.text.isEmpty) {
        setState(() {
          _IsSearching = false;
          _searchText = "";
        });
      }
      else {
        setState(() {
          _IsSearching = true;
          _searchText = _searchQuery.text;
        });
      }
    });
  }

  Future<String> getAllUsers() async{
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/allClientes');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
    print('All users done');
      setState(() {
        jsonData = json.decode(response.body);
      });
    } 
    return ('Success');
  }

  @override
  void initState() {
    super.initState();
    _IsSearching = false;
    getAllUsers();

  }

  @override
  Widget build(BuildContext context) {
    _list = List();
    if (jsonData != null){
      for (int i = 0; i < jsonData.length; i++) {
        print(jsonData[i]['correo']);
        _list.add(jsonData[i]['username']);
      }
    }
    return new Scaffold(
      key: key,
      appBar: buildBar(context),
      body: new ListView(
        padding: new EdgeInsets.symmetric(vertical: 8.0),
        children: _IsSearching ? _buildSearchList() :  _buildList(),
      ),
    );
  }

  List<ChildItem> _buildList() {
    //AQUI SE AÑADIRAN LAS CANCIONES MÁS STREMEADAS Y RECOMENDACIONES
    return List<ChildItem>();
  }

  List<ChildItem> _buildSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new ChildItem(contact, widget._email))
          .toList();
    }
    else {
      List<String> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i);
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(name);
        }
      }
      return _searchList.map((contact) => new ChildItem(contact, widget._email))
          .toList();
    }
  }

  Widget buildBar(BuildContext context) {
    return new AppBar(
      leading: _leading,
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
      title: appBarTitle,
      actions: <Widget>[
        new IconButton(icon: actionIcon, onPressed: () {
          setState(() {
            if (this.actionIcon.icon == Icons.search) {
              this.actionIcon = new Icon(Icons.close, color: Colors.white,);
              this.appBarTitle = new TextField(
                controller: _searchQuery,
                style: new TextStyle(
                  color: Colors.white,

                ),
                decoration: new InputDecoration(
                    prefixIcon: new Icon(Icons.search, color: Colors.white),
                    hintText: "Search...",
                    hintStyle: new TextStyle(color: Colors.white)
                ),
              );
              this._leading = new IconButton(icon: Icon(Icons.menu),  
              // onPressed: OPEN MENU TO SELECT A TABLE TO SEARCH IN (USERS, ALBUMS, CANCIONES),
             );
              _handleSearchStart();
            }
            else {
              _handleSearchEnd();
            }
          });
        },),
      ]
    );
  }

  void _handleSearchStart() {
    setState(() {
      _IsSearching = true;
    });
  }

  void _handleSearchEnd() {
    setState(() {
      this.actionIcon = new Icon(Icons.search, color: Colors.white,);
      this.appBarTitle =
      new Text("Explora...", style: new TextStyle(color: Colors.white),);
      _IsSearching = false;
      this._leading = new Container();
      _searchQuery.clear();
    });
  }

}

class ChildItem extends StatefulWidget {
  final String user;
  final String me;
  ChildItem( this.user, this.me,);

  @override
  _ChildItemState createState() => _ChildItemState();
}

class _ChildItemState extends State<ChildItem> {
  Icon follow = new Icon(Icons.person_add);

  following(String me, String friend) async {
    var userFriend;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/usuario/username/$friend');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      userFriend = json.decode(response.body);
      String correo = userFriend['correo'];
      var uri2 = Uri.https('upbeatproyect.herokuapp.com','/usuario/following/$me/$correo');
      final response2 = await http.get(
        uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
      );
      print (response2.statusCode);
      if (response2.statusCode == 200) {
        var ret = json.decode(response2.body);
        if(ret == 0){
          setState(() {
            follow = Icon(Icons.check);
          });
        }
      }
    }
  }

  unfollowUser(String me, String friend) async {
  var userFriend;
  var uri = Uri.https('upbeatproyect.herokuapp.com','/usuario/username/$friend');
  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON
    userFriend = json.decode(response.body);
    String correo = userFriend['correo'];
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/usuario/unfollow/$me/$correo');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        follow = Icon(Icons.person_add);
        print("Usuario unfollowed con éxito");
      });
    }
  }
}

followUser(String me, String friend) async {
  var userFriend;
  var uri = Uri.https('upbeatproyect.herokuapp.com','/usuario/username/$friend');
  final response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );
  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON
    userFriend = json.decode(response.body);
    String correo = userFriend['correo'];
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/usuario/follow/$me/$correo');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        follow = Icon(Icons.check);
        print("Usuario seguido con éxito");
      });
    }
  }
}


  @override
  void initState() { 
    super.initState();
    following(widget.me, widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.user), 
      trailing: IconButton(
        icon: follow,
        onPressed: () {
          if(follow.icon == Icons.person_add)followUser(widget.me , widget.user);
          else unfollowUser(widget.me , widget.user);
        } 
      ),
      //onTap: PANTALLA DE PERFIL DEL USUARIO --> COPYPASTEAR QUITANDO OPCIONES DE UPDATE.
    );
  }
}

