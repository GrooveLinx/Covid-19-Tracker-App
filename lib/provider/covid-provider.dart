import 'dart:convert';
import 'package:covid19_app/models/world-covid-model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as Http;

class CovidDataProvider extends ChangeNotifier {
  CovidData _covidData;
  CovidData get getCovidData => _covidData;
  Future fetchCovidData() async {
    final url = "https://api.covid19api.com/summary";
    try {
      final response = await Http.get(
        Uri.parse(url),
      );
      final responseMap = jsonDecode(response.body);
      //print(responseMap);
      _covidData = CovidData.fromJson(responseMap);
    } catch (err) {
      throw err;
    }
    notifyListeners();
  }
}
