import '/flutter_flow/flutter_flow_util.dart';
import 'create_geofence_widget.dart' show CreateGeofenceWidget;
import 'package:flutter/material.dart';

class CreateGeofenceModel extends FlutterFlowModel<CreateGeofenceWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
