import 'dart:io';

class AdHelper {
  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4066984467805494/1906680983';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-4066984467805494/1906680983';
    } else {
      throw new UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4066984467805494/1921276828";
    } else if (Platform.isIOS) {
      return "ca-app-pub-4066984467805494/1921276828";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }
}
