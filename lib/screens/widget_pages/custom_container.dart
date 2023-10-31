import 'dart:ui';

import 'package:flutter/material.dart';

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); 

    final waveControlPoint1 = Offset(size.width / 3, size.height - 170);
    final waveEndPoint1 = Offset(size.width / 1, size.height - 100);
    path.quadraticBezierTo(
        waveControlPoint1.dx, waveControlPoint1.dy, waveEndPoint1.dx, waveEndPoint1.dy);

    final waveControlPoint2 = Offset(size.width *  8, size.height - 150);
    final waveEndPoint2 = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
        waveControlPoint2.dx, waveControlPoint2.dy, waveEndPoint2.dx, waveEndPoint2.dy);

    path.lineTo(size.width, 0); 
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; 
  }
}
class MyCustomClipper1 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); 

    final waveControlPoint1 = Offset(size.width / 4, size.height - 130);
    final waveEndPoint1 = Offset(size.width / 2, size.height - 50);
    path.quadraticBezierTo(
        waveControlPoint1.dx, waveControlPoint1.dy, waveEndPoint1.dx, waveEndPoint1.dy);

    final waveControlPoint2 = Offset(size.width * 3 / 4, size.height + 20);
    final waveEndPoint2 = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
        waveControlPoint2.dx, waveControlPoint2.dy, waveEndPoint2.dx, waveEndPoint2.dy);

    path.lineTo(size.width, 0); 
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; 
  }
}
class MyCustomClipper2 extends CustomClipper<Path> {
  @override
Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 50); 

    final waveControlPoint1 = Offset(size.width / 3, size.height - 190);
    final waveEndPoint1 = Offset(size.width / 1, size.height - 50);
    path.quadraticBezierTo(
        waveControlPoint1.dx, waveControlPoint1.dy, waveEndPoint1.dx, waveEndPoint1.dy);

    final waveControlPoint2 = Offset(size.width *  8, size.height - 130);
    final waveEndPoint2 = Offset(size.width, size.height - 30);
    path.quadraticBezierTo(
        waveControlPoint2.dx, waveControlPoint2.dy, waveEndPoint2.dx, waveEndPoint2.dy);

    path.lineTo(size.width, 0); 
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true; 
  }
}
