import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final firebaseOptions = kIsWeb
    ? const FirebaseOptions(
        apiKey: "AIzaSyBTu0YG8i3w3NW9sxKcH2Xhru5493iBM2M",
        authDomain: "flutter-portfolio-175e9.firebaseapp.com",
        projectId: "flutter-portfolio-175e9",
        storageBucket: "flutter-portfolio-175e9.appspot.com",
        messagingSenderId: "486954760440",
        appId: "1:486954760440:web:1ee9936691e3012d58630d",
        measurementId: "G-FPGVK18QT5",
      )
    : const FirebaseOptions(
        // Non-web options
        apiKey: "AIzaSyBTu0YG8i3w3NW9sxKcH2Xhru5493iBM2M",
        appId: "1:486954760440:web:1ee9936691e3012d58630d",
        messagingSenderId: "486954760440",
        projectId: "flutter-portfolio-175e9",
      );
