import 'dart:io';

class AdManager {
  static String get appId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3496192796505191~5677935227";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3496192796505191~5677935227";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

//  static String get bannerAdUnitId {
//    if (Platform.isAndroid) {
//      return "ca-app-pub-3940256099942544/8865242552";
//    } else if (Platform.isIOS) {
//      return "ca-app-pub-3940256099942544/4339318960";
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3496192796505191/3005161115";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3496192796505191/3005161115";
    } else {
      throw new UnsupportedError("Unsupported platform");
    }
  }

//  static String get rewardedAdUnitId {
//    if (Platform.isAndroid) {
//      return "ca-app-pub-3940256099942544/8673189370";
//    } else if (Platform.isIOS) {
//      return "ca-app-pub-3940256099942544/7552160883";
//    } else {
//      throw new UnsupportedError("Unsupported platform");
//    }
//  }
}
