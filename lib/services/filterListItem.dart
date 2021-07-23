import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FilterListItem extends StatelessWidget {
  // Function onPress;
  String text;
  String imageName;

  FilterListItem({
    Key? key,
    required this.size,
    // required this.onPress,
    required this.imageName,
    required this.text
  }) : super(key: key);

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size.width/5,
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: size.width/5,
            height: size.width/8,
            child: ClipRRect(
              borderRadius:  BorderRadius.all(Radius.circular(40),
              ),
              child: Image.asset(
                imageName,
                fit: BoxFit.fill,
              ),
            ),
          ),
          FittedBox(
            fit: BoxFit.cover,
            child: Text(
              text,
              style: TextStyle(
                color: Colors.black,
              ),
            ),
          )
        ],
      ),
    );
  }
}