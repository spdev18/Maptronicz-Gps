// Automatic FlutterFlow imports
// Imports other custom actions
// Imports custom functions
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'package:in_app_update/in_app_update.dart';

Future inAppUpdate() async {
  // Check for App update from play store using the package
  // Check for available update
  await InAppUpdate.checkForUpdate().then((updateInfo) {
    if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
      // Update is available, prompt user to update
      InAppUpdate.performImmediateUpdate().catchError((e) => print(e));
    }
  }).catchError((e) => print(e));
}
