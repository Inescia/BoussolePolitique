# Monétisation AdMob

## État actuel

L’app utilise **Google AdMob** avec des **IDs de test** par défaut.
Les pubs s’affichent ainsi :

- **Bannière** : page des cartes uniquement — pas sur l’accueil
- **Interstitiel vidéo** : tous les **25** réponses (configurable), avec cooldown 2 min
- Interstitiel optionnel aussi en quittant les résultats

Le consentement RGPD (UMP) est demandé au démarrage en Europe.

## Pour passer en production (gagner de l’argent)

1. Crée un compte sur [https://admob.google.com](https://admob.google.com)
2. Ajoute ton app Android + iOS
3. Crée 2 unités : **Banner** et **Interstitial** pour chaque plateforme
4. Remplace les IDs `*Prod` dans `lib/core/ads/ad_config.dart`
5. Mets à jour les App IDs dans :
   - `android/app/src/main/AndroidManifest.xml` (`APPLICATION_ID`)
   - `ios/Runner/Info.plist` (`GADApplicationIdentifier`)
6. Build release avec les IDs prod :

```bash
flutter build apk --release --dart-define=USE_TEST_ADS=false
flutter build ios --release --dart-define=USE_TEST_ADS=false
```

7. Publie l’app sur le Play Store / App Store (AdMob ne paie en réel qu’avec des apps publiées + trafic réel)

## Règles importantes

- Ne jamais envoyer les réponses des cartes à AdMob (déjà respecté dans le code)
- Ne clique pas toi-même sur tes pubs (risque de ban)
- Mets à jour la politique de confidentialité du store aussi
