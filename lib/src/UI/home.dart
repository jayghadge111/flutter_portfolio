import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../firebase_services/remote_config_service.dart';
import 'home_page.dart';
import 'mobile_home_page.dart';

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
      error: (error, stackTrace) => Scaffold(
        backgroundColor: Color(0xff0A192F),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                color: Color(0xff64FFDA),
                size: 60,
              ),
              const SizedBox(height: 16),
              Text(
                'Error loading portfolio data',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(portfolioDataProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
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
