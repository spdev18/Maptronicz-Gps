import '/components/drawer_widget.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'draw_widget.dart' show DrawWidget;
import 'package:flutter/material.dart';

class DrawModel extends FlutterFlowModel<DrawWidget> {
  ///  State fields for stateful widgets in this component.

  // Model for Drawer component.
  late DrawerModel drawerModel;

  @override
  void initState(BuildContext context) {
    drawerModel = createModel(context, () => DrawerModel());
  }

  @override
  void dispose() {
    drawerModel.dispose();
  }
}
