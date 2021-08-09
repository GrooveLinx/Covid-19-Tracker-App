import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfffefefe),
      body: SafeArea(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(),
              Spacer(),
              Image.asset(
                'images/error1.png',
                height: MediaQuery.of(context).size.height * .5,
                width: double.infinity,
              ),
              Spacer(),
              Text(
                'Seems like you\'re in offline!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.blueGrey[200],
                    fontSize: 23.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                softWrap: true,
              ),
              Spacer(),
              Text(
                'Please check your\nInternet Connection!',
                textAlign: TextAlign.center,
                style: GoogleFonts.lato(
                  textStyle: TextStyle(
                    color: Colors.blueGrey[200],
                    fontSize: 22.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                softWrap: true,
              ),
              Spacer(),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
