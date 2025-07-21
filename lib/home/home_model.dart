import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/form_field_controller.dart';
import 'home_widget.dart' show HomeWidget;
import 'package:flutter/material.dart';

class HomeModel extends FlutterFlowModel<HomeWidget> {
  ///  Local state fields for this page.

  dynamic homeScreenData;

  dynamic deviceGeneralInfoData;

  bool? hideTemp;

  ///  State fields for stateful widgets in this page.

  // Stores action output result for [Backend Call - API (deviceGeneralInfo)] action in Home widget.
  ApiCallResponse? firstVehicleGeneralInfoRes;
  // State field(s) for PageView widget.
  PageController? pageViewController;

  int get pageViewCurrentIndex => pageViewController != null &&
          pageViewController!.hasClients &&
          pageViewController!.page != null
      ? pageViewController!.page!.round()
      : 0;
  // State field(s) for DropDown widget.
  String? dropDownValue;
  FormFieldController<String>? dropDownValueController;
  // Stores action output result for [Backend Call - API (deviceGeneralInfo)] action in DropDown widget.
  ApiCallResponse? deviceGeneralInfoRes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {}
}
