import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';
import '../widgets/custom_text.dart';

class ContactSection extends StatelessWidget {
  final PortfolioData portfolioData;

  const ContactSection({
    super.key,
    required this.portfolioData,
  });

  @override
  Widget build(BuildContext context) {
    final Contact? contact = portfolioData.contact;
    final String? email = contact?.email;
    var size = MediaQuery.of(context).size;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          // About me title
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CustomText(
                text: "04.",
                textsize: 20.0,
                color: Color(0xff61F9D5),
                fontWeight: FontWeight.w700,
              ),
              const SizedBox(width: 12.0),
              const CustomText(
                text: " What's Next?",
                textsize: 26.0,
                color: Color(0xffCCD6F6),
                fontWeight: FontWeight.w700,
              ),
              SizedBox(width: size.width * 0.01),
              Container(
                width: size.width / 4,
                height: 1.10,
                color: const Color(0xff303C55),
              ),
            ],
          ),
          const SizedBox(height: 30.0),
          const Text(
            "Get In Touch",
            style: TextStyle(
              color: Color(0xffCCD6F6),
              fontSize: 35.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          SizedBox(
            width: 500,
            child: const Text(
              "I'm open to new opportunities. If you have a question or simply want to connect, don't hesitate to reach out!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff8892B0),
                fontSize: 16.0,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 32.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SizedBox(width: 15),
              IconButton(
                icon: Icon(FontAwesomeIcons.phone),
                color: Color(0xff8892B0),
                iconSize: 25.0,
                onPressed: () async {
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
                },
              ),
              SizedBox(width: 15),
              IconButton(
                icon: Icon(FontAwesomeIcons.envelope),
                color: Color(0xff8892B0),
                iconSize: 25.0,
                onPressed: () async {
                  Clipboard.setData(
                      ClipboardData(text: email ?? 'jayghage111@gmail.com'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Email address copied!')),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
