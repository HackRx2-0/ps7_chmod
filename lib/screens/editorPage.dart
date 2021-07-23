import 'dart:io';
import 'dart:typed_data';
import 'package:animations/animations.dart';
import 'package:chmod/main.dart';
import 'package:chmod/screens/EnhancePage.dart';
import 'package:chmod/screens/adjustPage.dart';
import 'package:chmod/screens/cropPage.dart';
import 'package:chmod/screens/filtersPage.dart';
import 'package:chmod/screens/morphPage.dart';
import 'package:chmod/screens/rotatePage.dart';
import 'package:chmod/screens/savePage.dart';
import 'package:chmod/services/optionListItem.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class EditorPage extends StatefulWidget {
  Uint8List realImage;
  EditorPage({Key? key,required this.realImage}) : super(key: key);

  @override
  _EditorPageState createState() => _EditorPageState();
}

class _EditorPageState extends State<EditorPage> {
  final GlobalKey key = GlobalKey();

  Widget _buildFront() {
    print("Building Front ${imagesQueue.length}");
    return  Container(
      key: ValueKey(0),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.memory(
        imagesQueue.last,
        key: ValueKey(0),
      ),
    );
  }

  Widget _buildRear() {
    return  Container(
      // color: Colors.amber,
      key: ValueKey(1),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Image.memory(
        widget.realImage,
        key: ValueKey(1),
      ),
    );
  }

  @override
  void initState() {
    imagesQueue.add(widget.realImage);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          TextButton(
            child: FaIcon(
              FontAwesomeIcons.undoAlt,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                if(imagesQueue.length == 1){
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text("This is the original image.\nUndo not available."),
                  ));
                }
                else{
                  imagesQueue.removeLast();
                }
              });
            },
          ),
          TextButton(
            child: FaIcon(
              FontAwesomeIcons.solidSave,
              size: 20,
              color: Colors.white,
            ),
            onPressed: () async {
              File('my_image.jpg').writeAsBytes(imagesQueue.last);

              await Navigator.push(
              context,
              PageRouteBuilder(
                transitionDuration:
                Duration(milliseconds: 250),
                reverseTransitionDuration:
                Duration(milliseconds: 150),
                transitionsBuilder:
                (BuildContext context,
                Animation<double>
                animation,
                Animation<double>
                secAnimation,
                Widget child)
                {
                  return FadeTransition(
                    opacity: animation,
                    child: child,
                  );
                },
                pageBuilder: (BuildContext
                  context,
                  Animation<double> animation,
                  Animation<double> secAnimation) {
                  // return cropPage(realImage: image!,);
                  // return CropPage(realImage: File(image!.path),);
                  return SavePage(realImg:imagesQueue.last);
                }
              )
              );
            },
          ),
        ],
        leading:IconButton(
          icon: new Icon(Icons.clear_rounded),
          iconSize: 30,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Theme.of(context).accentColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            flex: 20,
            child: Hero(
  tag: 1,
              child: Container(
                height: size.height*0.7,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(size.width/10)),
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                ),
                child: ValueListenableBuilder(
                    valueListenable: refreshVar,
                    builder: (context, dynamic val, child) {
                      return FlipCard(
                        front: _buildFront(),
                        back: _buildRear(),
                      );
                    },
                ),
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: ListView(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => CropPage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.cropAlt,
                      text: "Crop",
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => RotatePage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.syncAlt,
                      text: "Rotate",
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => AdjustPage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.slidersH,
                      text: "Adjust",
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => EnhancePage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.solidStar,
                      text: "Enhance",
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => EnhancePage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.filter_b_and_w,
                          size: 30,
                          color: Colors.white,
                        ),
                        FittedBox(
                          fit: BoxFit.cover,
                          child: Text(
                            "BW",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(seconds: 1),
                    openBuilder: (context, _) => FiltersPage(realImage: imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.magic,
                      text: "Filters",
                    ),
                  ),
                ),
                Container(
                  width: size.width/5,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: OpenContainer(
                    transitionType: ContainerTransitionType.fade,
                    closedColor: Colors.transparent,
                    closedElevation: 0,
                    openElevation: 0,
                    openColor: Colors.transparent,
                    transitionDuration: Duration(milliseconds: 700),
                    openBuilder: (context, _) => MorphPage(realImage:imagesQueue.last,),
                    closedBuilder: (context, VoidCallback openContainer) => OptionsListItem(size: size,
                      // onPress: ((){}),
                      iconName: FontAwesomeIcons.palette,
                      text: "Morph",
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}