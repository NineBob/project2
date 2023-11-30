import 'package:flutter/material.dart';
import 'package:project2/pages/home.dart';


class Warning extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My App'),
      ),
      body: Center(
        child: Text('Welcome to Ingredient!'),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[

            IconButton(

              icon: Icon(Icons.home),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => home()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.backup_table),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.book_outlined),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Warning()),
                );
              },
            ),

          ],
        ),
      ),
    );
  }
}
