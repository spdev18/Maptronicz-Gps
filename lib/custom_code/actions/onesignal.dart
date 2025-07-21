// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:onesignal_flutter/onesignal_flutter.dart';

Future onesignal() async {
  // Add your function code here!
  OneSignal.Debug.setLogLevel(OSLogLevel.verbose);

  OneSignal.initialize("e23bda74-1a37-48d9-acca-e76323714e66");
  OneSignal.Notifications.requestPermission(true);
}

// Set your action name, define your arguments and return parameter,
// and then add the boilerplate code using the green button on the right!
