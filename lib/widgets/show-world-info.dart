import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WorldCovidInfo extends StatelessWidget {
  final String title;
  final String imagePath;
  final Color color;
  final String data;
  const WorldCovidInfo({
    Key key,
    this.title,
    this.imagePath,
    this.color,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.green[100],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: Color(0xFF666666),
                offset: Offset(1, 4),
                spreadRadius: -5,
                blurRadius: 10)
          ],
        ),
        height: MediaQuery.of(context).size.height * .35,
        width: MediaQuery.of(context).size.width * .40,
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.ubuntu(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
            Image.asset(
              imagePath,
              height: MediaQuery.of(context).size.height * .15,
              width: MediaQuery.of(context).size.width * .25,
              fit: BoxFit.cover,
            ),
            Spacer(),
            Text(
              data == null ? 'loading...' : data,
              style: GoogleFonts.rajdhani(
                textStyle: TextStyle(
                  color: color,
                  fontSize: 22.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}