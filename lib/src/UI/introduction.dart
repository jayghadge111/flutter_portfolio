import 'package:flutter/material.dart';

import '../models/portfolio_data.dart';
import '../widgets/custom_text.dart';

class IntroductionSection extends StatelessWidget {
  final PortfolioData portfolioData;

  const IntroductionSection({
    super.key,
    required this.portfolioData,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final String? name = portfolioData.name;
    final String? headline = portfolioData.headline;
    final String? shortSummary = portfolioData.shortSummary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * .06),
        // const CustomText(
        //   text: "Hi, my name is",
        //   textsize: 18.0,
        //   color: Color(0xff41FBDA),
        //   letterSpacing: 3.0,
        // ),
        const SizedBox(height: 6.0),
        CustomText(
          text: name ?? "",
          textsize: 50.0,
          color: const Color(0xffCCD6F6),
          fontWeight: FontWeight.w900,
        ),
        const SizedBox(height: 4.0),
        CustomText(
          text: headline ?? 'Senior Flutter Developer',

          // portfolioData.domains?.isNotEmpty == true
          //     ? portfolioData.domains!.first
          //     : "",
          textsize: 30.0,
          color: const Color(0xffCCD6F6).withOpacity(0.6),
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: size.height * .035),
        Wrap(
          children: [
            Text(
              shortSummary ?? "",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                letterSpacing: 2.75,
                wordSpacing: 0.75,
              ),
            )
          ],
        ),
        SizedBox(height: size.height * 0.06),
      ],
    );
  }
}
