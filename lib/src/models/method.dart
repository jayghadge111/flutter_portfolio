import 'dart:html' as html;
import 'dart:typed_data';
import 'package:flutter/services.dart' show rootBundle;
import 'package:url_launcher/url_launcher.dart';

class Method {
  // Launch URL
  Future<void> launchURL(String link) async {
    final url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Launch phone call
  Future<void> launchCaller({String phoneNumber = "9970900787"}) async {
    final url = Uri.parse("tel:$phoneNumber");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Launch email
  Future<void> launchEmail({String email = "jayghadge111@gmail.com"}) async {
    final url = Uri.parse("mailto:$email");
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Download resume from assets
  Future<void> downloadResumeFromAssets() async {
    try {
      // Load PDF from assets
      final ByteData bytes =
          await rootBundle.load('images/jayesh_ghadge_resume.pdf');
      final Uint8List pdfBytes = bytes.buffer.asUint8List();

      // Create blob and download URL
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final String downloadUrl = html.Url.createObjectUrlFromBlob(blob);

      // Create and click anchor element to download
      final html.AnchorElement anchor = html.AnchorElement()
        ..href = downloadUrl
        ..style.display = 'none'
        ..download = 'jayesh_ghadge_cv.pdf';

      html.document.body!.children.add(anchor);
      anchor.click();
      html.document.body!.children.remove(anchor);
      html.Url.revokeObjectUrl(downloadUrl);
    } catch (e) {
      print('Error downloading resume: $e');
    }
  }
}
