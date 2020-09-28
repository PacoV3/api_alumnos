import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

Future<Students> fetchStudents() async {
  final response = await http.get('http://iplocal:5000/api/alumnos');

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Students.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load students');
  }
}

class Students {
  final List<dynamic> students;

  Students({this.students});

  factory Students.fromJson(Map<String, dynamic> json) {
    return Students(
      students: json['students'],
    );
  }
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Alumnos'),
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
  Future<Students> futureStudents;

  @override
  void initState() {
    super.initState();
    futureStudents = fetchStudents();
  }

  Widget showStudents(Students listOfStudents) {
    return ListView.builder(
        itemBuilder: (_, index) => Card(
              child: Container(
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                            listOfStudents.students[index]["key"].toString()),
                        width: 200,
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Text(
                          listOfStudents.students[index]["name"].toString()),
                      flex: 3,
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                ),
                padding: EdgeInsets.all(16),
              ),
            ),
        padding: const EdgeInsets.all(20.0),
        itemCount: listOfStudents.students.length);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<Students>(
          future: futureStudents,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return showStudents(snapshot.data);
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
