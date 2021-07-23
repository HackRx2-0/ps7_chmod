import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class SavePage extends StatefulWidget {
  Uint8List realImg;
  SavePage({Key? key,required this.realImg}) : super(key: key);

  @override
  _SavePageState createState() => _SavePageState();
}

class _SavePageState extends State<SavePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Center(
        child: Hero(
          tag: 1,
          child: Container(
          height: 200,
          width: 200,
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(200)),
          // borderRadius: BorderRadius.vertical(top: Radius.circular(40)),

          ),
            child: Center(child: Text("Saved",style: TextStyle(fontSize: 35),)),
          ),
        )
      ),
    );
  }
}
