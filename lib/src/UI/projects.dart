import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jayesh_flutter/src/widgets/main_title.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/portfolio_data.dart';

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
          const MainTitle(number: "03.", text: "Recent Key Assigments"),
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
                    "project_images/${project.image?.replaceAll(' ', '_').toLowerCase() ?? 'project'}",
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
                childAspectRatio: 5 / 4.25,
              ),
              itemCount: otherProjects.length,
              itemBuilder: (context, index) {
                final project = otherProjects[index];
                return ProjectCard(
                  imageUrl:
                      "project_images/${project.image?.replaceAll(' ', '_').toLowerCase() ?? ''}",
                  title: project.name ?? "",
                  description: project.description ?? "",
                  tags: _getProjectTags(project),
                  links: _getAllProjectLinks(project),
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

    return links;
  }

  Map<String, String> _getAllProjectLinks(Projects project) {
    final Map<String, String> links = {};

    if (project.links != null) {
      if (project.links!.web?.isNotEmpty ?? false) {
        links['web'] = project.links!.web!;
      }
      if (project.links!.playStore?.isNotEmpty ?? false) {
        links['playStore'] = project.links!.playStore!;
      }
      if (project.links!.appStore?.isNotEmpty ?? false) {
        links['appStore'] = project.links!.appStore!;
      }
      if (project.links!.indusAppStore?.isNotEmpty ?? false) {
        links['indusAppStore'] = project.links!.indusAppStore!;
      }
    }

    return links;
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
        mainAxisAlignment: MainAxisAlignment.start,
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
  final String imageUrl;
  final String title;
  final String description;
  final List<String> tags;
  final Map<String, String> links; // Updated

  const ProjectCard({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.description,
    required this.tags,
    required this.links,
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
            mainAxisAlignment: MainAxisAlignment.end,
            children: _buildLinkIcons(),
          ),
          const SizedBox(height: 16.0),
          Center(
            child: Image.asset(
              imageUrl,
              height: 220,
              fit: BoxFit.cover,
            ),
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

  List<Widget> _buildLinkIcons() {
    final List<Widget> icons = [
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
          ],
        ),
      ),
      Spacer(),
    ];

    if (links['web'] != null) {
      icons.add(_buildIcon(FontAwesomeIcons.chrome, links['web']!));
    }
    if (links['playStore'] != null) {
      icons.add(_buildIcon(FontAwesomeIcons.android, links['playStore']!));
    }
    if (links['appStore'] != null) {
      icons.add(_buildIcon(FontAwesomeIcons.apple, links['appStore']!));
    }
    if (links['indusAppStore'] != null) {
      icons.add(_buildIcon(FontAwesomeIcons.store, links['indusAppStore']!));
    }

    return icons;
  }

  Widget _buildIcon(IconData icon, String url) {
    return IconButton(
      icon: Icon(icon, color: Color(0xff64FFDA), size: 20.0),
      onPressed: () => launchUrl(Uri.parse(url)),
      tooltip: url,
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
