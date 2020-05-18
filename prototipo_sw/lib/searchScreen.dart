import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/model/usuario.dart';
import 'package:prototipo_sw/user_playlists.dart';



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
  bool _IsSearching;
  String _searchText = "";
  List _list;
  String selected = "USER";
  int _radioValue1 = 0;
  var jsonData;

  Future _future;

  void _handleRadioValueChange1(int value) {
    setState(() {
      _radioValue1 = value;
      switch (_radioValue1) {
        case 0:
          _future = getAllUsers();
          selected = "USER";
          break;
        case 1:
          _future = getAllSongs();
          selected = "CANCION";
          break;
        case 2:
          selected = "PLAYLIST";
          break;
      } 
      Navigator.pop(context);
    });
  }

  createMenu(BuildContext context){ 
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("¿Qué estás buscando?"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Radio(
                value: 0,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Clientes',
                style: new TextStyle(fontSize: 16.0),
              ),
              new Radio(
                value: 1,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Canciones',
                style: new TextStyle(
                  fontSize: 16.0,
                ),
              ),
              new Radio(
                value: 2,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Playlists',
                style: new TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      );
    });
  }

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

  Future<List<Song>> getAllSongs() async{
    List<Song> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/allSongs');
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
    print('All songs done');
      setState(() {
        jsonData = json.decode(response.body);
        _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();
      });
    } 
    return _list;
  }

  Future<List<Usuario>> getAllUsers() async{
    List<Usuario> _list;
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
      if (this.mounted) {
        setState(() {
          jsonData = json.decode(response.body);
          _list = (jsonData as List).map((p) => Usuario.fromJson(p)).toList();
        });
      }    
    }
    return _list;
  } 


  @override
  void initState() {
    super.initState();
    _IsSearching = false;
  }

  @override
  Widget build(BuildContext context) {
    if (selected == "USER"){
       _future= getAllUsers();
    }
    return FutureBuilder<dynamic>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        else _list = snapshot.data;
        return new Scaffold(
          key: key,
          appBar: buildBar(context),
          body: new ListView(
            padding: new EdgeInsets.symmetric(vertical: 8.0),
            children: _IsSearching ? _buildSearchList() :  _buildList(),
          ),
        );
      }
    );
  }

  List _buildList() {
    List ret;
    if (selected == "USER"){
      ret =  _buildUserList();
    }
    else if (selected == "CANCION"){
      ret = _buildSongList();

    }
    return ret;
  }

  List _buildSearchList() {
    List ret;
    if (selected == "USER"){
      ret =  _buildUserSearchList();
    }
    else if (selected == "CANCION"){ //CANCIONES, PLAYLISTS, ALBUMS...
      ret = _buildSongSearchList();
    }
    return ret;
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
              onPressed: () {
                  createMenu(context);
               }
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
/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/* BÚSQUEDA DE USUARIOS */

  List<UsuarioItem> _buildUserList() {
    //AQUI SE AÑADIRAN LAS CANCIONES MÁS STREMEADAS Y RECOMENDACIONES
    return List<UsuarioItem>();
  }

  List<UsuarioItem> _buildUserSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new UsuarioItem(contact, widget._email))
          .toList();
    }
    else {
      List<Usuario> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i).username;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList.map((contact) => new UsuarioItem(contact, widget._email))
          .toList();
    }
  }


/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/* BÚSQUEDA DE CANCIONES */

  List<SongItem> _buildSongList() {
    //AQUI SE AÑADIRAN LAS CANCIONES MÁS STREMEADAS Y RECOMENDACIONES
    return List<SongItem>();
  }

  List<SongItem> _buildSongSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new SongItem(contact, widget._email))
          .toList();
    }
    else {
      List<Song> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i).nombre;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList.map((contact) => new SongItem(contact, widget._email))
          .toList();
    }
  }

}

/*---------------------------------------------------------------------------------------*/
/*USUARIO ITEMS */
class UsuarioItem extends StatefulWidget {
  final Usuario user;
  final String me;
  UsuarioItem( this.user, this.me,);

  @override
  UsuarioItemState createState() => UsuarioItemState();
}

class UsuarioItemState extends State<UsuarioItem> {
  Icon follow = new Icon(Icons.person_add);

  following(String me, String friend) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/following/$me/$friend');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print (response2.statusCode);
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if (friend == me) {
        setState(() {
          follow = Icon(null);
        });
      }
      else if(ret == 0){
        setState(() {
          follow = Icon(Icons.check);
        });
      }
    }
  }

  unfollowUser(String me, String friend) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/unfollow/$me/$friend');
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

  followUser(String me, String friend) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/follow/$me/$friend');
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


  @override
  void initState() { 
    super.initState();
    following(widget.me, widget.user.email);
  }

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading:
        Column(
          children: <Widget>[
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: Colors.red,
                image: DecorationImage(
                  image: NetworkImage('https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png'),
                  fit: BoxFit.fill
                ),
                borderRadius: BorderRadius.all(
                  Radius.circular(75.0)
                ),
                boxShadow: [
                  BoxShadow(blurRadius: 13.0, color: Colors.black)
                ]
              ),
            ),
          ],
        ),
      title: new Text(widget.user.username), 
      trailing: IconButton(
        icon: follow,
        onPressed: () {
          if(follow.icon == Icons.person_add) followUser(widget.me , widget.user.email);
          else if (follow.icon == Icons.check) unfollowUser(widget.me , widget.user.email);
        } 
      ),
      onTap: () => Navigator.of(context).pushNamed('profileOnlyR', arguments: widget.user.email)
    );
  }
}


class SongItem extends StatefulWidget {
  final Song song;
  final String me;
  SongItem( this.song, this.me);

  @override
  SongItemState createState() => SongItemState();
}

class SongItemState extends State<SongItem> {

  Icon fav = Icon(Icons.favorite_border) ;

  @override
  void initState() { 
    super.initState();
    
  }
  @override
  Widget build(BuildContext context) {
    return new ListTile(
      title: new Text(widget.song.nombre), 
      trailing: 
        Wrap(
          children: <Widget>[
            IconButton(
              icon: fav,
              color: Colors.red,
              onPressed: () {
                print(fav);
                if (fav.icon == (Icons.favorite_border)){
                  setState(() {
                    fav = Icon(Icons.favorite);
                  });
                }
                else {
                  setState(() {
                    fav = Icon(Icons.favorite_border);
                  });
                }
              }
            ),
            PopupMenuButton<String>(
              onSelected: choiceAction,
              itemBuilder: (BuildContext context){
                return Options.choices.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                  
                }).toList();
              },
            ),
          ],
        ),
      enabled: true,
      subtitle: new Text(widget.song.autor),
      //onTap: () => // Añadir a la cola de reproduccion en la 1ª posición.
    );
  }

  void choiceAction(String choice) {
    if (choice == Options.p1){
      int songId = widget.song.id;
      print ("Añadir a Playlist");
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserPlaylists(widget.me,songId)));
      // Push a la vista de playlists del usuario
    }
  }

}

  class Options {
    static const String p1 = "Añadir a Playlist";
    static const String p2 = "Ver álbum";
    static const String p3 = "Añadir a cola de reproducción";

    static const List<String> choices = <String> [p1,p2,p3];

  }