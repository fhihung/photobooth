import 'package:photobooth_ui/photobooth_ui.dart';

const googleIOExternalLink = 'https://facebook.com/phenikaa.gdsc.dev';
const flutterDevExternalLink = 'https://flutter.dev';
const firebaseExternalLink = 'https://firebase.google.com';
const photoboothEmail = 'mailto:phenikaa.gdsc.dev@gmail.com';
const openSourceLink = 'https://github.com/flutter/photobooth';

Future<void> launchGoogleIOLink() => openLink(googleIOExternalLink);
Future<void> launchFlutterDevLink() => openLink(flutterDevExternalLink);
Future<void> launchFirebaseLink() => openLink(firebaseExternalLink);
Future<void> launchPhotoboothEmail() => openLink(photoboothEmail);
Future<void> launchOpenSourceLink() => openLink(openSourceLink);
