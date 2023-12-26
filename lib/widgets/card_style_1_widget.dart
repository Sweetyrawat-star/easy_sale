import 'package:flutter/material.dart';

class CardStyle1Widget extends StatelessWidget {
  final ImageProvider bgImage;
  final String buttonText;
  final VoidCallback onPressed;

  const CardStyle1Widget({
    Key? key,
    required this.bgImage,
    required this.buttonText,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Container(
        width: 180.0,
        height: 215.0,
        child: Column(
          children: [
            Container(
              height: 200.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fitHeight,
                    image: bgImage),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
            ),
          ],
        ),
      ),
      Positioned(
        top: 180.0,
        child: Container(
          width: 180.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                height: 30.0,
                width: 118.0,
                decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFFF1E35C),
                      Color(0xFFFF9243),
                    ]),
                    borderRadius: BorderRadius.circular(30.0)),
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent),
                  child: Text(
                    buttonText,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              )
            ],
          ),
        ),
      )
    ]);
  }
}
