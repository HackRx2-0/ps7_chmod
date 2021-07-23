import 'dart:async';
import 'dart:typed_data';
import 'package:chmod/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opencv/opencv.dart';

class BWPage extends StatefulWidget {
  Uint8List realImage;

  BWPage({Key? key, required this.realImage}) : super(key: key);

  @override
  _BWPageState createState() => _BWPageState();
}

class _BWPageState extends State<BWPage> {
  final GlobalKey key = GlobalKey();
  Offset? tl , tr, bl, br;
  double sliderVal=0;

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
    processImg();
    return completer.future;
  }

  Future<void> processImg() async{
    setState(() async {
      widget.realImage =  await ImgProc.cvtColor(widget.realImage, ImgProc.colorBGR2GRAY);
    });
  }

  void saveImg() {
    imagesQueue.add(widget.realImage);
    refreshVar.value = refreshVar.value + 1;
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
          "Black & White",
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
                  return Container(
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
                    child: Image.memory(
                      widget.realImage,
                    ),
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
