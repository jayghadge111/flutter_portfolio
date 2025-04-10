// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../models/portfolio_data.dart';
// import '../widgets/main_title.dart';

// class ProjectsSection extends ConsumerWidget {
//   final PortfolioData portfolioData;

//   const ProjectsSection({
//     super.key,
//     required this.portfolioData,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     // Early return if no projects data
//     if (portfolioData.projects == null || portfolioData.projects!.isEmpty) {
//       return const SizedBox.shrink();
//     }

//     final projects = portfolioData.projects!;
//     // Use all projects as featured projects initially
//     final featuredProjects = projects.take(3).toList();

//     // Other projects are anything beyond the first 3
//     final otherProjects =
//         projects.length > 3 ? projects.sublist(3) : <Projects>[];

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const MainTitle(number: "03.", text: "Some Things I've Built"),
//           const SizedBox(height: 40.0),

//           // Featured Projects
//           ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(),
//             itemCount: featuredProjects.length,
//             itemBuilder: (context, index) {
//               final project = featuredProjects[index];
//               return FeaturedProject(
//                 title: project.name ?? "",
//                 description: project.description ?? "",
//                 imageUrl:
//                     "images/${project.name?.replaceAll(' ', '_').toLowerCase() ?? 'project'}.jpg",
//                 tags: _getProjectTags(project),
//                 links: _getProjectLinks(project),
//               );
//             },
//           ),

//           // Only show "Other Projects" section if there are any
//           if (otherProjects.isNotEmpty) ...[
//             const SizedBox(height: 48.0),
//             const Text(
//               "Other Noteworthy Projects",
//               style: TextStyle(
//                 color: Color(0xffCCD6F6),
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//             const SizedBox(height: 24.0),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 16.0,
//                 mainAxisSpacing: 16.0,
//                 childAspectRatio: 1.0,
//               ),
//               itemCount: otherProjects.length,
//               itemBuilder: (context, index) {
//                 final project = otherProjects[index];
//                 return ProjectCard(
//                   title: project.name ?? "",
//                   description: project.description ?? "",
//                   tags: _getProjectTags(project),
//                   link: _getPrimaryProjectLink(project),
//                 );
//               },
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // Extract tags from project data
//   List<String> _getProjectTags(Projects project) {
//     final List<String> tags = [];
//     if (project.platform != null && project.platform!.isNotEmpty) {
//       tags.add(project.platform!);
//     }
//     if (project.status != null && project.status!.isNotEmpty) {
//       tags.add(project.status!);
//     }

//     return tags;
//   }

//   // Extract links from project data
//   Map<String, String> _getProjectLinks(Projects project) {
//     final Map<String, String> links = {};

//     // Check for links in Links object first
//     if (project.links != null) {
//       if (project.links!.playStore != null &&
//           project.links!.playStore!.isNotEmpty) {
//         links["Play Store"] = project.links!.playStore!;
//       }
//       if (project.links!.appStore != null &&
//           project.links!.appStore!.isNotEmpty) {
//         links["App Store"] = project.links!.appStore!;
//       }
//       if (project.links!.indusAppStore != null &&
//           project.links!.indusAppStore!.isNotEmpty) {
//         links["Indus App Store"] = project.links!.indusAppStore!;
//       }
//       if (project.links!.web != null && project.links!.web!.isNotEmpty) {
//         links["Web"] = project.links!.web!;
//       }
//     }
//     // Then check for links in Link object
//     else if (project.link != null) {
//       if (project.link!.playStore != null &&
//           project.link!.playStore!.isNotEmpty) {
//         links["Play Store"] = project.link!.playStore!;
//       }
//       if (project.link!.appStore != null &&
//           project.link!.appStore!.isNotEmpty) {
//         links["App Store"] = project.link!.appStore!;
//       }
//     }

//     return links;
//   }

//   // Get the primary link for a project
//   String _getPrimaryProjectLink(Projects project) {
//     // Try to get a link in this priority order: web > playStore > appStore > indusAppStore
//     if (project.links != null) {
//       if (project.links!.web != null && project.links!.web!.isNotEmpty) {
//         return project.links!.web!;
//       }
//       if (project.links!.playStore != null &&
//           project.links!.playStore!.isNotEmpty) {
//         return project.links!.playStore!;
//       }
//       if (project.links!.appStore != null &&
//           project.links!.appStore!.isNotEmpty) {
//         return project.links!.appStore!;
//       }
//       if (project.links!.indusAppStore != null &&
//           project.links!.indusAppStore!.isNotEmpty) {
//         return project.links!.indusAppStore!;
//       }
//     }

//     if (project.link != null) {
//       if (project.link!.playStore != null &&
//           project.link!.playStore!.isNotEmpty) {
//         return project.link!.playStore!;
//       }
//       if (project.link!.appStore != null &&
//           project.link!.appStore!.isNotEmpty) {
//         return project.link!.appStore!;
//       }
//     }

//     // Fallback to a default URL
//     return "#";
//   }
// }

// class FeaturedProject extends StatelessWidget {
//   final String title;
//   final String description;
//   final String imageUrl;
//   final List<String> tags;
//   final Map<String, String> links;

//   const FeaturedProject({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.imageUrl,
//     required this.tags,
//     required this.links,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 48.0),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           // Project Image
//           Expanded(
//             child: Container(
//               height: 300,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8.0),
//                 image: DecorationImage(
//                   image: AssetImage(imageUrl),
//                   fit: BoxFit.cover,
//                   onError: (exception, stackTrace) {
//                     // Handle image loading error
//                     print('Error loading image: $exception');
//                   },
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 32.0),
//           // Project Details
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const Text(
//                   "Featured Project",
//                   style: TextStyle(
//                     color: Color(0xff64FFDA),
//                     fontSize: 14.0,
//                   ),
//                 ),
//                 const SizedBox(height: 8.0),
//                 Text(
//                   title,
//                   style: const TextStyle(
//                     color: Color(0xffCCD6F6),
//                     fontSize: 24.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Container(
//                   padding: const EdgeInsets.all(24.0),
//                   decoration: BoxDecoration(
//                     color: const Color(0xff112240),
//                     borderRadius: BorderRadius.circular(8.0),
//                   ),
//                   child: Text(
//                     description,
//                     style: const TextStyle(
//                       color: Color(0xff8892B0),
//                       fontSize: 14.0,
//                       height: 1.5,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Wrap(
//                   spacing: 16.0,
//                   runSpacing: 8.0,
//                   children: tags.map((tag) => _buildTag(tag)).toList(),
//                 ),
//                 const SizedBox(height: 16.0),
//                 Row(
//                   children: links.entries
//                       .map((entry) => _buildLink(entry.key, entry.value))
//                       .toList(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTag(String tag) {
//     return Text(
//       tag,
//       style: const TextStyle(
//         color: Color(0xff8892B0),
//         fontSize: 13.0,
//         fontFamily: 'SF Mono',
//       ),
//     );
//   }

//   Widget _buildLink(String text, String url) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 16.0),
//       child: InkWell(
//         onTap: () => launchUrl(Uri.parse(url)),
//         child: Text(
//           text,
//           style: const TextStyle(
//             color: Color(0xff64FFDA),
//             fontSize: 14.0,
//             decoration: TextDecoration.underline,
//           ),
//         ),
//       ),
//     );
//   }
// }

// class ProjectCard extends StatelessWidget {
//   final String title;
//   final String description;
//   final List<String> tags;
//   final String link;

//   const ProjectCard({
//     super.key,
//     required this.title,
//     required this.description,
//     required this.tags,
//     required this.link,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.all(24.0),
//       decoration: BoxDecoration(
//         color: const Color(0xff112240),
//         borderRadius: BorderRadius.circular(8.0),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               const Icon(
//                 Icons.folder_outlined,
//                 color: Color(0xff64FFDA),
//                 size: 32.0,
//               ),
//               IconButton(
//                 icon: const Icon(
//                   Icons.launch,
//                   color: Color(0xffCCD6F6),
//                   size: 20.0,
//                 ),
//                 onPressed: () => launchUrl(Uri.parse(link)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 16.0),
//           Text(
//             title,
//             style: const TextStyle(
//               color: Color(0xffCCD6F6),
//               fontSize: 18.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 8.0),
//           Text(
//             description,
//             style: const TextStyle(
//               color: Color(0xff8892B0),
//               fontSize: 14.0,
//               height: 1.5,
//             ),
//             maxLines: 3,
//             overflow: TextOverflow.ellipsis,
//           ),
//           const Spacer(),
//           Wrap(
//             spacing: 12.0,
//             runSpacing: 8.0,
//             children: tags.map((tag) => _buildTag(tag)).toList(),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildTag(String tag) {
//     return Text(
//       tag,
//       style: const TextStyle(
//         color: Color(0xff8892B0),
//         fontSize: 12.0,
//         fontFamily: 'SF Mono',
//       ),
//     );
//   }
// }
