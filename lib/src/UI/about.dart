import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/portfolio_data.dart';
import '../widgets/custom_text.dart';

class About extends ConsumerWidget {
  final PortfolioData portfolioData;

  const About({
    super.key,
    required this.portfolioData,
  });

  Widget technology(BuildContext context, String text) {
    return Row(
      children: [
        Icon(
          Icons.skip_next,
          color: const Color(0xff64FFDA).withOpacity(0.6),
          size: 14.0,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.01),
        Text(
          text,
          style: const TextStyle(
            color: Color(0xff717C99),
            letterSpacing: 1.75,
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;

    // Get skills from portfolioData
    final skills = portfolioData.skills;
    final List<String> firstColumnSkills = [];
    final List<String> secondColumnSkills = [];

    if (skills != null) {
      if (skills.mobileDevelopment != null &&
          skills.mobileDevelopment!.isNotEmpty) {
        firstColumnSkills.addAll(skills.mobileDevelopment!.take(4));
      }
      if (skills.stateManagement != null &&
          skills.stateManagement!.isNotEmpty) {
        secondColumnSkills.addAll(skills.stateManagement!.take(2));
      }
      if (skills.database != null && skills.database!.isNotEmpty) {
        secondColumnSkills.addAll(skills.database!.take(2));
      }
      if (skills.tools != null && skills.tools!.isNotEmpty) {
        firstColumnSkills.add(skills.tools!.first);
        if (skills.tools!.length > 1) {
          secondColumnSkills.add(skills.tools![1]);
        }
      }
    }

    // Fallback skills if none are found
    if (firstColumnSkills.isEmpty) {
      firstColumnSkills
          .addAll(["Dart", "Flutter", "Firebase", "UI/UX (Adobe Xd)"]);
    }
    if (secondColumnSkills.isEmpty) {
      secondColumnSkills.addAll(
          ["Clean Architecture", "MVVM Pattern", "GraphQL", "Android/iOS"]);
    }

    return SizedBox(
      height: size.height,
      width: size.width - 100,
      child: Row(
        children: [
          // About me
          SizedBox(
            height: size.height * 0.9,
            width: size.width / 2 - 100,
            child: Column(
              children: [
                // About me title
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CustomText(
                      text: "01.",
                      textsize: 20.0,
                      color: Color(0xff61F9D5),
                      fontWeight: FontWeight.w700,
                    ),
                    const SizedBox(width: 12.0),
                    const CustomText(
                      text: "About Me",
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
                SizedBox(height: size.height * 0.07),

                // About me description
                Wrap(
                  children: [
                    CustomText(
                      text:
                          "Hello! I'm ${portfolioData.name ?? 'Jayesh'}, a Flutter Platform Expert currently based in ${portfolioData.contact?.currentAddress ?? 'Pune, Maharashtra, India'}.\n\n",
                      textsize: 16.0,
                      color: const Color(0xff828DAA),
                      letterSpacing: 0.75,
                    ),
                    CustomText(
                      text: portfolioData.summary ??
                          "At the forefront of Kaar Tech's mobile app development, our team strategically leverages Flutter to create cutting-edge solutions for Aramco, ensuring seamless performance and robust security. A solid foundation in engineering, augmented by proficiency in POD, Document Object Model (DOM), and Google Maps API, underpins our approach to delivering sophisticated B2B and B2C applications.\n\n",
                      textsize: 16.0,
                      color: const Color(0xff828DAA),
                      letterSpacing: 0.75,
                    ),
                    const CustomText(
                      text:
                          "Here are a few technologies I've been working with recently:\n\n",
                      textsize: 16.0,
                      color: Color(0xff828DAA),
                      letterSpacing: 0.75,
                    ),
                  ],
                ),

                SizedBox(
                  height: size.height * 0.15,
                  width: size.width,
                  child: Wrap(
                    children: [
                      SizedBox(
                        width: size.width * 0.20,
                        height: size.height * 0.15,
                        child: Column(
                          children: firstColumnSkills
                              .map((skill) => technology(context, skill))
                              .toList(),
                        ),
                      ),
                      SizedBox(
                        width: size.width * 0.15,
                        height: size.height * 0.15,
                        child: Column(
                          children: secondColumnSkills
                              .map((skill) => technology(context, skill))
                              .toList(),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),

          // Profile Image
          Expanded(
            child: SizedBox(
              height: size.height / 1.5,
              width: size.width / 2 - 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: size.height * 0.12,
                    left: size.width * 0.120,
                    child: Card(
                      color: const Color(0xff61F9D5),
                      child: Container(
                        margin: const EdgeInsets.all(2.75),
                        height: size.height / 2,
                        width: size.width / 5,
                        color: const Color(0xff0A192F),
                      ),
                    ),
                  ),
                  const CustomImageAnimation()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomImageAnimation extends StatefulWidget {
  const CustomImageAnimation({super.key});

  @override
  CustomImageAnimationState createState() => CustomImageAnimationState();
}

class CustomImageAnimationState extends State<CustomImageAnimation> {
  Color customImageColor = const Color(0xff61F9D5).withOpacity(0.5);
  int _enterCounter = 0;
  int _exitCounter = 0;
  double x = 0.0;
  double y = 0.0;

  void _incrementEnter(PointerEvent details) {
    setState(() {
      _enterCounter++;
    });
  }

  void _incrementExit(PointerEvent details) {
    setState(() {
      customImageColor = const Color(0xff61F9D5).withOpacity(0.5);
      _exitCounter++;
    });
  }

  void _updateLocation(PointerEvent details) {
    setState(() {
      customImageColor = Colors.transparent;
      x = details.position.dx;
      y = details.position.dy;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return MouseRegion(
      onEnter: _incrementEnter,
      onHover: _updateLocation,
      onExit: _incrementExit,
      child: Stack(
        children: [
          Container(
            height: size.height / 2,
            width: size.width / 5,
            color: Colors.black54,
            child: const Image(
              fit: BoxFit.cover,
              image: AssetImage("images/pic1.png"),
            ),
          ),
          Container(
            height: size.height / 2,
            width: size.width / 5,
            color: customImageColor,
          ),
        ],
      ),
    );
  }
}
