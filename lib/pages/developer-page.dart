import 'package:covid19_app/pages/home-page.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mdi/mdi.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperPage extends StatelessWidget {
  const DeveloperPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            size: 30,
            color: Colors.blueGrey,
          ),
          onPressed: () {
            Navigator.pop(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(), // replace popped page to call init again
              ),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(), // replace popped page to call init again
              ),
            );
          },
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Developer',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.pink[50],
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(40),
              ),
            ),
            height: height * .35,
            width: double.infinity,
            child: Image.asset(
              'images/dev.jpg',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: height * .02,
          ),
          Expanded(
            child: Container(
              height: double.infinity,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.pink[50],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * .3,
                          height: MediaQuery.of(context).size.height * .18,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(400),
                            child: Image.asset(
                              'images/ripplebee_logo.png',
                              height: height * .15,
                              width: width * .25,
                              fit: BoxFit.cover,
                              alignment: Alignment.centerLeft,
                            ),
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * .1,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(
                            color: Color(0xFF442C3E),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              bottomRight: Radius.circular(30),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.developer_board,
                                size: 30,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Text(
                                'Developers',
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          onPressed: () {
                            _openFacebookLink(
                                'https://www.facebook.com/rippledevs/');
                          },
                          icon: Icon(
                            Mdi.facebook,
                            size: 45,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .13,
                        ),
                        IconButton(
                          onPressed: () {
                            _openLinkedInLink(
                                'https://www.linkedin.com/company/ripplebee/');
                          },
                          icon: Icon(
                            Mdi.linkedin,
                            size: 45,
                            color: Colors.blueGrey,
                          ),
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * .13,
                        ),
                        IconButton(
                          onPressed: () {
                            _openTwitterLink('https://twitter.com/rippledevs');
                          },
                          icon: Icon(
                            Mdi.twitter,
                            size: 45,
                            color: Colors.blueGrey,
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.purple[100],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(25),
                                // topRight: Radius.circular(25),
                              ),
                            ),
                            width: width,
                            child: Center(
                              child: Text(
                                'Powered by\nGeeks of RippleBee',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  textStyle: TextStyle(
                                      color: Colors.grey[800],
                                      fontWeight: FontWeight.w600,
                                      fontSize: 20,
                                      letterSpacing: 0.5),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _openFacebookLink(String url) async {
  try {
    await launch(url);
  } catch (err) {
    print('could not launch $url');
  }
}

Future<void> _openLinkedInLink(String url) async {
  try {
    await launch(url);
  } catch (err) {
    print('could not launch $url');
  }
}

Future<void> _openTwitterLink(String url) async {
  try {
    await launch(url);
  } catch (err) {
    print('could not launch $url');
  }
}
