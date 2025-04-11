import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/method.dart';
import '../models/portfolio_data.dart';

class SocialLinks extends StatelessWidget {
  final PortfolioData portfolioData;

  const SocialLinks({
    super.key,
    required this.portfolioData,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final Method method = Method();

    // Get contact info from portfolio data
    final Contact? contact = portfolioData.contact;
    final String? linkedinUrl = contact?.linkedin;
    final String? email = contact?.email;
    final List<String>? phones = contact?.mobile;
    final String? phone =
        phones != null && phones.isNotEmpty ? phones.first : null;

    return SizedBox(
      width: size.width * 0.09,
      height: size.height - 82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.github),
            color: Colors.grey,
            iconSize: 20,
            onPressed: () =>
                method.launchURL("https://github.com/jayghadge111"),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: const FaIcon(FontAwesomeIcons.linkedin),
            color: Colors.grey,
            iconSize: 20,
            onPressed: () => method.launchURL(
                linkedinUrl ?? "https://www.linkedin.com/in/jayesh-ghadge/"),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: Icon(FontAwesomeIcons.whatsapp),
            color: const Color(0xff8892B0),
            iconSize: 25.0,
            onPressed: () => launchUrl(
              Uri.parse(
                  "https://wa.me/919970900787?text=${Uri.encodeComponent('Hi Jayesh, I saw your portfolio!')}"),
              mode: LaunchMode.externalApplication,
            ),
          ),
          SizedBox(height: 10),
          IconButton(
              icon: const Icon(FontAwesomeIcons.phone),
              color: Colors.grey,
              iconSize: 20,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: '+919970900787'));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Phone Number copied!')),
                );
                Future.delayed(Duration(seconds: 2)).then((value) async {
                  final Uri uri = Uri(scheme: 'tel', path: '+919970900787');
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Cannot launch dialer')),
                    );
                  }
                });
              }),
          SizedBox(height: 10),
          IconButton(
            icon: const Icon(FontAwesomeIcons.envelope),
            color: Colors.grey,
            iconSize: 20,
            onPressed: () async {
              Clipboard.setData(
                  ClipboardData(text: email ?? 'jayghage111@gmail.com'));
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Email address copied!')),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16.0),
            child: Container(
              height: size.height * 0.25,
              width: 1,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
