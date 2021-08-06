// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/services.dart';

// class ConnectivityProvider extends ChangeNotifier {
//   Connectivity _connectivity = Connectivity();

//   bool _isOnline;
//   bool get isOnline => _isOnline;

//   startMonitoring() async {
//     await initConnectivity();
//     _connectivity.onConnectivityChanged.listen(
//       (result) async {
//         if (result == ConnectivityResult.none) {
//           _isOnline = false;
//           notifyListeners();
//         } else {
//           _isOnline = true;
//           notifyListeners();
//         }
//       },
//     );
//   }

//   Future<void> initConnectivity() async {
//     try {
//       var status = await _connectivity.checkConnectivity();

//       if (status == ConnectivityResult.none) {
//         _isOnline = false;
//         notifyListeners();
//       } else {
//         await updateConnectionStatus().then(
//           (bool isConnected) => {_isOnline = isConnected},
//         );
//         notifyListeners();
//       }
//     } on PlatformException catch (err) {
//       throw err;
//     }
//   }

//   Future<bool> updateConnectionStatus() async {
//     bool isConnected;
//     try {
//       final List<InternetAddress> result =
//           await InternetAddress.lookup('google.com');
//       if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
//         isConnected = true;
//       } else {}
//     } on SocketException catch (_) {
//       isConnected = false;
//     }
//   }
// }
