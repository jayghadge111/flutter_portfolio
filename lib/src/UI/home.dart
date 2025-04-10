import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayesh_flutter/src/UI/home_page.dart';
import 'package:jayesh_flutter/src/UI/mobile_home_page.dart';

import '../firebase_services/remote_config_service.dart';

class Home extends ConsumerWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final portfolioDataAsync = ref.watch(portfolioDataProvider);

    return portfolioDataAsync.when(
      loading: () => const Scaffold(
        backgroundColor: Color(0xff0A192F),
        body: Center(
          child: CircularProgressIndicator(
            color: Color(0xff64FFDA),
          ),
        ),
      ),
      error: (error, stackTrace) {
        // Log the error for debugging
        log('Error in Home: $error');
        log('Stack trace: $stackTrace');

        return Scaffold(
          backgroundColor: const Color(0xff0A192F),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 80),
                const Icon(
                  Icons.error_outline,
                  color: Color(0xff64FFDA),
                  size: 60,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Error loading portfolio data',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Error Details:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    error.toString(),
                    style: const TextStyle(
                      color: Colors.red,
                      fontSize: 14,
                      fontFamily: 'monospace',
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  'Stack Trace:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  width: double.infinity,
                  child: Text(
                    stackTrace.toString(),
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                      fontFamily: 'monospace',
                    ),
                    maxLines: 50,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      ref.invalidate(portfolioDataProvider);
                    },
                    child: const Text('Retry'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
      data: (portfolioData) {
        return LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 1000) {
              return HomePage(portfolioData: portfolioData);
            } else {
              return MobileHomePage(portfolioData: portfolioData);
            }
          },
        );
      },
    );
  }
}
