import '/custom_code/actions/index.dart' as actions;
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'auth/custom_auth/auth_util.dart';
import 'auth/custom_auth/custom_auth_user_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'index.dart';
//import '/custom_code/functions.dart' as functions;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GoRouter.optionURLReflectsImperativeAPIs = true;
  usePathUrlStrategy();

  // Start initial custom actions code
  await actions.onesignal();

  await FlutterFlowTheme.initialize();
  await authManager.initialize();
  await FFLocalizations.initialize();

  final appState = FFAppState(); // Initialize FFAppState
  await appState.initializePersistedState();

  runApp(ChangeNotifierProvider(
    create: (context) => appState,
    child: const MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale = FFLocalizations.getStoredLocale();

  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;
  late Stream<MaptroniczGPSAuthUser> userStream;

  var deviceListItem;
  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
    userStream = maptroniczGPSAuthUserStream()
      ..listen((user) {
        _appStateNotifier.update(user);
      });

    Future.delayed(
      const Duration(milliseconds: 1000),
      () => _appStateNotifier.stopShowingSplashImage(),
    );
  }

  void setLocale(String language) {
    safeSetState(() => _locale = createLocale(language));
    FFLocalizations.storeLocale(language);
  }

  void setThemeMode(ThemeMode mode) => safeSetState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Maptronicz GPS',
      localizationsDelegates: const [
        FFLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FallbackMaterialLocalizationDelegate(),
        FallbackCupertinoLocalizationDelegate(),
      ],
      locale: _locale,
      supportedLocales: const [
        Locale('en'),
        Locale('bn'),
        Locale('hi'),
        Locale('ar'),
        Locale('fr'),
        Locale('de'),
        Locale('vi'),
        Locale('ur'),
        Locale('nl'),
        Locale('id'),
        Locale('it'),
        Locale('fa'),
        Locale('ru'),
        Locale('ro'),
        Locale('pt'),
        Locale('es'),
      ],
      theme: ThemeData(
        brightness: Brightness.light,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          interactive: true,
        ),
        useMaterial3: false,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scrollbarTheme: ScrollbarThemeData(
          thumbVisibility: WidgetStateProperty.all(false),
          trackVisibility: WidgetStateProperty.all(false),
          interactive: true,
        ),
        useMaterial3: false,
      ),
      themeMode: _themeMode,
      routerConfig: _router,
    );
  }
}

class NavBarPage extends StatefulWidget {
  const NavBarPage({super.key, this.initialPage, this.page});

  final String? initialPage;
  final Widget? page;

  @override
  _NavBarPageState createState() => _NavBarPageState();
}

class _NavBarPageState extends State<NavBarPage> {
  String _currentPageName = 'Home';
  late Widget? _currentPage;

  @override
  void initState() {
    super.initState();
    _currentPageName = widget.initialPage ?? _currentPageName;
    _currentPage = widget.page;
  }

  // Method to get the first vehicle that is expired or will expire in 15 days
  Map<String, dynamic>? getFirstExpiredVehicle() {
    final allDevices = getJsonField(
          FFAppState().allDeviceData,
          r'''$.result''',
          true,
        )?.toList() ??
        [];

    print('===== API Response Debug =====');
    print('All Devices Data: ${FFAppState().allDeviceData}');
    print('Number of devices: ${allDevices.length}');

    final now = DateTime.now();
    final fifteenDaysFromNow = now.add(const Duration(days: 15));

    // Find the first expired or soon to expire vehicle
    for (var device in allDevices) {
      final expiryDateStr =
          getJsonField(device, r'''$.object_expire_dt''')?.toString();
      if (expiryDateStr != null) {
        final expiryDate = DateTime.tryParse(expiryDateStr);
        if (expiryDate != null) {
          // Check if expired or will expire within 15 days
          if (expiryDate.isBefore(fifteenDaysFromNow)) {

            return device as Map<String, dynamic>;
          }
        }
      }
    }

    return null;
  }

  String getAlertMessage(
      DateTime expiryDate, String vehicleNumber, String name) {
    final now = DateTime.now();
    final daysUntilExpiry = expiryDate.difference(now).inDays;

    if (daysUntilExpiry < 0) {
      // Already expired
      return "Vehicle $vehicleNumber has expired. $name Kindly contact 8433994312/022-41310112";
    } else {
      // Will expire within 15 days
      return "Vehicle  $name will expire in $daysUntilExpiry days. $vehicleNumber Kindly contact 8433994312/022-41310112";
    }
  }

  void showExpiredVehicleAlert() {
    final expiredVehicle = getFirstExpiredVehicle();

    if (expiredVehicle == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(''),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final vehicleNumber =
        getJsonField(expiredVehicle, r'''$.object_expire_dt''')?.toString() ??
            'Unknown';
    final name = getJsonField(expiredVehicle, r'''$.name''')?.toString() ?? '';
    final expiryDateStr =
        getJsonField(expiredVehicle, r'''$.object_expire_dt''')?.toString();
    final expiryDate = DateTime.tryParse(expiryDateStr ?? '') ?? DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.all(16),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  getAlertMessage(expiryDate, vehicleNumber, name),
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  // List<Map<String, dynamic>> getExpiredVehicles() {
  //   final allDevices = getJsonField(
  //         FFAppState().allDeviceData,
  //         r'''$.result''',
  //         true,
  //       )?.toList() ??
  //       [];
  // print('Total expired vehicles found: ${expiredVehicles.length}');
  //print('Expired Vehicles Data: $expiredVehicles');

  //   print('===== API Response Debug =====');
  //   print('All Devices Data: ${FFAppState().allDeviceData}');
  //   print('Number of devices: ${allDevices.length}');

  //   final now = DateTime.now();
  //   final fifteenDaysFromNow = now.add(const Duration(days: 15));

  //   // Find all expired or soon to expire vehicles
  //   List<Map<String, dynamic>> expiredVehicles = [];

  //   for (var device in allDevices) {
  //     final expiryDateStr =
  //         getJsonField(device, r'''$.object_expire_dt''')?.toString();
  //     if (expiryDateStr != null) {
  //       final expiryDate = DateTime.tryParse(expiryDateStr);
  //       if (expiryDate != null) {
  //         // Check if expired or will expire within 15 days
  //         if (expiryDate.isBefore(fifteenDaysFromNow)) {
  //           expiredVehicles.add(device as Map<String, dynamic>);
  //         }
  //       }
  //     }
  //   }

  //   return expiredVehicles;
  // }

  // String getAlertMessage(
  //     DateTime expiryDate, String vehicleNumber, String name) {
  //   final now = DateTime.now();
  //   final daysUntilExpiry = expiryDate.difference(now).inDays;

  //   // Format the expiry date to show in the message
  //   final formattedDate =
  //       "${expiryDate.year}-${expiryDate.month.toString().padLeft(2, '0')}-${expiryDate.day.toString().padLeft(2, '0')}";

  //   if (daysUntilExpiry < 0) {
  //     // Already expired
  //     return "Vehicle $vehicleNumber has expired. $formattedDate Kindly contact 8433994312/022-41310112";
  //   } else {
  //     // Will expire within 15 days
  //     return "Vehicle $vehicleNumber will expire in $daysUntilExpiry days. $formattedDate Kindly contact 8433994312/022-41310112";
  //   }
  // }

  // void showExpiredVehicleAlert() {
  //   final expiredVehicles = getExpiredVehicles();

  //   if (expiredVehicles.isEmpty) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(
  //         content: Text('No vehicles expiring soon'),
  //         duration: Duration(seconds: 2),
  //       ),
  //     );
  //     return;
  //   }

  //   // For debugging - print all fields of each vehicle
  //   for (var vehicle in expiredVehicles) {
  //     print('Vehicle data: $vehicle');
  //   }

  //   // Show alert for each expired vehicle
  //   for (var vehicle in expiredVehicles) {
  //     // Try different JSON paths to get the vehicle number
  //     String vehicleNumber = 'Unknown';

  //     // Check common field names for vehicle identification
  //     final possibleFields = [
  //       'object_id',
  //       'object_number',
  //       'vehicle_number',
  //       'reg_number',
  //       'registration_number',
  //       'name',
  //       'id'
  //     ];

  //     for (var field in possibleFields) {
  //       final value = getJsonField(vehicle, r'''$''' + '.' + field)?.toString();
  //       if (value != null && value.isNotEmpty) {
  //         vehicleNumber = value;
  //         print('Found vehicle number in field "$field": $vehicleNumber');
  //         break;
  //       }
  //     }

  //     final name = getJsonField(vehicle, r'''$.name''')?.toString() ?? '';
  //     final expiryDateStr =
  //         getJsonField(vehicle, r'''$.object_expire_dt''')?.toString();
  //     final expiryDate =
  //         DateTime.tryParse(expiryDateStr ?? '') ?? DateTime.now();

  //     // Show individual dialog for each vehicle
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return AlertDialog(
  //           backgroundColor: Colors.orange,
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           contentPadding: const EdgeInsets.all(16),
  //           content: Row(
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Expanded(
  //                 child: Text(
  //                   getAlertMessage(expiryDate, vehicleNumber, name),
  //                   style: const TextStyle(
  //                     fontSize: 16,
  //                     color: Colors.white,
  //                   ),
  //                 ),
  //               ),
  //               IconButton(
  //                 icon: const Icon(Icons.close, color: Colors.white),
  //                 onPressed: () {
  //                   Navigator.of(context).pop();
  //                 },
  //               ),
  //             ],
  //           ),
  //         );
  //       },
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final tabs = {
      'Home': const HomeWidget(),
      'Multiple_Fleet': const MultipleFleetWidget(),
      'CarListScreen': const CarListScreenWidget(),
      'Alert': const AlertWidget(),
      'More': const MoreWidget(),
    };
    final currentIndex = tabs.keys.toList().indexOf(_currentPageName);

    return Scaffold(
      body: _currentPage ?? tabs[_currentPageName],
      bottomNavigationBar: GNav(
        selectedIndex: currentIndex,
        onTabChange: (i) => safeSetState(() {
          _currentPage = null;
          _currentPageName = tabs.keys.toList()[i];
        }),
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        color: FlutterFlowTheme.of(context).secondaryText,
        activeColor: Colors.white,
        tabBackgroundColor: FlutterFlowTheme.of(context).primary,
        tabBorderRadius: 100.0,
        tabMargin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(10.0),
        gap: 0.0,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        duration: const Duration(milliseconds: 500),
        haptic: false,
        tabs: [
          const GButton(
            icon: Icons.home,
            text: 'Home',
            iconSize: 22.0,
          ),
          const GButton(
            icon: Icons.location_on,
            text: 'Map View',
            iconSize: 24.0,
          ),
          GButton(
            icon: Icons.assignment,
            text: 'List View',
            textStyle: GoogleFonts.roboto(),
            iconSize: 24.0,
            onPressed: showExpiredVehicleAlert,
          ),
          GButton(
            icon: currentIndex == 3
                ? FontAwesomeIcons.bell
                : Icons.notifications_rounded,
            text: 'Alert',
            iconSize: 24.0,
          ),
          GButton(
            icon: currentIndex == 4
                ? Icons.dashboard_customize
                : Icons.dashboard_customize,
            text: 'More',
            iconSize: 24.0,
          ),
        ],
      ),
    );
  }
}
