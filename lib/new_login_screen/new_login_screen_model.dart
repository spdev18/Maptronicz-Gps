import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'new_login_screen_widget.dart' show NewLoginScreenWidget;
import 'package:flutter/material.dart';

class NewLoginScreenModel extends FlutterFlowModel<NewLoginScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode1;
  TextEditingController? textController1;
  String? Function(BuildContext, String?)? textController1Validator;
  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode2;
  TextEditingController? textController2;
  String? Function(BuildContext, String?)? textController2Validator;
  // Stores action output result for [Backend Call - API (fn Connect LOGIN TRACKING Api)] action in Button widget.
  ApiCallResponse? loginApiRes;
  // Stores action output result for [Backend Call - API (Php Get User API key)] action in Button widget.
  ApiCallResponse? getApiKeyRes;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode1?.dispose();
    textController1?.dispose();

    textFieldFocusNode2?.dispose();
    textController2?.dispose();
  }
}
