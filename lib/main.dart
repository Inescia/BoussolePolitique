import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'core/ads/ad_service.dart';

/// Point d'entrée de l'application Boussole Politique.
///
/// Séquence de démarrage :
/// 1. Verrouillage portrait
/// 2. Chargement [SharedPreferences] (progression quiz, réglages)
/// 3. Initialisation asynchrone AdMob (non bloquante)
/// 4. Lancement de [BoussoleApp] avec injection des dépendances
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  final prefs = await SharedPreferences.getInstance();
  final ads = AdService(prefs: prefs);
  // Ne bloque pas le démarrage de l'UI.
  // ignore: unawaited_futures
  ads.initialize();
  runApp(BoussoleApp(prefs: prefs, adService: ads));
}
