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
import 'package:opencv/opencv.dart';
import 'dart:ui' as ui;

class FiltersPage extends StatefulWidget {
  Uint8List realImage;

  FiltersPage({Key? key, required this.realImage}) : super(key: key);

  @override
  _FiltersPageState createState() => _FiltersPageState();
}

class _FiltersPageState extends State<FiltersPage> {
  final GlobalKey key = GlobalKey();
  final GlobalKey _globalKey = GlobalKey();
  ValueNotifier<double> contrast=ValueNotifier<double>(1), brightness=ValueNotifier<double>(1);
  List<List> colorMap = [
    ["Autumn",0],
    ["Bone",1],
    ["Jet",2],
    ["Winter",3],
    ["Rainbow",4],
    ["Ocean",5],
    ["Summer",6],
    ["Spring",7],
    ["Cool",8],
    ["HSV",9],
    ["Pink",10],
    ["Hot",11],
    ["Magma",13],
    ["Viridis",16],
    ["Cividis",17],
    ["Turbo",10]
  ];

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
    imagesQueue.add(widget.realImage);
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
          "Filters",
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
                            valueListenables: [contrast,brightness],
                            builder: (context, dynamic val, child) {
                              return Image.memory(
                                widget.realImage,
                              );
                            }
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          width: size.width,
                          // height: size.height * 0.2,
                          child: MultiValueListenableBuider(
                              valueListenables: [contrast,brightness],
                              builder: (context, dynamic val, child) {
                                return ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: colorMap.length,
                                  itemBuilder: (BuildContext context,int index) {
                                    return GestureDetector(
                                      onTap: (() async {
                                        Uint8List res = await ImgProc.applyColorMap(
                                          imagesQueue.last,
                                          colorMap[index][1],
                                        );
                                        setState(() {
                                          widget.realImage = res;
                                        });
                                      }),
                                      child: FilterListItem(size: size,
                                          imageName: "assets/colormap/${colorMap[index][0].toLowerCase()}.png",
                                          text: colorMap[index][0],
                                      ),
                                    );
                                  }
                                );
                              }
                          ),
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
