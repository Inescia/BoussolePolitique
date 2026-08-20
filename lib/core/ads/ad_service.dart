import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'ad_config.dart';

/// Service pubs : consentement RGPD + AdMob.
/// Ne reçoit jamais les réponses du quiz ni le profil politique.
class AdService {
  AdService({required SharedPreferences prefs}) : _prefs = prefs;

  final SharedPreferences _prefs;

  static const _prefsLastInterstitial = 'ads_last_interstitial_ms';
  static const _prefsLastVideoAtCount = 'ads_last_video_at_answer_count';

  bool _initialized = false;
  bool _canRequestAds = false;
  InterstitialAd? _interstitial;
  bool _showing = false;

  bool get isReady => _initialized && _canRequestAds;

  Future<void> initialize() async {
    if (kIsWeb) return;

    try {
      await _requestConsentThenInit();
    } catch (e, st) {
      debugPrint('AdService init failed: $e\n$st');
      try {
        await MobileAds.instance.initialize();
        _initialized = true;
        _canRequestAds = true;
        await preloadInterstitial();
      } catch (_) {}
    }
  }

  Future<void> _requestConsentThenInit() async {
    final params = ConsentRequestParameters();
    final consentUpdated = Completer<void>();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () {
        if (!consentUpdated.isCompleted) consentUpdated.complete();
      },
      (error) {
        debugPrint('Consent update error: ${error.message}');
        if (!consentUpdated.isCompleted) consentUpdated.complete();
      },
    );
    await consentUpdated.future;

    await ConsentForm.loadAndShowConsentFormIfRequired((formError) {
      if (formError != null) {
        debugPrint('Consent form error: ${formError.message}');
      }
    });

    _canRequestAds = await ConsentInformation.instance.canRequestAds();
    if (!_canRequestAds) {
      debugPrint('AdService: cannot request ads yet (consent).');
      return;
    }

    await MobileAds.instance.initialize();
    _initialized = true;
    await preloadInterstitial();
  }

  Future<void> preloadInterstitial() async {
    if (!_initialized || !_canRequestAds) return;
    if (_interstitial != null) return;

    await InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitial?.dispose();
          _interstitial = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitial = null;
              _showing = false;
              preloadInterstitial();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitial = null;
              _showing = false;
              preloadInterstitial();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('Interstitial failed to load: ${error.message}');
          _interstitial = null;
        },
      ),
    );
  }

  bool _cooldownElapsed() {
    final lastMs = _prefs.getInt(_prefsLastInterstitial) ?? 0;
    final elapsed = DateTime.now().millisecondsSinceEpoch - lastMs;
    return elapsed >= AdConfig.interstitialCooldown.inMilliseconds;
  }

  Future<bool> _showLoadedInterstitial() async {
    if (!isReady || _showing) return false;
    final ad = _interstitial;
    if (ad == null) {
      await preloadInterstitial();
      return false;
    }

    _showing = true;
    _interstitial = null;
    await ad.show();
    await _prefs.setInt(
      _prefsLastInterstitial,
      DateTime.now().millisecondsSinceEpoch,
    );
    return true;
  }

  /// Vidéo / interstitiel tous les [AdConfig.cardsBetweenVideoAds] réponses.
  Future<bool> maybeShowVideoAfterCards({required int answeredCount}) async {
    if (answeredCount <= 0) return false;
    if (answeredCount % AdConfig.cardsBetweenVideoAds != 0) return false;
    if (!_cooldownElapsed()) return false;

    final lastAt = _prefs.getInt(_prefsLastVideoAtCount) ?? 0;
    if (answeredCount <= lastAt) return false;

    final shown = await _showLoadedInterstitial();
    if (shown) {
      await _prefs.setInt(_prefsLastVideoAtCount, answeredCount);
    } else {
      await preloadInterstitial();
    }
    return shown;
  }

  /// Interstitiel optionnel hors quiz (ex. quitter résultats).
  Future<bool> showInterstitialIfAppropriate() async {
    if (!_cooldownElapsed()) return false;
    return _showLoadedInterstitial();
  }

  Future<void> openPrivacyOptions() async {
    await ConsentForm.showPrivacyOptionsForm((formError) {
      if (formError != null) {
        debugPrint('Privacy options error: ${formError.message}');
      }
    });
  }

  Future<bool> get privacyOptionsRequired async {
    final status = await ConsentInformation.instance
        .getPrivacyOptionsRequirementStatus();
    return status == PrivacyOptionsRequirementStatus.required;
  }

  void dispose() {
    _interstitial?.dispose();
    _interstitial = null;
  }
}
