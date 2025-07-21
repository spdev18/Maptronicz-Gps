import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:maptronicz/app_state.dart';
import 'package:maptronicz/flutter_flow/flutter_flow_util.dart';
import 'package:share_plus/share_plus.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import '/backend/api_requests/api_calls.dart';

class VehicleLocationShare extends StatefulWidget {
  const VehicleLocationShare({super.key});

  @override
  _VehicleLocationShareState createState() => _VehicleLocationShareState();
}

class _VehicleLocationShareState extends State<VehicleLocationShare> {
  final Location _location = Location();
  double? _latitude;
  double? _longitude;
  String? selectedVehicle;
  List<String> vehicleImeis = [];
  List<String> vehicleNames = [];
  Map<String, String> imeiToNameMap = {};
  bool _isTracking = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadVehicleData();
  }

  void _loadVehicleData() {
    try {
      final deviceData = getJsonField(
        FFAppState().allDeviceData,
        r'''$.result''',
        true,
      ) as List?;

      if (deviceData != null && deviceData.isNotEmpty) {
        setState(() {
          vehicleImeis = (getJsonField(
            FFAppState().allDeviceData,
            r'''$.result[:].imei''',
            true,
          ) as List)
              .map<String>((s) => s.toString())
              .toList();

          vehicleNames = (getJsonField(
            FFAppState().allDeviceData,
            r'''$.result[:].name''',
            true,
          ) as List)
              .map<String>((s) => s.toString())
              .toList();

          for (int i = 0; i < vehicleImeis.length; i++) {
            if (i < vehicleNames.length) {
              imeiToNameMap[vehicleImeis[i]] = vehicleNames[i];
            }
          }

          if (vehicleImeis.isNotEmpty) {
            selectedVehicle = vehicleImeis[0];
          }
        });
      }
    } catch (e) {
      print('Error loading vehicle data: $e');
    }
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await _location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await _location.requestService();
      if (!serviceEnabled) return;
    }

    permissionGranted = await _location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await _location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) return;
    }

    // Enable real-time location tracking
    _location.changeSettings(interval: 50000, accuracy: LocationAccuracy.high);
    _location.onLocationChanged.listen((LocationData locationData) {
      setState(() {
        _latitude = locationData.latitude;
        _longitude = locationData.longitude;
      });
    });

    setState(() {
      _isTracking = true;
    });
  }

  Future<void> _shareLocation() async {
    if (selectedVehicle != null) {
      // Find the selected vehicle's data from allDeviceData
      final deviceData = getJsonField(
        FFAppState().allDeviceData,
        r'''$.result''',
        true,
      ) as List?;
      if (deviceData != null) {
        final vehicle = deviceData.firstWhere(
          (item) => getJsonField(item, r'$.imei', true).toString() == selectedVehicle,
          orElse: () => null,
        );
        if (vehicle != null) {
          final lat = getJsonField(vehicle, r'$.lat', true);
          final lng = getJsonField(vehicle, r'$.lng', true);
          if (lat != null && lng != null) {
            String locationUrl = "https://www.google.com/maps?q=$lat,$lng";
            String vehicleDisplay = imeiToNameMap[selectedVehicle] ?? selectedVehicle!;
            String message =
                "Check the current location of vehicle $vehicleDisplay: $locationUrl";
            Share.share(message, subject: "Vehicle Location Sharing");
            return;
          }
        }
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Unable to fetch selected vehicle location.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('No vehicle selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        title: const Text(
          'Vehicle Location Sharing',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Select Vehicle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                if (vehicleImeis.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(),
                    ),
                  )
                else
                  DropdownButtonFormField<String>(
                    value: selectedVehicle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: vehicleImeis.map((imei) {
                      final name = imeiToNameMap[imei] ?? imei;
                      return DropdownMenuItem<String>(
                        value: imei,
                        child: Text(name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedVehicle = value;
                      });
                    },
                  ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: vehicleImeis.isEmpty ? null : _shareLocation,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Share Location',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}