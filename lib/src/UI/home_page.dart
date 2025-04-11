import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/services.dart'
    show Clipboard, ClipboardData, rootBundle;
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jayesh_flutter/src/UI/contact_sections.dart';
import 'package:jayesh_flutter/src/UI/footer.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../models/method.dart';
import '../models/portfolio_data.dart';
import '../widgets/app_bar_title.dart';
import 'about.dart';
import 'email_section.dart';
import 'introduction.dart';
import 'projects.dart';
import 'social_links.dart';
import 'work_experience.dart';

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

                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: Container(
                        margin: const EdgeInsets.all(8.0),
                        height: size.height * 0.05,
                        // width: size.height * 0.13,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xff64FFDA), Color(0xff32D9A6)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.15),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: TextButton.icon(
                          onPressed: downloadFileFromAssets,
                          icon: FaIcon(
                            FontAwesomeIcons.circleArrowDown,
                            color: Color(0xff0A192F),
                          ),
                          label: const Text(
                            "Download",
                            style: TextStyle(
                              color: Color(0xff0A192F),
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.transparent,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                            ),
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




