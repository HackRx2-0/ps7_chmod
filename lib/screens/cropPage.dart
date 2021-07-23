import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:chmod/main.dart';
import 'package:chmod/services/cropClass.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class CropPage extends StatefulWidget {
  File realImage;

  CropPage({Key? key, required this.realImage}) : super(key: key);

  @override
  _CropPageState createState() => _CropPageState();
}

class _CropPageState extends State<CropPage> {
  final GlobalKey key = GlobalKey();
  Offset? tl , tr, bl, br;
  bool firstTime =true;
  late ImageInfo imageInfo;

  Future<ImageInfo> getImageInfo(BuildContext context) async {
    if(firstTime) {
      firstTime = false;
      getEdges();
      FileImage fileImage = FileImage(imagesQueue.last);
      // print(File(widget.realImage.path));
      ImageStream stream = fileImage.resolve(
          createLocalImageConfiguration(context));
      // assetImage.resolve(createLocalImageConfiguration(context));
      Completer<ImageInfo> completer = Completer();
      stream.addListener(
          ImageStreamListener(
                  (ImageInfo imageInfo, _) {
                return completer.complete(imageInfo);
              }
          )
      );
      imageInfo =  await completer.future;
    }
    return imageInfo;
  }




  Future<void> getEdges() async{
    String base64Image = base64Encode(imagesQueue.last.readAsBytesSync());
    var url = Uri.parse('http://10.0.2.2:5000/corner_detection');
    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'image': base64Image,
        },
      ),
      headers: {'Content-Type': "application/json"},
    );
    print('StatusCode : ${response.statusCode}');
    print('Return Data : ${response.body}');
    List<dynamic> points = jsonDecode(response.body);
    print(points);
    double width,height,imgHeight,imgWidth;
    imgHeight = points[8].toDouble();
    imgWidth = points[9].toDouble();

    Size size = MediaQuery.of(context).size;
    width = size.width-40;
    height = imgHeight * width/imgWidth;

    setState(() {
      tl = Offset(width*points[0].toDouble()/imgWidth, height*points[1].toDouble()/imgHeight);
      tr = Offset(width*points[2].toDouble()/imgWidth, height*points[3].toDouble()/imgHeight);
      bl = Offset(width*points[4].toDouble()/imgWidth, height*points[5].toDouble()/imgHeight);
      br = Offset(width*points[6].toDouble()/imgWidth, height*points[7].toDouble()/imgHeight);
    });
  }

  Future<void> getCroppedImage() async{
    List points = [[],[],[],[]];
    double width,height,imgHeight,imgWidth;
    imgWidth = imageInfo.image.width.toDouble();
    imgHeight = imageInfo.image.height.toDouble();
    Size size = MediaQuery.of(context).size;
    width = size.width-40;
    height = imgHeight * width/imgWidth;

    points[0] = [[imgWidth*tl!.dx/width, imgHeight*tl!.dy/height]];
    points[1] = [[imgWidth*tr!.dx/width, imgHeight*tr!.dy/height]];
    points[2] = [[imgWidth*bl!.dx/width, imgHeight*bl!.dy/height]];
    points[3] = [[imgWidth*br!.dx/width, imgHeight*br!.dy/height]];
    print(points);

    String base64Image = base64Encode(imagesQueue.last.readAsBytesSync());
    var url = Uri.parse('http://10.0.2.2:5000/cropper');

    // final response = await Dio().post(
    //   'http://10.0.2.2:5000/cropper',
    //   data: jsonEncode(
    //     {
    //       'points': points,
    //       'image': base64Image,
    //     },
    //   ),
    //   // options: Options(
    //   //   headers: {
    //   //     Headers.contentLengthHeader: postData.length, // set content-length
    //   //   },
    //   // ),
    // );

    final response = await http.post(
      url,
      body: jsonEncode(
        {
          'points': points,
          'image': base64Image,
        },
      ),
      // headers: {'Content-Type': "application/json",
      // 'Keep-Alive': "true"},
    );
    print('StatusCode : ${response.statusCode}');
    // print('Return Data : ${response.body}');

    // String imageStr = response.body).toString();
    Uint8List imageData = await compute(base64Decode, response.body);
    // setState(() {
    //   imagesQueue.add(File(imageData));
    // });

    // await Navigator.push(
    //     context,
    //     PageRouteBuilder(
    //         transitionDuration:
    //         Duration(milliseconds: 250),
    //         reverseTransitionDuration:
    //         Duration(milliseconds: 150),
    //         transitionsBuilder:
    //             (BuildContext context,
    //             Animation<double>
    //             animation,
    //             Animation<double>
    //             secAnimation,
    //             Widget child) {
    //           return FadeTransition(
    //             opacity: animation,
    //             child: child,
    //           );
    //         },
    //         pageBuilder: (BuildContext
    //         context,
    //             Animation<double> animation,
    //             Animation<double> secAnimation) {
    //           // return cropPage(realImage: image!,);
    //           // return CropPage(realImage: File(image!.path),);
    //           return TestPage(res: imageData,);
    //         }
    //     )
    // );

    // Navigator.pop(context);
    // String imageStr = json.decode(response.data)["img"].toString();
    // Image.memory(base64Decode(imageStr));
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
            onPressed: (() async {
              await getCroppedImage();
            }),
          ),
        ],
        title: Text(
          "Crop with Skew & Tilt",
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
                  double imgWidth,imgHeight,width,height;
                  imgWidth = snapshot.data!.image.width.toDouble();
                  imgHeight = snapshot.data!.image.height.toDouble();
                  width = size.width - 40;
                  height = imgHeight * width / imgWidth;
                  if (tl == null)
                    tl = Offset(20, 20);
                  if (tr == null)
                    tr = Offset(width - 20, 20);
                  if (bl == null)
                    bl = Offset(20, height - 20);
                  if (br == null)
                    br = Offset(width - 20, height - 20);
                  return Stack(
                    children: [
                      GestureDetector(
                        onPanDown: (details) {
                          double x1 = details.localPosition.dx;
                          double y1 = details.localPosition.dy;
                          double x2 = tl!.dx;
                          double y2 = tl!.dy;
                          double x3 = tr!.dx;
                          double y3 = tr!.dy;
                          double x4 = bl!.dx;
                          double y4 = bl!.dy;
                          double x5 = br!.dx;
                          double y5 = br!.dy;
                          if (sqrt(
                              (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                              x1 >= 0 &&
                              y1 >= 0 &&
                              x1 < width / 2 &&
                              y1 < height / 2) {
                            print(details.localPosition);
                            setState(() {
                              tl = details.localPosition;
                            });
                          } else if (sqrt((x3 - x1) * (x3 - x1) +
                              (y3 - y1) * (y3 - y1)) <
                              30 &&
                              x1 >= width / 2 &&
                              y1 >= 0 &&
                              x1 < width &&
                              y1 < height / 2) {
                            setState(() {
                              tr = details.localPosition;
                            });
                          } else if (sqrt((x4 - x1) * (x4 - x1) +
                              (y4 - y1) * (y4 - y1)) <
                              30 &&
                              x1 >= 0 &&
                              y1 >= height / 2 &&
                              x1 < width / 2 &&
                              y1 < height) {
                            setState(() {
                              bl = details.localPosition;
                            });
                          } else if (sqrt((x5 - x1) * (x5 - x1) +
                              (y5 - y1) * (y5 - y1)) <
                              30 &&
                              x1 >= width / 2 &&
                              y1 >= height / 2 &&
                              x1 < width &&
                              y1 < height) {
                            setState(() {
                              br = details.localPosition;
                            });
                          }
                        },
                        onPanUpdate: (details) {
                          double x1 = details.localPosition.dx;
                          double y1 = details.localPosition.dy;
                          double x2 = tl!.dx;
                          double y2 = tl!.dy;
                          double x3 = tr!.dx;
                          double y3 = tr!.dy;
                          double x4 = bl!.dx;
                          double y4 = bl!.dy;
                          double x5 = br!.dx;
                          double y5 = br!.dy;
                          if (sqrt(
                              (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1)) <
                              30 &&
                              x1 >= 0 &&
                              y1 >= 0 &&
                              x1 < width / 2 &&
                              y1 < height / 2) {
                            print(details.localPosition);
                            setState(() {
                              tl = details.localPosition;
                            });
                          } else if (sqrt((x3 - x1) * (x3 - x1) +
                              (y3 - y1) * (y3 - y1)) <
                              30 &&
                              x1 >= width / 2 &&
                              y1 >= 0 &&
                              x1 < width &&
                              y1 < height / 2) {
                            setState(() {
                              tr = details.localPosition;
                            });
                          } else if (sqrt((x4 - x1) * (x4 - x1) +
                              (y4 - y1) * (y4 - y1)) <
                              30 &&
                              x1 >= 0 &&
                              y1 >= height / 2 &&
                              x1 < width / 2 &&
                              y1 < height) {
                            setState(() {
                              bl = details.localPosition;
                            });
                          } else if (sqrt((x5 - x1) * (x5 - x1) +
                              (y5 - y1) * (y5 - y1)) <
                              30 &&
                              x1 >= width / 2 &&
                              y1 >= height / 2 &&
                              x1 < width &&
                              y1 < height) {
                            setState(() {
                              br = details.localPosition;
                            });
                          }
                        },
                        child: Container(
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
                          child: Image.file(
                            File(
                                widget.realImage.path
                            ),
                            key: key,
                          ),
                        ),
                      ),
                      // GestureDetector(
                      //         onPanDown: (details) {
                      //           this.setState(() {
                      //             print(details.localPosition);
                      //             //   points.add(DrawingArea(
                      //             //       point: details.localPosition,
                      //             //       areaPaint: Paint()
                      //             //         ..strokeCap = StrokeCap.round
                      //             //         ..isAntiAlias = true
                      //             //         ..color = selectedColor
                      //             //         ..strokeWidth = strokeWidth));
                      //           });
                      //         },
                      //         onPanUpdate: (details) {
                      //           this.setState(() {
                      //             //   points.add(DrawingArea(
                      //             //       point: details.localPosition,
                      //             //       areaPaint: Paint()
                      //             //         ..strokeCap = StrokeCap.round
                      //             //         ..isAntiAlias = true
                      //             //         ..color = selectedColor
                      //             //         ..strokeWidth = strokeWidth));
                      //           });
                      //         },
                      //         // onPanEnd: (details) {
                      //         //   this.setState(() {
                      //         //     points.add(null!);
                      //         //   });
                      //         // },
                      //         // child: ColoredBox(
                      //         //   color: Colors.green,
                      //         // ),
                      //         // child: Image.file(File(widget.realImage.path))
                      //     ),
                      SafeArea(
                        child: CustomPaint(
                          painter: CropPainter(tl!, tr!, bl!, br!),
                        ),
                      )
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
