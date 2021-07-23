// import 'dart:async';
// import 'dart:convert';
// import 'dart:io';
// import 'dart:math';
// import 'dart:typed_data';
//
// import 'package:chmod/main.dart';
// import 'package:chmod/services/cropClass.dart';
// import 'package:dio/dio.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:http/http.dart' as http;
//
// class RotatePage extends StatefulWidget {
//   Uint8List realImage;
//
//   RotatePage({Key? key, required this.realImage}) : super(key: key);
//
//   @override
//   _RotatePageState createState() => _RotatePageState();
// }
//
// class _RotatePageState extends State<RotatePage> {
//   final GlobalKey key = GlobalKey();
//   Offset? tl , tr, bl, br;
//   late Offset tlo ,tro,blo,bro;
//
//   late double imgWidth,imgHeight,width,height;
//
//   bool firstTime =true;
//   late ImageInfo imageInfo;
//   double sliderVal = 0;
//
//   Future<ImageInfo> getImageInfo(BuildContext context) async {
//     if(firstTime) {
//       firstTime = false;
//       FileImage fileImage = FileImage(mainImage);
//       // print(File(widget.realImage.path));
//       ImageStream stream = fileImage.resolve(
//           createLocalImageConfiguration(context));
//       // assetImage.resolve(createLocalImageConfiguration(context));
//       Completer<ImageInfo> completer = Completer();
//       stream.addListener(
//           ImageStreamListener(
//                   (ImageInfo imageInfo, _) {
//                 return completer.complete(imageInfo);
//               }
//           )
//       );
//       imageInfo =  await completer.future;
//     }
//     return imageInfo;
//   }
//
//   @override
//   void initState(){
//     // imageInfo = await getImageInfo(context);
//     Future.delayed(Duration(milliseconds: 1)).then(
//             (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//           statusBarColor: Colors.transparent,
//           // isHomeOpen
//           //     ? backgroundColor
//           //     : drawerColor,
//           statusBarIconBrightness: Brightness.dark,
//           systemNavigationBarColor: Color(0xFFF1F2F6),
//           systemNavigationBarIconBrightness: Brightness.dark,
//           systemNavigationBarDividerColor: Color(0xFFF1F2F6),
//         )));
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         actions: [
//           IconButton(
//             icon: new Icon(Icons.done_rounded),
//             onPressed: (() async {
//               // await getCroppedImage();
//             }),
//           ),
//         ],
//         title: Text(
//           "Rotate Image",
//           style: new TextStyle(color: Colors.white),
//         ),
//         centerTitle: true,
//         leading:IconButton(
//           icon: new Icon(Icons.clear_rounded),
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Container(
//               // width: size.width * 0.9,
//               // height: size.height * 0.6,
//               // height: size.height * 0.80*widget.realImage.,
//               padding: EdgeInsets.all(20),
//
//               child: FutureBuilder(
//                   future: getImageInfo(context),
//                   builder: (BuildContext context,AsyncSnapshot<ImageInfo> snapshot) {
//                     if(!snapshot.hasData)
//                       return Text("Loading!!!");
//                     else{
//                       imgWidth = snapshot.data!.image.width.toDouble();
//                       imgHeight = snapshot.data!.image.height.toDouble();
//                       width = size.width - 40;
//                       height = imgHeight * width / imgWidth;
//                       tlo = Offset(0,0);
//                       tro = Offset(width, 0);
//                       blo = Offset(0, height);
//                       bro = Offset(width, height);
//                       if (tl == null)
//                         tl = Offset(0, 0);
//                       if (tr == null)
//                         tr = Offset(width, 0);
//                       if (bl == null)
//                         bl = Offset(0, height);
//                       if (br == null)
//                         br = Offset(width, height);
//                       return Stack(
//                         children: [
//                           Container(
//                             decoration: BoxDecoration(
//                               // borderRadius: BorderRadius.all(Radius.circular(20.0)),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.4),
//                                     blurRadius: 5.0,
//                                     spreadRadius: 3.0,
//                                   )
//                                 ]
//                             ),
//                             child: Image.memory(widget.realImage,key: key,),
//                           ),
//                           SafeArea(
//                             child: CustomPaint(
//                               painter: CropPainter(tl!, tr!, bl!, br!),
//                             ),
//                           ),
//                         ],
//                       );
//                     }
//                   }
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.fromLTRB(20,0,20,10),
//               child: Slider(
//                 value: sliderVal,
//                 min: -180,
//                 max: 180,
//                 label: "${sliderVal.toInt()}\u00B0",
//                 divisions: 360,
//                 onChanged: (double value) {
//                   setState(() {
//                     sliderVal = value;
//                   });
//                   setState(() {
//                     if(value>0){
//                       double ar = width/height;
//                       br = Offset.lerp(bro, tro, value/180);
//                       tl = Offset.lerp(tlo, blo, value/180);
//                       bl = Offset.lerp(blo, bro, value/180);
//                       tr = Offset.lerp(tro, tlo, value/180);
//                     }
//                     else{
//                       value = -value;
//                       tl = Offset.lerp(tlo, tro, value/180);
//                       tr = Offset.lerp(tro, bro, value/180);
//                       bl = Offset.lerp(blo, tlo, value/180);
//                       br = Offset.lerp(bro, blo, value/180);
//                     }
//                   });
//                 },
//
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//     // Image.file(File(widget.realImage.path));
//   }
// }
import 'dart:async';
import 'dart:math';
import 'dart:typed_data';
import 'package:chmod/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'package:opencv/opencv.dart';
import 'dart:ui' as ui;

class RotatePage extends StatefulWidget {
  Uint8List realImage;

  RotatePage({Key? key, required this.realImage}) : super(key: key);

  @override
  _RotatePageState createState() => _RotatePageState();
}

class _RotatePageState extends State<RotatePage> {
  final GlobalKey key = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();
  ValueNotifier<double> contrast=ValueNotifier<double>(1), brightness=ValueNotifier<double>(1);
  late double imgWidth,imgHeight,width,height;

  Future<ImageInfo> getImageInfo(BuildContext context) async {
    FileImage fileImage = FileImage(mainImage);
    // FileImage fileImage = FileImage(File.fromRawPath(widget.realImage));
    // print(File(widget.realImage.path));
    ImageStream stream = fileImage.resolve(createLocalImageConfiguration(context));
    // assetImage.resolve(createLocalImageConfiguration(context));
    Completer<ImageInfo> completer = Completer();
    stream.addListener(
        ImageStreamListener(
                (ImageInfo imageInfo, _) {
              return completer.complete(imageInfo);
            }
        )
    );
    return completer.future;
  }

  void saveImg() async{
    RenderRepaintBoundary repaintBoundary = _globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
    ui.Image boxImage = await repaintBoundary.toImage(pixelRatio: 1);
    ByteData? byteData = await boxImage.toByteData(format: ui.ImageByteFormat.png);
    Uint8List res = byteData!.buffer.asUint8List();
    imagesQueue.add(res);
    refreshVar.value = refreshVar.value +1;
    Navigator.of(context).pop();
  }

  @override
  void initState(){
    // imageInfo = await getImageInfo(context);
    Future.delayed(Duration(milliseconds: 1)).then(
            (value) => SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          // isHomeOpen
          //     ? backgroundColor
          //     : drawerColor,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Color(0xFFF1F2F6),
          systemNavigationBarIconBrightness: Brightness.dark,
          systemNavigationBarDividerColor: Color(0xFFF1F2F6),
        )));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: new Icon(Icons.done_rounded),
            onPressed: () => saveImg(),
          ),
        ],
        title: Text(
          "Rotate Image",
          style: new TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading:IconButton(
          icon: new Icon(Icons.clear_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
          // width: size.width * 0.9,
          // height: size.height * 0.6,
          // height: size.height * 0.80*widget.realImage.,
          padding: EdgeInsets.all(20),
          child: FutureBuilder(
              future: getImageInfo(context),
              builder: (BuildContext context,AsyncSnapshot<ImageInfo> snapshot) {
                if(!snapshot.hasData)
                  return Text("Loading!!!");
                else{
                  if((contrast.value/90)%2 == 1){
                    imgHeight = snapshot.data!.image.width.toDouble();
                    imgWidth = snapshot.data!.image.height.toDouble();
                  }
                  else{
                    imgWidth = snapshot.data!.image.width.toDouble();
                    imgHeight = snapshot.data!.image.height.toDouble();
                  }
                  width = size.width-40;
                  height = imgHeight * width/imgWidth;

                  // print("this is $width $height ");
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          // borderRadius: BorderRadius.all(Radius.circular(20.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4),
                                blurRadius: 5.0,
                                spreadRadius: 3.0,
                              )
                            ]
                        ),
                        child: MultiValueListenableBuider(
                            valueListenables: [contrast,brightness],
                            builder: (context, dynamic val, child) {
                              return RepaintBoundary(
                                key: _globalKey,
                                child:Transform.rotate(
                                  angle: 3.1418 / 180 * contrast.value,
                                  alignment: Alignment.center,
                                  child: Image.memory(
                                    widget.realImage,
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                      MultiValueListenableBuider(
                          valueListenables: [contrast,brightness],
                          builder: (context, dynamic val, child) {
                            return Row(
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: IconButton(
                                          onPressed: () {
                                            // double t= width;
                                            // width = height;
                                            // height =t;
                                            contrast.value +=90;
                                          },
                                          icon: FaIcon(
                                            FontAwesomeIcons.undoAlt,
                                          ),
                                      )
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: FittedBox(
                                    fit: BoxFit.contain,
                                    child: Text('Rotate 90\u00B0'),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: IconButton(
                                        onPressed: () {
                                          // double t= width;
                                          // width = height;
                                          // height =t;
                                          contrast.value -= 90;
                                        },
                                        icon: FaIcon(
                                          FontAwesomeIcons.redoAlt,
                                        ),
                                      )
                                  ),
                                ),
                              ],
                            );
                          }
                      ),


                    ],
                  );
                }
              }
          ),
        ),
      ),
    );
    // Image.file(File(widget.realImage.path));
  }
}
// Slider
