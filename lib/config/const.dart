import 'package:intl/intl.dart';

final url = 'https://disease.sh/v3/covid-19/countries/';
String getFormattedDate(int date, String format) =>
    DateFormat(format).format(DateTime.fromMillisecondsSinceEpoch(date * 1000));
