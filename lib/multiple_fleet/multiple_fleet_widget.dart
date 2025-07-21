import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart' as custom_widgets;
import 'package:flutter/material.dart';
import 'multiple_fleet_model.dart';
export 'multiple_fleet_model.dart';

class MultipleFleetWidget extends StatefulWidget {
  const MultipleFleetWidget({super.key});

  @override
  State<MultipleFleetWidget> createState() => _MultipleFleetWidgetState();
}

class _MultipleFleetWidgetState extends State<MultipleFleetWidget> {
  late MultipleFleetModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MultipleFleetModel());
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primary,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: custom_widgets.MultipleScreenTracking(
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
