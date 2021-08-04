import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CovidInfoCard extends StatelessWidget {
  final String title;
  final String data;
  final Color color;
  const CovidInfoCard({Key key, this.title, this.data, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: color,
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          softWrap: true,
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          data == null ? 'loading...' : data,
          textAlign: TextAlign.center,
          style: GoogleFonts.rajdhani(
            textStyle: TextStyle(
              color: color,
              fontSize: 26.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          softWrap: true,
        )
      ],
    );
  }
}
