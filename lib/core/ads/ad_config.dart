import 'dart:io';

import 'package:flutter/foundation.dart';

/// Configuration AdMob.
///
/// En développement : IDs de test Google (`USE_TEST_ADS=true`, défaut).
/// En production : remplace les IDs `*Prod` puis build avec
/// `--dart-define=USE_TEST_ADS=false`.
abstract final class AdConfig {
  static const bool useTestAds = bool.fromEnvironment(
    'USE_TEST_ADS',
    defaultValue: true,
  );

  static const String androidAppIdTest = 'ca-app-pub-3940256099942544~3347511713';
  static const String iosAppIdTest = 'ca-app-pub-3940256099942544~1458002511';

  static const String androidAppIdProd = 'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';
  static const String iosAppIdProd = 'ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY';

  static const String _androidBannerTest = 'ca-app-pub-3940256099942544/6300978111';
  static const String _iosBannerTest = 'ca-app-pub-3940256099942544/2934735716';
  static const String _androidInterstitialTest =
      'ca-app-pub-3940256099942544/1033173712';
  static const String _iosInterstitialTest =
      'ca-app-pub-3940256099942544/4411468910';

  static const String androidBannerProd = 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB';
  static const String iosBannerProd = 'ca-app-pub-XXXXXXXXXXXXXXXX/BBBBBBBBBB';
  static const String androidInterstitialProd =
      'ca-app-pub-XXXXXXXXXXXXXXXX/IIIIIIIIII';
  static const String iosInterstitialProd =
      'ca-app-pub-XXXXXXXXXXXXXXXX/IIIIIIIIII';

  static bool get _useTestUnits => useTestAds || kDebugMode;

  /// Bannière sur la page des cartes uniquement.
  static String get bannerAdUnitId {
    if (_useTestUnits) {
      return Platform.isIOS ? _iosBannerTest : _androidBannerTest;
    }
    return Platform.isIOS ? iosBannerProd : androidBannerProd;
  }

  /// Interstitiel vidéo (souvent vidéo côté AdMob).
  static String get interstitialAdUnitId {
    if (_useTestUnits) {
      return Platform.isIOS ? _iosInterstitialTest : _androidInterstitialTest;
    }
    return Platform.isIOS ? iosInterstitialProd : androidInterstitialProd;
  }

  /// Une vidéo / interstitiel tous les N réponses.
  static const int cardsBetweenVideoAds = 25;

  /// Filet de sécurité anti-spam (en plus du compteur de cartes).
  static const Duration interstitialCooldown = Duration(minutes: 2);
}
