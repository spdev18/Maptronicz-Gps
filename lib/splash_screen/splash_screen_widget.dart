import '/backend/api_requests/api_calls.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/actions/index.dart' as actions;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'splash_screen_model.dart';
export 'splash_screen_model.dart';

class SplashScreenWidget extends StatefulWidget {
  const SplashScreenWidget({super.key});

  @override
  State<SplashScreenWidget> createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  late SplashScreenModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => SplashScreenModel());

    // On page load action.
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      if (FFAppState().userApiKey != '') {
        _model.checkProperLogin =
            await PhpApiGroupGroup.fnConnectLOGINTRACKINGApiCall.call(
          username: FFAppState().userName,
          password: FFAppState().password,
        );

        if (((_model.checkProperLogin?.bodyText ?? '') == 'LOGIN_TRACKING') ||
            ((_model.checkProperLogin?.bodyText ?? '') == 'LOGIN_CPANEL')) {
          _model.initialDeviceDataRes =
              await PhpApiGroupGroup.testLargeDeviceCall.call(
            apiKey: FFAppState().userApiKey,
            fv: 'total',
          );

          if ((_model.initialDeviceDataRes?.succeeded ?? true)) {
            FFAppState().allDeviceData =
                (_model.initialDeviceDataRes?.jsonBody ?? '');
            safeSetState(() {});

            context.goNamed(
              'CarListScreen',
              extra: <String, dynamic>{
                kTransitionInfoKey: const TransitionInfo(
                  hasTransition: true,
                  transitionType: PageTransitionType.rightToLeft,
                ),
              },
            );

            if (FFAppState().isDarkMode) {
              setDarkModeSetting(context, ThemeMode.dark);
            } else {
              setDarkModeSetting(context, ThemeMode.light);
            }
          } else {
            FFAppState().userApiKey = '';
            safeSetState(() {});
            await actions.onesignalLogout(
              FFAppState().userName,
            );

            context.goNamed('LoginScreen');
          }

          await actions.inAppUpdate();
        } else {
          FFAppState().userApiKey = '';
          safeSetState(() {});
          await actions.onesignalLogout(
            FFAppState().userName,
          );

          context.goNamed('LoginScreen');
        }
      } else {
        context.goNamed('LoginScreen');
      }
    });
  }

  @override
  void dispose() {
    _model.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    context.watch<FFAppState>();

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            color: FlutterFlowTheme.of(context).secondaryBackground,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset(
                  'assets/images/Maptronicz_Logo.png',
                  width: 215.0,
                  height: 154.0,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
