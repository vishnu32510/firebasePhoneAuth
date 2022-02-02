import 'package:flutter/material.dart';
import 'package:flutter_task/utils/colors.dart';

class CurvedTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = primaryColor
      ..strokeWidth = 15;

    var path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(-40, 20,
        70, 60);
    // path.quadraticBezierTo(size.width * 0.75, size.height * 0.9,
    //     size.width * 1.0, size.height * 0.8);
    path.lineTo(size.width, size.height * 0.6);
    path.lineTo(size.width, 0);


    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

class RPSCustomPainter extends CustomPainter{

  @override
  void paint(Canvas canvas, Size size) {



    Paint paint0 = Paint()
      ..color = primaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;


    Path path0 = Path();
    path0.moveTo(size.width*0.0875600,size.height*0.2318800);
    path0.cubicTo(size.width*0.5313000,size.height*0.2338400,size.width*0.7292100,size.height*0.2296800,size.width*0.8771600,size.height*0.2303200);
    path0.quadraticBezierTo(size.width*0.9500500,size.height*0.2225000,size.width*0.9416000,size.height*0.3593200);
    path0.quadraticBezierTo(size.width*0.9425700,size.height*0.5541800,size.width*0.9429100,size.height*0.6194400);
    path0.quadraticBezierTo(size.width*0.9468200,size.height*0.7671000,size.width*0.8787200,size.height*0.7556200);
    path0.quadraticBezierTo(size.width*0.2349800,size.height*0.4642600,size.width*0.0862600,size.height*0.3649000);
    path0.cubicTo(size.width*0.0350400,size.height*0.3259800,size.width*0.0266500,size.height*0.2439000,size.width*0.0875600,size.height*0.2318800);
    path0.close();

    canvas.drawPath(path0, paint0);


  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }

}



