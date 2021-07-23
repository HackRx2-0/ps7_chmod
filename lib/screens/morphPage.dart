import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:chmod/main.dart';
import 'package:chmod/screens/testPage.dart';
import 'package:chmod/services/filterListItem.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:multi_value_listenable_builder/multi_value_listenable_builder.dart';
import 'dart:ui' as ui;

class MorphPage extends StatefulWidget {
  Uint8List realImage;

  MorphPage({Key? key, required this.realImage}) : super(key: key);

  @override
  _MorphPageState createState() => _MorphPageState();
}

class _MorphPageState extends State<MorphPage> {
  final GlobalKey key = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();
  ValueNotifier<double> red=ValueNotifier<double>(1), green=ValueNotifier<double>(1),
      blue=ValueNotifier<double>(1), alpha=ValueNotifier<double>(1);

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
          "Color Morph",
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
                            valueListenables: [red,green,blue,alpha],
                            builder: (context, dynamic val, child) {
                              return RepaintBoundary(
                                key: _globalKey,
                                child: ColorFiltered(
                                  colorFilter: ColorFilter.matrix([
                                    red.value, 0.0, 0.0, 0.0, 0.0,
                                    0.0, green.value, 0.0, 0.0, 0.0,
                                    0.0, 0.0, blue.value, 0.0, 0.0,
                                    0.0, 0.0, 0.0, alpha.value, 0.0
                                  ]),
                                  child: Image.memory(
                                    widget.realImage,
                                  ),
                                ),
                              );
                            }
                        ),
                      ),
                      Expanded(
                        child: MultiValueListenableBuider(
                            valueListenables: [red,green,blue,alpha],
                            builder: (context, dynamic val, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text("R")),
                                        Expanded(
                                          child: Slider(
                                            value: red.value,
                                            min: 0,
                                            max: 3,
                                            onChanged: (double value) {
                                              red.value = value;
                                            },

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text("G")),
                                        Expanded(
                                          child: Slider(
                                            value: green.value,
                                            min: 0,
                                            max: 3,
                                            onChanged: (double value) {
                                              green.value = value;
                                            },

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text("B")),
                                        Expanded(
                                          child: Slider(
                                            value: blue.value,
                                            min: 0,
                                            max: 3,
                                            onChanged: (double value) {
                                              blue.value = value;
                                            },

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Row(
                                      children: [
                                        FittedBox(
                                            fit: BoxFit.fitWidth,
                                            child: Text("A")),
                                        Expanded(
                                          child: Slider(
                                            value: alpha.value,
                                            min: 0,
                                            max: 1,
                                            onChanged: (double value) {
                                              alpha.value = value;
                                            },

                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }
                        ),
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
