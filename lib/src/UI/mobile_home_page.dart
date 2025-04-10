import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/method.dart';
import '../models/portfolio_data.dart';
import '../widgets/custom_text.dart';

class MobileHomePage extends ConsumerStatefulWidget {
  final PortfolioData portfolioData;

  const MobileHomePage({super.key, required this.portfolioData});

  @override
  MobileHomePageState createState() => MobileHomePageState();
}

class MobileHomePageState extends ConsumerState<MobileHomePage> {
  late PortfolioData portfolioData;
  final Method method = Method();

  @override
  void initState() {
    super.initState();
    portfolioData = widget.portfolioData;
  }

  Widget technology(BuildContext context, String text) {
    return Row(
      children: [
        Icon(
          Icons.skip_next,
          color: const Color(0xff64FFDA).withOpacity(0.6),
          size: 14.0,
        ),
        SizedBox(width: MediaQuery.of(context).size.width * 0.04),
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
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xff0A192F),
      drawer: _buildDrawer(),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Introduction Section
              _buildIntroSection(size),

              // About Section
              SizedBox(height: size.height * 0.08),
              _buildAboutSection(size),

              // Experience Section
              SizedBox(height: size.height * 0.08),
              _buildExperienceSection(),

              // Projects Section
              SizedBox(height: size.height * 0.08),
              _buildProjectsSection(size),

              // Contact Section
              SizedBox(height: size.height * 0.08),
              _buildContactSection(size),

              // Footer
              _buildFooter(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer() {
    final Contact? contact = portfolioData.contact;
    final String? email = contact?.email;

    return Drawer(
      backgroundColor: Colors.white70,
      elevation: 6.0,
      child: Container(
        color: const Color(0xff0A192F),
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
                decoration: const BoxDecoration(color: Color(0xff112240)),
                currentAccountPicture: const CircleAvatar(
                  child: Icon(Icons.sort, color: Colors.white),
                ),
                accountName: Text(portfolioData.name ?? "Jayesh Ghadge"),
                accountEmail: Text(email ?? "jayghage111@gmail.com")),
            const ListTile(
              title: Text(
                "About",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.person, color: Color(0xff64FFDA)),
            ),
            const ListTile(
              title: Text(
                "Experience",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.work, color: Color(0xff64FFDA)),
            ),
            const ListTile(
              title: Text(
                "Projects",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.code, color: Color(0xff64FFDA)),
            ),
            const ListTile(
              title: Text(
                "Contact",
                style: TextStyle(color: Colors.white),
              ),
              leading: Icon(Icons.contact_mail, color: Color(0xff64FFDA)),
            ),
            const Divider(color: Colors.grey),
            ListTile(
              title: const Text(
                "Resume",
                style: TextStyle(color: Colors.white),
              ),
              leading: const Icon(Icons.description, color: Color(0xff64FFDA)),
              onTap: () => method.downloadResumeFromAssets(),
            ),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xff0A192F),
      elevation: 0.0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const FaIcon(
            FontAwesomeIcons.listUl,
            color: Colors.white70,
            size: 20.0,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
    );
  }

  Widget _buildIntroSection(Size size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * 0.04),
        const CustomText(
          text: "Hi, my name is",
          textsize: 16.0,
          color: Color(0xff41FBDA),
          letterSpacing: 3.0,
        ),
        SizedBox(height: size.height * 0.01),
        CustomText(
          text: portfolioData.name ?? "",
          textsize: 30.0,
          color: const Color(0xffCCD6F6),
          fontWeight: FontWeight.w900,
        ),
        SizedBox(height: size.height * 0.04),
        CustomText(
          text: portfolioData.domains?.isNotEmpty == true
              ? portfolioData.domains!.first
              : "",
          textsize: 40.0,
          color: const Color(0xffCCD6F6).withOpacity(0.6),
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: size.height * 0.04),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Wrap(
            children: [
              Text(
                portfolioData.summary ?? "",
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0,
                  letterSpacing: 2.75,
                  wordSpacing: 0.75,
                ),
              )
            ],
          ),
        ),
        SizedBox(height: size.height * 0.06),
        _buildGetInTouchButton(),
      ],
    );
  }

  Widget _buildGetInTouchButton() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
      color: const Color(0xff64FFDA),
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.all(0.75),
        height: 50.0,
        width: 140.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.0),
          color: const Color(0xff0A192F),
        ),
        child: MaterialButton(
          onPressed: () {
            final Contact? contact = portfolioData.contact;
            final String? email = contact?.email;
            method.launchEmail(email: email ?? "jayghage111@gmail.com");
          },
          hoverColor: Colors.green,
          child: const Text(
            "Get In Touch",
            style: TextStyle(
              color: Color(0xff64FFDA),
              letterSpacing: 2.5,
              wordSpacing: 1.0,
              fontSize: 14.0,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutSection(Size size) {
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

    // Skip this section if no skills data is available
    if (firstColumnSkills.isEmpty && secondColumnSkills.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        // About me title
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CustomText(
              text: "01.",
              textsize: 20.0,
              color: Color(0xff61F9D5),
              fontWeight: FontWeight.w700,
            ),
            SizedBox(width: 12.0),
            CustomText(
              text: "About Me",
              textsize: 26.0,
              color: Color(0xffCCD6F6),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.07),
        Wrap(
          children: [
            CustomText(
              text:
                  "Hello! I'm ${portfolioData.name ?? ''}, a Flutter Platform Expert based in ${portfolioData.contact?.currentAddress ?? ''}.\n\n",
              textsize: 16.0,
              color: const Color(0xff828DAA),
              letterSpacing: 0.75,
            ),
            CustomText(
              text: portfolioData.summary ?? "",
              textsize: 16.0,
              color: const Color(0xff828DAA),
              letterSpacing: 0.75,
            ),
            const CustomText(
              text:
                  "\n\nHere are the technologies I've been working with recently:",
              textsize: 16.0,
              color: Color(0xff828DAA),
              letterSpacing: 0.75,
            ),
          ],
        ),
        SizedBox(height: size.height * 0.06),
        Container(
          width: size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: firstColumnSkills
                    .map((skill) => technology(context, skill))
                    .toList(),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: secondColumnSkills
                    .map((skill) => technology(context, skill))
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceSection() {
    // Skip this section if no experience data is available
    if (portfolioData.experience == null || portfolioData.experience!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CustomText(
              text: "02.",
              textsize: 20.0,
              color: Color(0xff61F9D5),
              fontWeight: FontWeight.w700,
            ),
            SizedBox(width: 12.0),
            CustomText(
              text: "Where I've Worked",
              textsize: 26.0,
              color: Color(0xffCCD6F6),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        MobileWork(portfolioData: portfolioData),
      ],
    );
  }

  Widget _buildProjectsSection(Size size) {
    // Skip this section if no projects data is available
    if (portfolioData.projects == null || portfolioData.projects!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            CustomText(
              text: "03.",
              textsize: 20.0,
              color: Color(0xff61F9D5),
              fontWeight: FontWeight.w700,
            ),
            SizedBox(width: 12.0),
            CustomText(
              text: "Some Things I've Built",
              textsize: 26.0,
              color: Color(0xffCCD6F6),
              fontWeight: FontWeight.w700,
            ),
          ],
        ),
        const SizedBox(height: 40.0),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: portfolioData.projects!.length.clamp(0, 3),
          itemBuilder: (context, index) {
            final project = portfolioData.projects![index];
            // Try to get a primary link for the project
            String projectLink = "#";
            if (project.links?.web != null) {
              projectLink = project.links!.web!;
            } else if (project.links?.playStore != null) {
              projectLink = project.links!.playStore!;
            } else if (project.link?.playStore != null) {
              projectLink = project.link!.playStore!;
            }

            return MobileProject(
              title: project.name ?? "",
              description: project.description ?? "",
              imageUrl:
                  "images/${project.name?.replaceAll(' ', '_').toLowerCase() ?? 'project'}.jpg",
              onTap: () => launchUrl(Uri.parse(projectLink)),
            );
          },
        ),
      ],
    );
  }

  Widget _buildContactSection(Size size) {
    final Contact? contact = portfolioData.contact;
    final String? email = contact?.email;

    return Column(
      children: [
        const CustomText(
          text: "04. What's Next?",
          textsize: 16.0,
          color: Color(0xff41FBDA),
          letterSpacing: 3.0,
        ),
        const SizedBox(height: 16.0),
        const CustomText(
          text: "Get In Touch",
          textsize: 42.0,
          color: Colors.white,
          letterSpacing: 3.0,
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: size.height * 0.04),
        const Wrap(
          alignment: WrapAlignment.center,
          children: [
            Text(
              "I'm currently looking for new opportunities. Whether you have a question or just want to say hi, I'll try my best to get back to you!",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white38,
                letterSpacing: 0.75,
                fontSize: 16.0,
              ),
            ),
          ],
        ),
        SizedBox(height: size.height * 0.07),
        Card(
          elevation: 4.0,
          color: const Color(0xff64FFDA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
          ),
          child: Container(
            margin: const EdgeInsets.all(0.85),
            height: size.height * 0.10,
            width: size.width * 0.30,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xff0A192F),
              borderRadius: BorderRadius.circular(6.0),
            ),
            child: TextButton(
              onPressed: () {
                method.launchEmail(email: email ?? "jayghage111@gmail.com");
              },
              child: const Text(
                "Say Hello",
                style: TextStyle(
                  color: Color(0xff64FFDA),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    final Contact? contact = portfolioData.contact;
    final String? linkedinUrl = contact?.linkedin;
    final String? email = contact?.email;

    return Column(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.07),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.github,
                color: Colors.white,
                size: 15.0,
              ),
              onPressed: () =>
                  method.launchURL("https://github.com/jayghadge111"),
            ),
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.linkedin,
                color: Colors.white,
                size: 15.0,
              ),
              onPressed: () => method.launchURL(
                  linkedinUrl ?? "https://www.linkedin.com/in/jayesh-ghadge/"),
            ),
            IconButton(
              icon: const Icon(
                Icons.mail,
                color: Colors.white,
                size: 15.0,
              ),
              onPressed: () =>
                  method.launchEmail(email: email ?? "jayghage111@gmail.com"),
            )
          ],
        ),
        SizedBox(height: MediaQuery.of(context).size.height * 0.07),
        Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height / 6,
          width: MediaQuery.of(context).size.width,
          child: const Text(
            "Designed & Built by Jayesh Ghadge 💙 Flutter",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white38,
              letterSpacing: 1.75,
              fontSize: 14.0,
            ),
          ),
        ),
      ],
    );
  }
}

// Mobile Work Experience Component for responsive design
class MobileWork extends StatefulWidget {
  final PortfolioData portfolioData;

  const MobileWork({
    super.key,
    required this.portfolioData,
  });

  @override
  _MobileWorkState createState() => _MobileWorkState();
}

class _MobileWorkState extends State<MobileWork> {
  final Method method = Method();
  late List<String> companies;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    // Initialize companies from portfolio data
    companies = [];
    if (widget.portfolioData.experience != null &&
        widget.portfolioData.experience!.isNotEmpty) {
      for (var exp in widget.portfolioData.experience!) {
        if (exp.company != null && exp.company!.isNotEmpty) {
          companies.add(exp.company!);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (companies.isEmpty) {
      return const SizedBox
          .shrink(); // If no companies data, don't show this section
    }

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: companies.map((company) {
              int index = companies.indexOf(company);
              return Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 10.0),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: selectedIndex == index
                          ? const Color(0xff64FFDA)
                          : Colors.transparent,
                      width: 2.0,
                    ),
                  ),
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: Text(
                    company,
                    style: TextStyle(
                      color: selectedIndex == index
                          ? const Color(0xff64FFDA)
                          : Colors.white,
                      fontSize: 14.0,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20.0),
        _buildWorkDetails(selectedIndex),
      ],
    );
  }

  Widget _buildWorkDetails(int index) {
    if (widget.portfolioData.experience != null &&
        widget.portfolioData.experience!.length > index) {
      // Use data from portfolio
      final exp = widget.portfolioData.experience![index];
      return _buildWorkExperience(
        role: exp.title ?? "",
        company: exp.company ?? "",
        duration: exp.duration ?? "",
        points: exp.responsibilities ?? [],
      );
    }

    // If no experience data for this index, return empty container
    return Container();
  }

  Widget _buildWorkExperience({
    required String role,
    required String company,
    required String duration,
    required List<String> points,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            role,
            style: const TextStyle(
              color: Color(0xffCCD6F6),
              fontSize: 20.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            company,
            style: const TextStyle(
              color: Color(0xff64FFDA),
              fontSize: 13.0,
            ),
          ),
          const SizedBox(height: 5.0),
          Text(
            duration,
            style: const TextStyle(
              color: Color(0xff8892B0),
              fontSize: 13.0,
            ),
          ),
          const SizedBox(height: 15.0),
          Column(
            children: points.map((point) => _buildBulletPoint(point)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "▹",
            style: TextStyle(
              color: Color(0xff64FFDA),
              fontSize: 14.0,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                color: Color(0xff8892B0),
                fontSize: 14.0,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Mobile Project Component
class MobileProject extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final VoidCallback onTap;

  const MobileProject({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: MediaQuery.of(context).size.height * 0.36,
        margin: const EdgeInsets.symmetric(vertical: 16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(imageUrl),
                    onError: (exception, stackTrace) {
                      // Handle image loading error
                      print('Error loading image: $exception');
                    },
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(12.0),
              decoration: const BoxDecoration(
                color: Color(0xff112240),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(8.0),
                  bottomRight: Radius.circular(8.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Featured Project",
                    style: TextStyle(
                      color: Color(0xff64FFDA),
                      fontSize: 12.0,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xff8892B0),
                      fontSize: 14.0,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
