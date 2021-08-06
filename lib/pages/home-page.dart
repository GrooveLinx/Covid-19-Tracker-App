import 'dart:convert';
import 'dart:io';
import 'package:covid19_app/models/country-covid-model.dart';
import 'package:covid19_app/pages/details-page.dart';
import 'package:covid19_app/pages/developer-page.dart';
import 'package:covid19_app/provider/covid-provider.dart';
import 'package:covid19_app/widgets/show-world-info.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as Http;
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  InterstitialAd myInterstitial;

  @override
  void initState() {
    super.initState();
    _createInterstitialAd(); // create ad
    //Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-4066984467805494/1921276828'
          : 'ca-app-pub-4066984467805494/1921276828', // test ad ids for different platforms
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // if ad fails to load
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad exited with error: $error');
        },

        // else
        onAdLoaded: (InterstitialAd ad) {
          setState(() {
            this.myInterstitial = ad; // set the ad equal to the current ad
          });
        },
      ),
    );
  }

  _showInterstitialAd() {
    // create callbacks for ad
    myInterstitial.fullScreenContentCallback = FullScreenContentCallback(
      // when dismissed
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CovidDetails(), // go to next page
        //   ),
        // );
        ad.dispose(); // dispose of ad
      },

      // if ad fails to show content
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => CovidDetails(), // go to next page
        //   ),
        // );
        print('$ad onAdFailedToShowFullScreenContent: $error'); // print error
        ad.dispose(); // dispose ad
      },
    );

    myInterstitial.show();
  }

  List<CountryData> countryData = [];
  bool isLoading = true;

  Future<void> getCountryData() async {
    final url = "https://disease.sh/v3/covid-19/countries";
    try {
      final response = await Http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final responseMap = jsonDecode(response.body);
        setState(
          () {
            for (Map map in responseMap) {
              countryData.add(
                CountryData.fromJson(map),
              );
            }

            isLoading = false;
          },
        );
      } else {}
    } catch (err) {
      throw err;
    }
  }

  CovidDataProvider covidDataProvider;

  @override
  void didChangeDependencies() {
    covidDataProvider = Provider.of<CovidDataProvider>(context, listen: false);
    covidDataProvider
        .fetchCovidData()
        .then(
          (_) => {
            setState(
              () {
                isLoading = false;
              },
            )
          },
        )
        .catchError(
      (err) {
        throw err;
      },
    );
    getCountryData();

    super.didChangeDependencies();
  }

  String converter(int data) {
    String B = 'B';
    String M = 'M';
    String K = 'K';
    if (data >= 1000000000) {
      final convertData = data / 1000000000;
      return convertData.toStringAsFixed(2) + B;
    } else if (data >= 1000000) {
      final convertData = data / 1000000;
      return convertData.toStringAsFixed(2) + M;
    } else {
      final convertData = data / 1000;
      return convertData.toStringAsFixed(2) + K;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber[50],
      appBar: AppBar(
        backgroundColor: Colors.amber[50],
        elevation: 0,
        title: Text(
          'Covid\'19 Tracker',
          style: GoogleFonts.ubuntu(
            textStyle: TextStyle(
              color: Colors.blueGrey,
              fontSize: 28.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.developer_board,
              color: Colors.blueGrey,
              size: 30.0,
            ),
            onPressed: () {
              _showInterstitialAd();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DeveloperPage(),
                ),
              );
            
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
                  height: MediaQuery.of(context).size.height * .20,
                  color: Colors.amber[50],
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Novel Corona\nVirus',
                              style: TextStyle(
                                color: Colors.teal[800],
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              'Stay Home Stay Safe',
                              style: TextStyle(
                                color: Colors.brown[800],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              softWrap: true,
                            ),
                          )
                        ],
                      ),
                      // FittedBox(
                      //   child: Image.asset(
                      //     'images/bacteria.png',
                      //     height: MediaQuery.of(context).size.height * .25,
                      //     width: MediaQuery.of(context).size.width * .40,
                      //     fit: BoxFit.contain,
                      //   ),
                      // ),
                      Container(
                        height: MediaQuery.of(context).size.height * .20,
                        width: MediaQuery.of(context).size.width * .33,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/bacteria.png'),
                            fit: BoxFit.contain,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.only(top: 5),
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Worldwide Covid Info',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.brown[800],
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  isLoading
                                      ? Center(
                                          child: CircularProgressIndicator(),
                                        )
                                      : Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .35,
                                          child: Consumer<CovidDataProvider>(
                                            builder: (context, proObj, _) =>
                                                ListView(
                                              scrollDirection: Axis.horizontal,
                                              children: [
                                                WorldCovidInfo(
                                                  title: 'Total\nCases',
                                                  color: Colors.purple,
                                                  imagePath: 'images/img3.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .totalConfirmed,
                                                  ),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nConfirmed',
                                                  color: Colors.orange[900],
                                                  imagePath: 'images/img1.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .newConfirmed,
                                                  ),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'Total\nRecovered',
                                                  color: Colors.green[900],
                                                  imagePath: 'images/img6.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .totalRecovered,
                                                  ),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nRecovered',
                                                  color: Colors.green[700],
                                                  imagePath: 'images/img4.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .newRecovered,
                                                  ),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'Total\nDeaths',
                                                  color: Colors.red[900],
                                                  imagePath: 'images/img5.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .totalDeaths,
                                                  ),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nDeaths',
                                                  color: Colors.red[700],
                                                  imagePath: 'images/img2.png',
                                                  data: converter(
                                                    proObj.getCovidData.global
                                                        .newDeaths,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.amber[50],
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20),
                                  ),
                                  child: ListView.builder(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                    ),
                                    itemCount: countryData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      final data = countryData[index];
                                      return InkWell(
                                        onTap: () {
                                          _showInterstitialAd();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CovidDetails(
                                                updated: data.updated,
                                                countryName:
                                                    data.country.toString(),
                                                flag: data.countryInfo.flag
                                                    .toString(),
                                                cases: data.cases.toString(),
                                                recovered:
                                                    data.recovered.toString(),
                                                deaths: data.deaths.toString(),
                                                active: data.active.toString(),
                                                recoveredToday: data
                                                    .todayRecovered
                                                    .toString(),
                                                todayDeaths:
                                                    data.todayDeaths.toString(),
                                                casesToday:
                                                    data.todayCases.toString(),
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              .20,
                                          width: double.infinity,
                                          margin: EdgeInsets.only(
                                            top: 12.0,
                                          ),
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(20),
                                              topRight: Radius.circular(20),
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.grey,
                                                  offset: Offset(1, 2),
                                                  spreadRadius: -7,
                                                  blurRadius: 10)
                                            ],
                                          ),
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      data.country.toString(),
                                                      style: GoogleFonts.ubuntu(
                                                        textStyle: TextStyle(
                                                          color: Colors
                                                              .blueGrey[600],
                                                          fontSize: 22.0,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      ),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 12,
                                                ),
                                                Row(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SizedBox(
                                                      width: 10,
                                                    ),
                                                    Image.network(
                                                      data.countryInfo.flag
                                                          .toString(),
                                                      height: 60,
                                                      width: 60,
                                                    ),
                                                    SizedBox(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              .1,
                                                    ),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          'Cases :  ${data.cases}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .brown[600],
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          // maxLines: 2,
                                                          softWrap: true,
                                                        ),
                                                        Text(
                                                          'Recovered :  ${data.recovered}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .green[800],
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          maxLines: 2,
                                                          softWrap: true,
                                                        ),
                                                        Text(
                                                          'Deaths :   ${data.deaths}',
                                                          style: GoogleFonts
                                                              .poppins(
                                                            textStyle:
                                                                TextStyle(
                                                              color: Colors
                                                                  .red[800],
                                                              fontSize: 18.0,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
