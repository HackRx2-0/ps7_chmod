import 'package:flutter/material.dart';

class TestPage extends StatefulWidget {
  var res;
  TestPage({Key? key,required this.res}) : super(key: key);

  @override
  _TestPageState createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  @override
  Widget build(BuildContext context) {
    return Container(child: SizedBox(width:double.infinity,child: Image.memory(widget.res)));
  }
}
