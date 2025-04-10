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

  Widget skillItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.skip_next,
            color: const Color(0xff64FFDA).withOpacity(0.6), size: 14.0),
        SizedBox(width: MediaQuery.of(context).size.width * 0.005),
        Flexible(
          child: Text(
            text,
            style: const TextStyle(
              color: Color(0xff717C99),
              letterSpacing: 1.75,
              fontSize: 13,
            ),
          ),
        ),
      ],
    );
  }

  Widget skillCategory(BuildContext context, String title, List<String> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xffCCD6F6),
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        ...items.map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: skillItem(context, e),
            )),
        const SizedBox(height: 14),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var size = MediaQuery.of(context).size;
    final skills = portfolioData.skills;

    // Build skill category widgets dynamically
    final allSkillSections = <Widget>[];

    if (skills?.mobileDevelopment != null) {
      allSkillSections.add(skillCategory(
          context, "Mobile Development", skills!.mobileDevelopment!));
    }
    if (skills?.stateManagement != null) {
      allSkillSections.add(
          skillCategory(context, "State Management", skills!.stateManagement!));
    }
    if (skills?.architecture != null) {
      allSkillSections
          .add(skillCategory(context, "Architecture", skills!.architecture!));
    }
    if (skills?.tools != null) {
      allSkillSections.add(skillCategory(context, "Tools", skills!.tools!));
    }
    if (skills?.backendIntegration != null) {
      allSkillSections.add(skillCategory(
          context, "Backend Integration", skills!.backendIntegration!));
    }
    if (skills?.security != null) {
      allSkillSections
          .add(skillCategory(context, "Security", skills!.security!));
    }
    if (skills?.database != null) {
      allSkillSections
          .add(skillCategory(context, "Database", skills!.database!));
    }

    if (skills?.testing != null) {
      allSkillSections.add(skillCategory(context, "Testing", skills!.testing!));
    }

    // Split skills into two columns
    final midpoint = (allSkillSections.length / 2).ceil();
    final leftColumn = allSkillSections.take(midpoint).toList();
    final rightColumn = allSkillSections.skip(midpoint).toList();

    return SizedBox(
      height: size.height - 100,
      width: size.width - 100,
      child: Row(
        children: [
          // Left side: About Me
          SizedBox(
            width: size.width / 2 - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
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
                const SizedBox(height: 40),

                // Description
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
                          "At the forefront of Kaar Tech's mobile app development, our team strategically leverages Flutter to create cutting-edge solutions for Aramco.\n\n",
                      textsize: 16.0,
                      color: const Color(0xff828DAA),
                      letterSpacing: 0.75,
                    ),
                    SizedBox(
                      height: size.height * 0.1,
                    ),
                    const CustomText(
                      text:
                          "Here’s a snapshot of the tools and technologies I’ve used in recent projects:\n",
                      textsize: 16.0,
                      color: Color(0xff828DAA),
                      letterSpacing: 0.75,
                    ),
                  ],
                ),

                // Two-column skills
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: leftColumn,
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: rightColumn,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),

          // Right side: Profile image
          Expanded(
            child: SizedBox(
              height: size.height / 1.5,
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
                  const CustomImageAnimation(),
                ],
              ),
            ),
          )
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
              image: AssetImage("images/pic1.jpg"),
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
