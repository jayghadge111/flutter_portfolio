import 'dart:convert';
import 'dart:developer';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayesh_flutter/src/firebase_services/fallback_data.dart';

import '../models/portfolio_data.dart';
import 'firebase_options.dart';

// Define providers
final remoteConfigServiceProvider =
    FutureProvider<RemoteConfigService>((ref) async {
  try {
    return await RemoteConfigService.initialize();
  } catch (e) {
    log('Error initializing RemoteConfigService: $e');
    // Return a default instance that will use fallback data
    return RemoteConfigService(FirebaseRemoteConfig.instance);
  }
});

final portfolioDataProvider = FutureProvider<PortfolioData>((ref) async {
  try {
    final remoteConfigService =
        await ref.watch(remoteConfigServiceProvider.future);
    return await remoteConfigService.getPortfolioData();
  } catch (e) {
    log('Error in portfolioDataProvider: $e');
    // Return fallback data
    return getFallbackPortfolioData();
  }
});

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig;

  RemoteConfigService(this._remoteConfig);

  // Initialize the remote config
  static Future<RemoteConfigService> initialize() async {
    try {
      // Check if Firebase is already initialized
      // Special handling for web platform
      if (kIsWeb) {
        // Check if Firebase is already initialized
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: firebaseOptions,
          );
        }
      } else {
        // Non-web initialization
        if (Firebase.apps.isEmpty) {
          await Firebase.initializeApp(
            options: firebaseOptions,
          );
        }
      }

      final remoteConfig = FirebaseRemoteConfig.instance;

      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 1),
        ),
      );

      try {
        await remoteConfig.fetchAndActivate();
        log('Remote config fetched and activated');
      } catch (e) {
        log('Error fetching remote config: $e');
        // Continue even if fetch fails - will use defaults
      }

      return RemoteConfigService(remoteConfig);
    } catch (e) {
      log('Error in initialize: $e');
      rethrow;
    }
  }

  // Fetch the portfolio data
  Future<PortfolioData> getPortfolioData() async {
    try {
      final portfolioString = _remoteConfig.getString('portfolio');
      log('Remote Config portfolio data: $portfolioString');

      if (portfolioString.isEmpty) {
        log('Portfolio data from Remote Config is empty, using fallback');
        return getFallbackPortfolioData();
      }

      try {
        return PortfolioData.fromJson(jsonDecode(portfolioString));
      } catch (e) {
        log('Error parsing portfolio data: $e');
        return getFallbackPortfolioData();
      }
    } catch (e) {
      log('Error fetching portfolio data: $e');
      return getFallbackPortfolioData();
    }
  }

  // Get a specific value from remote config
  String getString(String key) {
    try {
      return _remoteConfig.getString(key);
    } catch (e) {
      log('Error getting string for key $key: $e');
      return '';
    }
  }
}

// Fallback portfolio data using raw JSON
PortfolioData getFallbackPortfolioData() {
  // Raw JSON string containing the fallback portfolio data
  const String fallbackJson = portfolioData;

  try {
    // Parse the JSON string and convert it to a PortfolioData object
    return PortfolioData.fromRawJson(jsonDecode(fallbackJson));
  } catch (e) {
    log('Error parsing fallback JSON: $e');
    // If parsing fails, return a minimal portfolio data object to prevent a crash
    return PortfolioData(
      name: "Jayesh Ghadge",
      contact: Contact(
        email: "jayghadge111@gmail.com",
        mobile: ["9970900787"],
      ),
      summary: "Flutter Developer",
    );
  }
}
