import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User List',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'User List'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<List<User>> _getUusers() async{
    var data = await http.get("https://jsonplaceholder.typicode.com/users");
    var jsonData = json.decode(data.body);
    List<User> users =[];
    for(var u in jsonData){
      User user = User(u["id"], u["name"], u["username"], u["email"], u["phone"]);
      users.add(user);
    }

    print(users.length);

    return users;


  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUusers(),
          builder: (BuildContext context, AsyncSnapshot snapshot){

            if(snapshot.data == null){
              return CircularProgressIndicator();
            }else{
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage: AssetImage('lib/avatar.png'),
                        radius: 30,
                      ),
                      title: Text(snapshot.data[index].name),
                      subtitle: Text(snapshot.data[index].email),
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> DetailPage(snapshot.data[index])));
                      },
                    );
                  }
              );
            }



          },
        ),
      ),

    );
  }
}

class DetailPage extends StatelessWidget {
  final User user;
  DetailPage(this.user);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Center(
        child: 
        Column(
        children: <Widget> [
          CircleAvatar(
            backgroundImage: AssetImage('lib/avatar.png'),
            radius: 30,
          ),
          Text(user.name),
          Text(user.username),
          Text(user.email),
          Text(user.phone),
        ],
      ),
      ),
    );
  }
}


class User{
  final int id;
  final String name;
  final String username;
  final String email;
  final String phone;


  User(this.id,this.name,this.username,this.email,this.phone);
}