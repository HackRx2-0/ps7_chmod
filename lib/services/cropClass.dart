import 'package:flutter/material.dart';

class CropPainter extends CustomPainter {
  Offset tl, tr, bl, br;
  CropPainter(this.tl, this.tr, this.bl, this.br);
  Paint painter = Paint()
    ..color = Colors.teal
    ..strokeWidth = 2
    ..strokeCap = StrokeCap.round
    ..style=PaintingStyle.stroke;
  Paint painter1 = Paint()
    ..color = Colors.teal
    ..strokeWidth = 3
    ..strokeCap = StrokeCap.round;
  Paint painter2 = Paint()
    ..color = Colors.teal
    ..strokeWidth = 1
    ..strokeCap = StrokeCap.square;
  @override
  void paint(Canvas canvas, Size size) {
    // TODO: implement paint
    canvas.drawCircle(tl, 10, painter);
    canvas.drawCircle(tr, 10, painter);
    canvas.drawCircle(bl, 10, painter);
    canvas.drawCircle(br, 10, painter);
    canvas.drawLine(tl,tr, painter1);
    canvas.drawLine(tr,br, painter1);
    canvas.drawLine(br,bl, painter1);
    canvas.drawLine(bl,tl, painter1);

    canvas.drawLine(Offset.lerp(tl, bl, 1/3)!,Offset.lerp(tr, br, 1/3)!, painter2);
    canvas.drawLine(Offset.lerp(tl, bl, 2/3)!,Offset.lerp(tr, br, 2/3)!, painter2);
    canvas.drawLine(Offset.lerp(tl, tr, 1/3)!,Offset.lerp(bl, br, 1/3)!, painter2);
    canvas.drawLine(Offset.lerp(tl, tr, 2/3)!,Offset.lerp(bl, br, 2/3)!, painter2);

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}