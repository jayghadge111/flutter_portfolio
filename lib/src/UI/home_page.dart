import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/method.dart';
import '../models/portfolio_data.dart';
import '../widgets/app_bar_title.dart';
import '../widgets/custom_text.dart';
import '../widgets/main_title.dart';
import 'about.dart';

class HomePage extends ConsumerStatefulWidget {
  final PortfolioData portfolioData;

  const HomePage({super.key, required this.portfolioData});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends ConsumerState<HomePage> {
  late PortfolioData portfolioData;
  final Method method = Method();
  final AutoScrollController autoScrollController = AutoScrollController();
  final scrollDirection = Axis.vertical;

  bool isExpanded = true;

  bool get _isAppBarExpanded {
    return autoScrollController.hasClients &&
        autoScrollController.offset > (160 - kToolbarHeight);
  }

  @override
  void initState() {
    super.initState();
    portfolioData = widget.portfolioData;
  }

  @override
  void dispose() {
    autoScrollController.dispose();
    super.dispose();
  }

  Future<void> downloadFileFromAssets() async {
    try {
      final ByteData bytes =
          await rootBundle.load('images/jayesh_ghadge_resume.pdf');
      final Uint8List pdfBytes = bytes.buffer.asUint8List();

      log('PDF size in bytes: ${pdfBytes.length}');
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final String downloadUrl = html.Url.createObjectUrlFromBlob(blob);

      final html.AnchorElement anchor = html.AnchorElement()
        ..href = downloadUrl
        ..style.display = 'none'
        ..download = 'jayesh_ghadge_cv.pdf';

      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(downloadUrl);
    } catch (e) {
      log('Error downloading file: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xff0A192F),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        primary: true,
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            // Navigation Bar
            SizedBox(
              height: size.height * 0.14,
              width: size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    Image.asset(
                      'images/flutter_portfolio_logo.png',
                      height: size.height * 0.30,
                    ),

                    const Spacer(),
                    Expanded(
                      child: DefaultTabController(
                        length: 4,
                        child: TabBar(
                          indicatorColor: Colors.transparent,
                          onTap: (index) async {
                            await autoScrollController.scrollToIndex(index,
                                preferPosition: AutoScrollPosition.begin);
                          },
                          tabs: const [
                            Tab(child: AppBarTitle(text: 'About')),
                            Tab(child: AppBarTitle(text: 'Experience')),
                            Tab(child: AppBarTitle(text: 'Projects')),
                            Tab(child: AppBarTitle(text: 'Contact')),
                          ],
                        ),
                      ),
                    ),
                    // Resume Button
                    const SizedBox(width: 20),
                    Card(
                      elevation: 4.0,
                      color: const Color(0xff64FFDA),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Container(
                        margin: const EdgeInsets.all(0.85),
                        height: size.height * 0.05,
                        width: size.height * 0.15,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6.0),
                        ),
                        child: TextButton(
                          onPressed: downloadFileFromAssets,
                          child: const Text(
                            "Download Resume",
                            style: TextStyle(color: Color(0xff0A192F)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body Content
            Row(
              children: [
                // Left Social Icons
                SocialLinks(portfolioData: portfolioData),

                // Main Content
                Expanded(
                  child: MainContent(
                    autoScrollController: autoScrollController,
                    portfolioData: portfolioData,
                  ),
                ),

                // Right Email
                EmailSection(email: portfolioData.contact?.email ?? ''),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

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
            icon: const Icon(FontAwesomeIcons.phone),
            color: Colors.grey,
            iconSize: 20,
            onPressed: () => phone != null
                ? method.launchCaller(phoneNumber: phone)
                : method.launchCaller(),
          ),
          SizedBox(height: 10),
          IconButton(
            icon: const Icon(FontAwesomeIcons.envelope),
            color: Colors.grey,
            iconSize: 20,
            onPressed: () => email != null
                ? method.launchEmail(email: email)
                : method.launchEmail(),
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

class MainContent extends StatelessWidget {
  final AutoScrollController autoScrollController;
  final PortfolioData portfolioData;

  const MainContent({
    super.key,
    required this.autoScrollController,
    required this.portfolioData,
  });

  Widget _wrapScrollTag({required int index, required Widget child}) {
    return AutoScrollTag(
      key: ValueKey(index),
      controller: autoScrollController,
      index: index,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height - 82,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: CustomScrollView(
          controller: autoScrollController,
          slivers: <Widget>[
            SliverList(
              delegate: SliverChildListDelegate([
                // Introduction
                IntroductionSection(portfolioData: portfolioData),

                // About
                _wrapScrollTag(
                    index: 0, child: About(portfolioData: portfolioData)),

                // Experience
                _wrapScrollTag(
                    index: 1, child: Work(portfolioData: portfolioData)),

                // Projects
                _wrapScrollTag(
                    index: 2,
                    child: ProjectsSection(portfolioData: portfolioData)),

                // Contact
                _wrapScrollTag(
                  index: 3,
                  child: ContactSection(portfolioData: portfolioData),
                ),
                Footer(portfolioData: portfolioData)
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

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
    final String? summary = portfolioData.summary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: size.height * .06),
        const CustomText(
          text: "Hi, my name is",
          textsize: 16.0,
          color: Color(0xff41FBDA),
          letterSpacing: 3.0,
        ),
        const SizedBox(height: 6.0),
        CustomText(
          text: name ?? "",
          textsize: 68.0,
          color: const Color(0xffCCD6F6),
          fontWeight: FontWeight.w900,
        ),
        const SizedBox(height: 4.0),
        CustomText(
          text: 'Senior Flutter Developer',

          // portfolioData.domains?.isNotEmpty == true
          //     ? portfolioData.domains!.first
          //     : "",
          textsize: 56.0,
          color: const Color(0xffCCD6F6).withOpacity(0.6),
          fontWeight: FontWeight.w700,
        ),
        SizedBox(height: size.height * .04),
        Wrap(
          children: [
            Text(
              summary ?? "",
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 16.0,
                letterSpacing: 2.75,
                wordSpacing: 0.75,
              ),
            )
          ],
        ),
        SizedBox(height: size.height * 0.075),
      ],
    );
  }
}

class EmailSection extends StatelessWidget {
  final String email;

  const EmailSection({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width * 0.07,
      height: size.height - 82,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          RotatedBox(
            quarterTurns: 45,
            child: Text(
              email,
              style: TextStyle(
                color: Colors.grey,
                letterSpacing: 4.0,
                fontWeight: FontWeight.w700,
              ),
            ),
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

class Work extends ConsumerStatefulWidget {
  final PortfolioData portfolioData;

  const Work({
    super.key,
    required this.portfolioData,
  });

  @override
  _WorkState createState() => _WorkState();
}

class _WorkState extends ConsumerState<Work> {
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
          .shrink(); // If no experience data, don't show this section
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MainTitle(number: "02.", text: "Where I've Worked"),
          const SizedBox(height: 40.0),
          Row(
            children: [
              // Company Tabs
              SizedBox(
                width: 200.0,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: companies.length,
                  itemBuilder: (context, index) {
                    return CompanyTab(
                      company: companies[index],
                      isSelected: selectedIndex == index,
                      onTap: () {
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(width: 32.0),
              // Experience Details
              Expanded(
                child: _buildExperienceDetails(selectedIndex),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExperienceDetails(int index) {
    if (widget.portfolioData.experience != null &&
        widget.portfolioData.experience!.length > index) {
      // Use data from portfolio
      final exp = widget.portfolioData.experience![index];
      return ExperienceCard(
        title: exp.title ?? "",
        company: exp.company ?? "",
        duration: exp.duration ?? "",
        points: exp.responsibilities ?? [],
      );
    }

    // If no experience data for this index, return empty container
    return Container();
  }
}

class CompanyTab extends StatelessWidget {
  final String company;
  final bool isSelected;
  final VoidCallback onTap;

  const CompanyTab({
    super.key,
    required this.company,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: isSelected ? const Color(0xff64FFDA) : Colors.transparent,
              width: 2.0,
            ),
          ),
          color: isSelected ? const Color(0xff112240) : Colors.transparent,
        ),
        child: Text(
          company,
          style: TextStyle(
            color:
                isSelected ? const Color(0xff64FFDA) : const Color(0xff8892B0),
            fontSize: 13.0,
          ),
        ),
      ),
    );
  }
}

class ExperienceCard extends StatelessWidget {
  final String title;
  final String company;
  final String duration;
  final List<String> points;

  const ExperienceCard({
    super.key,
    required this.title,
    required this.company,
    required this.duration,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Color(0xffCCD6F6),
            fontSize: 20.0,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          company,
          style: const TextStyle(
            color: Color(0xff64FFDA),
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 4.0),
        Text(
          duration,
          style: const TextStyle(
            color: Color(0xff8892B0),
            fontSize: 14.0,
          ),
        ),
        const SizedBox(height: 16.0),
        Column(
          children: points.map((point) => _buildBulletPoint(point)).toList(),
        ),
      ],
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

class ProjectsSection extends ConsumerWidget {
  final PortfolioData portfolioData;

  const ProjectsSection({
    super.key,
    required this.portfolioData,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Early return if no projects data
    if (portfolioData.projects == null || portfolioData.projects!.isEmpty) {
      return const SizedBox.shrink();
    }

    final projects = portfolioData.projects!;
    // Use all projects as featured projects initially
    final featuredProjects = projects.take(3).toList();

    // Other projects are anything beyond the first 3
    final otherProjects =
        projects.length > 3 ? projects.sublist(3) : <Projects>[];

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MainTitle(number: "03.", text: "Some Things I've Built"),
          const SizedBox(height: 40.0),

          // Featured Projects
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: featuredProjects.length,
            itemBuilder: (context, index) {
              final project = featuredProjects[index];
              return FeaturedProject(
                title: project.name ?? "",
                description: project.description ?? "",
                imageUrl:
                    "images/${project.name?.replaceAll(' ', '_').toLowerCase() ?? 'project'}.jpg",
                tags: _getProjectTags(project),
                links: _getProjectLinks(project),
              );
            },
          ),

          // Only show "Other Projects" section if there are any
          if (otherProjects.isNotEmpty) ...[
            const SizedBox(height: 48.0),
            const Text(
              "Other Noteworthy Projects",
              style: TextStyle(
                color: Color(0xffCCD6F6),
                fontSize: 24.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 24.0),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                childAspectRatio: 1.0,
              ),
              itemCount: otherProjects.length,
              itemBuilder: (context, index) {
                final project = otherProjects[index];
                return ProjectCard(
                  title: project.name ?? "",
                  description: project.description ?? "",
                  tags: _getProjectTags(project),
                  link: _getPrimaryProjectLink(project),
                );
              },
            ),
          ],
        ],
      ),
    );
  }

  // Extract tags from project data
  List<String> _getProjectTags(Projects project) {
    final List<String> tags = [];
    if (project.platform != null && project.platform!.isNotEmpty) {
      tags.add(project.platform!);
    }
    if (project.status != null && project.status!.isNotEmpty) {
      tags.add(project.status!);
    }

    // Add some generic tags if we don't have enough
    if (tags.isEmpty) {
      tags.addAll(["Flutter", "Dart"]);
    }

    return tags;
  }

  // Extract links from project data
  Map<String, String> _getProjectLinks(Projects project) {
    final Map<String, String> links = {};

    // Check for links in Links object first
    if (project.links != null) {
      if (project.links!.playStore != null &&
          project.links!.playStore!.isNotEmpty) {
        links["Play Store"] = project.links!.playStore!;
      }
      if (project.links!.appStore != null &&
          project.links!.appStore!.isNotEmpty) {
        links["App Store"] = project.links!.appStore!;
      }
      if (project.links!.indusAppStore != null &&
          project.links!.indusAppStore!.isNotEmpty) {
        links["Indus App Store"] = project.links!.indusAppStore!;
      }
      if (project.links!.web != null && project.links!.web!.isNotEmpty) {
        links["Web"] = project.links!.web!;
      }
    }
    // Then check for links in Link object
    else if (project.link != null) {
      if (project.link!.playStore != null &&
          project.link!.playStore!.isNotEmpty) {
        links["Play Store"] = project.link!.playStore!;
      }
      if (project.link!.appStore != null &&
          project.link!.appStore!.isNotEmpty) {
        links["App Store"] = project.link!.appStore!;
      }
    }

    return links;
  }

  // Get the primary link for a project
  String _getPrimaryProjectLink(Projects project) {
    // Try to get a link in this priority order: web > playStore > appStore > indusAppStore
    if (project.links != null) {
      if (project.links!.web != null && project.links!.web!.isNotEmpty) {
        return project.links!.web!;
      }
      if (project.links!.playStore != null &&
          project.links!.playStore!.isNotEmpty) {
        return project.links!.playStore!;
      }
      if (project.links!.appStore != null &&
          project.links!.appStore!.isNotEmpty) {
        return project.links!.appStore!;
      }
      if (project.links!.indusAppStore != null &&
          project.links!.indusAppStore!.isNotEmpty) {
        return project.links!.indusAppStore!;
      }
    }

    if (project.link != null) {
      if (project.link!.playStore != null &&
          project.link!.playStore!.isNotEmpty) {
        return project.link!.playStore!;
      }
      if (project.link!.appStore != null &&
          project.link!.appStore!.isNotEmpty) {
        return project.link!.appStore!;
      }
    }

    // Fallback to a default URL
    return "#";
  }
}

class FeaturedProject extends StatelessWidget {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final Map<String, String> links;

  const FeaturedProject({
    super.key,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.links,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 48.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Project Image
          Expanded(
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                image: DecorationImage(
                  image: AssetImage(imageUrl),
                  fit: BoxFit.cover,
                  onError: (exception, stackTrace) {
                    // Handle image loading error
                    log('Error loading image: $exception');
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: 32.0),
          // Project Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Featured Project",
                  style: TextStyle(
                    color: Color(0xff64FFDA),
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xffCCD6F6),
                    fontSize: 24.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16.0),
                Container(
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: const Color(0xff112240),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Text(
                    description,
                    style: const TextStyle(
                      color: Color(0xff8892B0),
                      fontSize: 14.0,
                      height: 1.5,
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                Wrap(
                  spacing: 16.0,
                  runSpacing: 8.0,
                  children: tags.map((tag) => _buildTag(tag)).toList(),
                ),
                const SizedBox(height: 16.0),
                Row(
                  children: links.entries
                      .map((entry) => _buildLink(entry.key, entry.value))
                      .toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Text(
      tag,
      style: const TextStyle(
        color: Color(0xff8892B0),
        fontSize: 13.0,
        fontFamily: 'SF Mono',
      ),
    );
  }

  Widget _buildLink(String text, String url) {
    return Padding(
      padding: const EdgeInsets.only(right: 16.0),
      child: InkWell(
        onTap: () => launchUrl(Uri.parse(url)),
        child: Text(
          text,
          style: const TextStyle(
            color: Color(0xff64FFDA),
            fontSize: 14.0,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final String title;
  final String description;
  final List<String> tags;
  final String link;

  const ProjectCard({
    super.key,
    required this.title,
    required this.description,
    required this.tags,
    required this.link,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: const Color(0xff112240),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(
                Icons.folder_outlined,
                color: Color(0xff64FFDA),
                size: 32.0,
              ),
              IconButton(
                icon: const Icon(
                  Icons.launch,
                  color: Color(0xffCCD6F6),
                  size: 20.0,
                ),
                onPressed: () => launchUrl(Uri.parse(link)),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          Text(
            title,
            style: const TextStyle(
              color: Color(0xffCCD6F6),
              fontSize: 18.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            description,
            style: const TextStyle(
              color: Color(0xff8892B0),
              fontSize: 14.0,
              height: 1.5,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Wrap(
            spacing: 12.0,
            runSpacing: 8.0,
            children: tags.map((tag) => _buildTag(tag)).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String tag) {
    return Text(
      tag,
      style: const TextStyle(
        color: Color(0xff8892B0),
        fontSize: 12.0,
        fontFamily: 'SF Mono',
      ),
    );
  }
}

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

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        children: [
          const Text(
            "04. What's Next?",
            style: TextStyle(
              color: Color(0xff64FFDA),
              fontSize: 14.0,
              fontFamily: 'SF Mono',
            ),
          ),
          const SizedBox(height: 16.0),
          const Text(
            "Get In Touch",
            style: TextStyle(
              color: Color(0xffCCD6F6),
              fontSize: 48.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16.0),
          Container(
            width: 500,
            alignment: Alignment.center,
            child: const Text(
              "I'm currently looking for new opportunities. Whether you have a question or just want to say hi, feel free to reach out!",
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
