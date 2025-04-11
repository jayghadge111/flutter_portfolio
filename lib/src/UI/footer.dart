import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jayesh_flutter/src/models/portfolio_data.dart';
import 'package:url_launcher/url_launcher.dart';

class Footer extends StatelessWidget {
  final PortfolioData portfolioData;

  const Footer({
    super.key,
    required this.portfolioData,
  });

  @override
  Widget build(BuildContext context) {
    final Contact? contact = portfolioData.contact;
    final String? linkedinUrl = contact?.linkedin;
    final String? email = contact?.email;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Column(
        children: [
          // Mobile social links (only shown on mobile)
          MediaQuery.of(context).size.width < 768
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon(FontAwesomeIcons.github,
                        "https://github.com/jayghadge111"),
                    const SizedBox(width: 24.0),
                    _buildSocialIcon(
                        FontAwesomeIcons.linkedin,
                        linkedinUrl ??
                            "https://www.linkedin.com/in/jayesh-ghadge/"),
                    const SizedBox(width: 24.0),
                    _buildSocialIcon(Icons.mail,
                        "mailto:${email ?? 'jayghage111@gmail.com'}"),
                  ],
                )
              : const SizedBox(),
          const SizedBox(height: 16.0),
          const Text(
            "Designed & Built by Jayesh Ghadge 💙 Flutter",
            style: TextStyle(
              color: Colors.white38,
              fontSize: 16.0,
              fontFamily: 'SF Mono',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon),
      color: const Color(0xff8892B0),
      iconSize: 18.0,
      onPressed: () => launchUrl(Uri.parse(url)),
    );
  }
}
