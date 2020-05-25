import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/albumScreen.dart';
import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/model/usuario.dart';
import 'package:prototipo_sw/playlistScreen.dart';
import 'package:prototipo_sw/user_playlists.dart';
import 'AudioControl.dart';



class SearchList extends StatefulWidget {

  final String _email;
  final AudioControl audio;
  SearchList(this._email, this.audio);
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
          _future = getAllPlaylists();
          selected = "PLAYLIST";
          break;
        case 3:
          _future = getAllAlbums();
          selected = "ALBUMS";
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
              new Radio(
                value: 3,
                groupValue: _radioValue1,
                onChanged: _handleRadioValueChange1,
              ),
              new Text(
                'Álbumes',
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


  Future<List<Album>> getAllAlbums() async{
    var _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/album/allAlbums');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get all songs: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('All albumss done');
      setState(() {
        jsonData = json.decode(response.body);

        _list = (jsonData as List).map((p) => Album.fromJson(p)).toList();
        print(_list);
      });
    }
    return _list;
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
    print('Response status get all songs: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
    print('All songs done');
      setState(() {
        jsonData = json.decode(response.body);

        _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();
        print(_list);
      });

    } 
    return _list;
  }

  Future<List<Usuario>> getAllUsers() async{
    var _list;
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

  Future<List<Playlist>> getAllPlaylists() async{
    List<Playlist> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/playlist/allPlaylists');
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
      print('All playlists done');
      if (this.mounted) {
        setState(() {
          jsonData = json.decode(response.body);
          _list = (jsonData as List).map((p) => Playlist.fromJson(p)).toList();
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
    else if (selected == "PLAYLIST"){
      ret = _buildPlaylistList();
    }

    else if (selected == "ALBUMS"){
      ret = _buildAlbumList();
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
    else if (selected == "PLAYLIST"){
      ret = _buildPlaylistSearchList();
    }

    else if (selected == "ALBUMS"){
      ret = _buildAlbumSearchList();
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
      return _list.map((contact) => new SongItem(contact, widget._email, widget.audio))
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
      return _searchList.map((contact) => new SongItem(contact, widget._email, widget.audio))
          .toList();
    }
  }


/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/* BÚSQUEDA DE PLAYLISTS */

  List<PlaylistItem> _buildPlaylistList() {
    //AQUI SE AÑADIRAN LAS PLAYLISTS MÁS STREMEADAS Y RECOMENDACIONES
    return List<PlaylistItem>();
  }

  List<PlaylistItem> _buildPlaylistSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new PlaylistItem(contact, widget._email, widget.audio))
          .toList();
    }
    else {
      List<Playlist> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i).nombre;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList.map((contact) => new PlaylistItem(contact, widget._email, widget.audio))
          .toList();
    }
  }


/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------*/
/* BÚSQUEDA DE CANCIONES */

  List<AlbumItem> _buildAlbumList() {
    //AQUI SE AÑADIRAN LAS CANCIONES MÁS STREMEADAS Y RECOMENDACIONES
    return List<AlbumItem>();
  }

  List<AlbumItem> _buildAlbumSearchList() {
    if (_searchText.isEmpty) {
      return _list.map((contact) => new AlbumItem(contact, widget._email, widget.audio))
          .toList();
    }
    else {
      List<Album> _searchList = List();
      for (int i = 0; i < _list.length; i++) {
        String  name = _list.elementAt(i).nombre;
        if (name.toLowerCase().contains(_searchText.toLowerCase())) {
          _searchList.add(_list.elementAt(i));
        }
      }
      return _searchList.map((contact) => new AlbumItem(contact, widget._email, widget.audio))
          .toList();
    }
  }


}

/*---------------------------------------------------------------------------------------*/
/*USUARIO ITEMS */
class UsuarioItem extends StatefulWidget {
   var user;
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
                  image: NetworkImage((widget.user.pathImg == null) ? 'https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png' : widget.user.pathImg),
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
  var song;
  final AudioControl audio;
  final String me;
  SongItem( this.song, this.me, this.audio);

  @override
  SongItemState createState() => SongItemState();
}

class SongItemState extends State<SongItem> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;




  isFav(String me, int songId) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavSong/$me/$songId');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }

  reproducirCancion( var idSong) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirCancion/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    widget.audio.reproducir(widget.me);

  }


  Future<String> getSongAutor() async{
    List<Song> _list;
    id = widget.song.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/getbyId/$id');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get songs autor: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('get song done');
      setState(() {
        jsonData = json.decode(response.body);

        _creador = jsonData['creador'];
        print(_creador);
        print('_____23432____');
        _autor = _creador['username'];
        print(_autor);
        print('_____23432____');
        hayAutor = true;

      });

    }
    return _autor;
  }

  @override
  void initState() { 
    super.initState();
    isFav(widget.me, widget.song.id);
    
  }

  @override
  Widget build(BuildContext context) {

    _future2 = getSongAutor();
    return FutureBuilder<dynamic>(
      future: _future2,
      builder: (context, snapshot) {

        return new ListTile(
          onTap: (){
            print('___________________________________________________');
          reproducirCancion(widget.song.id);
           },
          leading: Container(
              height: 50,
              width: 50,
              decoration: _myBoxDecoration(),
              child: (widget.song.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                  child: Image.network(widget.song.pathImg))
              : Image.asset('images/appleMusic.png')
          ),
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
                      favSong(widget.me, widget.song.id);
                    }
                    else {
                      unFavSong(widget.me, widget.song.id);
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
          subtitle: new Text(hayAutor ? _autor : ''),
          //onTap: () => // Añadir a la cola de reproduccion en la 1ª posición.
        );
      }
    );
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {

    if (choice == Options.p1){
      int songId = widget.song.id;
      print ("Añadir a Playlist");
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserPlaylists(widget.me,songId)));
      // Push a la vista de playlists del usuario
    }
    if (choice == Options.p3){

      widget.audio.addEnd(widget.song.id);
      // Push a la vista de playlists del usuario
    }
  }

}





class PodcastItem extends StatefulWidget {
  var song;
  final AudioControl audio;
  final String me;
  PodcastItem( this.song, this.me, this.audio);

  @override
  PodcastItemState createState() => PodcastItemState();
}

class PodcastItemState extends State<PodcastItem> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;




  isFav(String me, int songId) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavPodcast/$me/$songId');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV podcast:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favPodcast/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavPodcast/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }

  reproducirPodcast( var nombre, var temp, var ep, var url, var img) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/podcast/getStreamMp3Url/$nombre/$temp/$ep",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    widget.audio.reproducirPod(url, nombre, img);

  }




  @override
  void initState() {
    super.initState();
    isFav(widget.me, widget.song.id);

  }

  @override
  Widget build(BuildContext context) {

    /*_future2 = getSongAutor();
    return FutureBuilder<dynamic>(
        future: _future2,
        builder: (context, snapshot) {*/
          var t = widget.song.temporada;
          var e = widget.song.episodio;
          return new ListTile(
            onTap: (){
              print('___________________________________________________');
              reproducirPodcast(widget.song.nombre, widget.song.temporada, widget.song.episodio, widget.song.pathMp3, widget.song.pathImg);
            },
            leading: Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: (widget.song.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                    child: Image.network(widget.song.pathImg))
                    : Image.asset('images/appleMusic.png')
            ),
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
                        favSong(widget.me, widget.song.id);
                      }
                      else {
                        unFavSong(widget.me, widget.song.id);
                      }
                    }
                ),

              ],
            ),
            enabled: true,
            subtitle: new Text('Temp: $t Ep: $e'),
            //onTap: () => // Añadir a la cola de reproduccion en la 1ª posición.
          );
        /*}
    );*/
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {

    if (choice == Options.p1){
      int songId = widget.song.id;
      print ("Añadir a Playlist");
      Navigator.push(context, MaterialPageRoute(builder: (context) => UserPlaylists(widget.me,songId)));
      // Push a la vista de playlists del usuario
    }
    if (choice == Options.p3){

      widget.audio.addEnd(widget.song.id);
      // Push a la vista de playlists del usuario
    }
  }

}

/*---------------------------------------------------------------------------------------*/
/*PLAYLIST ITEMS */
/*---------------------------------------------------------------------------------------*/
class PlaylistItem extends StatefulWidget {
  var playlist;
  final String me;
  var audio;
  PlaylistItem( this.playlist, this.me, this.audio);

  @override
  PlaylistItemState createState() => PlaylistItemState();
}

class PlaylistItemState extends State<PlaylistItem> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;

  isFav(String me, int playlistID) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavPlaylist/$me/$playlistID');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favPlaylist(String me, int playlistId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favPlaylist/$me/$playlistId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int playlistId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavPlaylist/$me/$playlistId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }


  Future<String> getPlaylistAutor() async{

    id = widget.playlist.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/playlist/get/$id');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get songs autor: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('Get playlist done');
      setState(() {
        jsonData = json.decode(response.body);

        _creador = jsonData['creador'];
        print(_creador);
        print('_____23432____');
        _autor = _creador['username'];
        print(_autor);
        print('_____23432____');
        hayAutor = true;

      });

    }
    return _autor;
  }

  @override
  void initState() {
    super.initState();
    isFav(widget.me, widget.playlist.id);

  }
  @override
  Widget build(BuildContext context) {
    _future2 = getPlaylistAutor();
    return FutureBuilder<dynamic>(
        future: _future2,
        builder: (context, snapshot) {
          return new ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: (widget.playlist.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                    child: Image.network(widget.playlist.pathImg))
                    : Image.asset('images/appleMusic.png')
            ),
            title: new Text(widget.playlist.nombre),
            trailing:
            Wrap(
              children: <Widget>[
                IconButton(
                    icon: fav,
                    color: Colors.red,
                    onPressed: () {
                      print(fav);
                      if (fav.icon == (Icons.favorite_border)){
                        favPlaylist(widget.me, widget.playlist.id);
                      }
                      else {
                        unFavSong(widget.me, widget.playlist.id);
                      }
                    }
                ),
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return Options.choicesPl.map((String choice) {
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
            subtitle: new Text(hayAutor ? _autor : ''),
            //onTap: () => // Añadir a la cola de reproduccion en la 1ª posición.
          );
        }
    );
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {

    if (choice == Options.p2){
      print ("Ver Playlist");
      Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistScreen(widget.playlist,widget.me, widget.audio)));
      // Push a la vista de la playlist
    }
  }

}


/*---------------------------------------------------------------------------------------*/
/*ALBUM ITEMS */
/*---------------------------------------------------------------------------------------*/
class AlbumItem extends StatefulWidget {
  var album;
  final String me;
  var audio;
  AlbumItem( this.album, this.me, this.audio);

  @override
  AlbumItemState createState() => AlbumItemState();
}

class AlbumItemState extends State<AlbumItem> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;

  isFav(String me, int albumID) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavAlbum/$me/$albumID');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favAlbum(String me, int albumId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favAlbum/$me/$albumId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int albumId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavAlbum/$me/$albumId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }


  Future<String> getAlbumAutor() async{

    id = widget.album.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/album/get/$id');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get songs autor: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('Get album done');
      setState(() {
        jsonData = json.decode(response.body);

        _creador = jsonData['autor'];
        print(_creador);
        print('_____23432____');
        _autor = _creador['username'];
        print(_autor);
        print('_____23432____');
        hayAutor = true;

      });

    }
    return _autor;
  }

  @override
  void initState() {
    super.initState();
    isFav(widget.me, widget.album.id);

  }
  @override
  Widget build(BuildContext context) {
    _future2 = getAlbumAutor();
    return FutureBuilder<dynamic>(
        future: _future2,
        builder: (context, snapshot) {
          return new ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: (widget.album.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                    child: Image.network(widget.album.pathImg))
                    : Image.asset('images/appleMusic.png')
            ),
            title: new Text(widget.album.nombre),
            trailing:
            Wrap(
              children: <Widget>[
                IconButton(
                    icon: fav,
                    color: Colors.red,
                    onPressed: () {
                      print(fav);
                      if (fav.icon == (Icons.favorite_border)){
                        favAlbum(widget.me, widget.album.id);
                      }
                      else {
                        unFavSong(widget.me, widget.album.id);
                      }
                    }
                ),
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return Options.choicesAl.map((String choice) {
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
            subtitle: new Text(hayAutor ? _autor : ''),
            //onTap: () => // Añadir a la cola de reproduccion en la 1ª posición.
          );
        }
    );
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {

    if (choice == Options.p4){
      print ("Ver Album");
      Navigator.push(context, MaterialPageRoute(builder: (context) => AlbumScreen(widget.album,widget.me, widget.audio)));
      // Push a la vista de la playlist
    }
  }

}


  class Options {
    static const String p1 = "Añadir a Playlist";
    static const String p2 = "Ver Playlist";
    static const String p3 = "Añadir a cola de reproducción";
    static const String p4 = "Ver Álbum";

    static const List<String> choices = <String> [p1,p3];
    static const List<String> choice = <String> [p3];
    static const List<String> choicesPl = <String> [p2];
    static const List<String> choicesAl = <String> [p4];
  }