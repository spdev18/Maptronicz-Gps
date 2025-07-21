import 'package:rxdart/rxdart.dart';

import 'custom_auth_manager.dart';

class MaptroniczGPSAuthUser {
  MaptroniczGPSAuthUser({required this.loggedIn, this.uid});

  bool loggedIn;
  String? uid;
}

/// Generates a stream of the authenticated user.
BehaviorSubject<MaptroniczGPSAuthUser> maptroniczGPSAuthUserSubject =
    BehaviorSubject.seeded(MaptroniczGPSAuthUser(loggedIn: false));
Stream<MaptroniczGPSAuthUser> maptroniczGPSAuthUserStream() =>
    maptroniczGPSAuthUserSubject
        .asBroadcastStream()
        .map((user) => currentUser = user);
