// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:url_launcher/url_launcher.dart';

// import '../models/portfolio_data.dart';

// class ContactSection extends ConsumerWidget {
//   final PortfolioData portfolioData;

//   const ContactSection({
//     super.key,
//     required this.portfolioData,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final Contact? contact = portfolioData.contact;
//     final String? email = contact?.email;

//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 48.0),
//       child: Column(
//         children: [
//           const Text(
//             "04. What's Next?",
//             style: TextStyle(
//               color: Color(0xff64FFDA),
//               fontSize: 14.0,
//               fontFamily: 'SF Mono',
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           const Text(
//             "Get In Touch",
//             style: TextStyle(
//               color: Color(0xffCCD6F6),
//               fontSize: 48.0,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 16.0),
//           Container(
//             width: 500,
//             alignment: Alignment.center,
//             child: const Text(
//               "I'm currently looking for new opportunities. Whether you have a question or just want to say hi, feel free to reach out!",
//               style: TextStyle(
//                 color: Color(0xff8892B0),
//                 fontSize: 16.0,
//                 height: 1.5,
//               ),
//             ),
//           ),
//           const SizedBox(height: 32.0),
//           ElevatedButton(
//             onPressed: () => launchUrl(Uri.parse("mailto:${email ?? ''}")),
//             style: ElevatedButton.styleFrom(
//               backgroundColor: const Color(0xff64FFDA),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(4.0),
//               ),
//             ),
//             child: const Padding(
//               padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
//               child: Text(
//                 "Say Hello",
//                 style: TextStyle(
//                   color: Color(0xff0A192F),
//                   fontSize: 14.0,
//                   fontFamily: 'SF Mono',
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
