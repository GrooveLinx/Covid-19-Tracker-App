import 'dart:convert';
import 'dart:io';
import 'package:covid19_app/pages/details-page.dart';
import 'package:covid19_app/pages/developer-page.dart';
import 'package:covid19_app/provider/connectivity-provider.dart';
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
    Provider.of<ConnectivityProvider>(context, listen: false).startMonitoring();
  }

  _createInterstitialAd() {
    InterstitialAd.load(
      adUnitId: Platform.isAndroid
          ? 'ca-app-pub-3940256099942544/1033173712'
          : 'ca-app-pub-3940256099942544/4411468910', // test ad ids for different platforms
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // if ad fails to load
        onAdFailedToLoad: (LoadAdError error) {
          print('Ad exited with error: $error');
        },

        // else
        onAdLoaded: (InterstitialAd ad) {
          setState(
            () {
              this.myInterstitial = ad; // set the ad equal to the current ad
            },
          );
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
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CovidDetails(), // go to next page
          ),
        );
        print('$ad onAdFailedToShowFullScreenContent: $error'); // print error
        ad.dispose(); // dispose ad
      },
    );

    myInterstitial.show();
  }

  List countryData;
  bool isLoading = true;

  Future<String> getCountryData() async {
    final url = "https://disease.sh/v3/covid-19/countries";
    try {
      final response = await Http.get(
        Uri.parse(url),
      );

      setState(
        () {
          countryData = jsonDecode(response.body);
          isLoading = false;
        },
      );
    } catch (err) {
      throw err;
    }
    return 'request linked successfully!';
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
                      EdgeInsets.only(left: 10, right: 15, top: 10, bottom: 5),
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
                      FittedBox(
                        child: Image.asset(
                          'images/bacteria.png',
                          height: MediaQuery.of(context).size.height * .25,
                          width: MediaQuery.of(context).size.width * .40,
                          fit: BoxFit.contain,
                        ),
                      ),
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
                                                  data: proObj.getCovidData
                                                      .global.totalConfirmed
                                                      .toString(),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nConfirmed',
                                                  color: Colors.orange[900],
                                                  imagePath: 'images/img1.png',
                                                  data: proObj.getCovidData
                                                      .global.newConfirmed
                                                      .toString(),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nRecovered',
                                                  color: Colors.green[700],
                                                  imagePath: 'images/img4.png',
                                                  data: proObj.getCovidData
                                                      .global.newRecovered
                                                      .toString(),
                                                ),
                                                WorldCovidInfo(
                                                  title: 'New\nDeaths',
                                                  color: Colors.red[800],
                                                  imagePath: 'images/img2.png',
                                                  data: proObj.getCovidData
                                                      .global.newDeaths
                                                      .toString(),
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
                                    itemCount: countryData.length == null
                                        ? 1
                                        : countryData.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return InkWell(
                                        onTap: () {
                                          _showInterstitialAd();
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => CovidDetails(
                                                updated: countryData[index]
                                                    ['updated'],
                                                countryName:
                                                    '${countryData[index]["country"]}',
                                                flag:
                                                    '${countryData[index]["countryInfo"]['flag']}',
                                                cases: countryData[index]
                                                        ['cases']
                                                    .toString(),
                                                recovered: countryData[index]
                                                        ['recovered']
                                                    .toString(),
                                                deaths: countryData[index]
                                                        ['deaths']
                                                    .toString(),
                                                active: countryData[index]
                                                        ['active']
                                                    .toString(),
                                                recoveredToday:
                                                    countryData[index]
                                                            ['todayRecovered']
                                                        .toString(),
                                                todayDeaths: countryData[index]
                                                        ['todayDeaths']
                                                    .toString(),
                                                casesToday: countryData[index]
                                                        ['todayCases']
                                                    .toString(),
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
                                                      '${countryData[index]['country']}' ==
                                                              null
                                                          ? 'loading...'
                                                          : '${countryData[index]['country']}',
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
                                                    Image.network(
                                                      countryData[index][
                                                                      'countryInfo']
                                                                  ['flag'] ==
                                                              null
                                                          ? Icon(
                                                              Icons.flag,
                                                              size: 40.0,
                                                              color: Colors
                                                                  .blueGrey,
                                                            )
                                                          : countryData[index][
                                                                  'countryInfo']
                                                              ['flag'],
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
                                                          'Cases : ${countryData[index]['cases']}' ==
                                                                  null
                                                              ? 'loading'
                                                              : 'Cases : ${countryData[index]['cases']}',
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
                                                          'Recovered : ${countryData[index]['recovered']}' ==
                                                                  null
                                                              ? 'loading'
                                                              : 'Recovered : ${countryData[index]['recovered']}',
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
                                                          'Deaths : ${countryData[index]['deaths']}' ==
                                                                  null
                                                              ? 'loading'
                                                              : 'Deaths : ${countryData[index]['deaths']}',
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
