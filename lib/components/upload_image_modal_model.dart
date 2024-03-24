import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UploadImageModalModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this component.

  final formKey = GlobalKey<FormState>();
  bool isDataUploading = false;
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // State field(s) for TextField widget.
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  var geolocationController;
  String? _textControllerValidator(BuildContext context, String? val) {
    if (val == null || val.isEmpty) {
      return 'Ce champ est requis';
    }

    if (!RegExp('^[A-Z]+-[0-9]{6}\$').hasMatch(val)) {
      return 'Code barres invalide';
    }
    return null;
  }

  /// Initialization and disposal methods.

  void initState(BuildContext context) {
    textControllerValidator = _textControllerValidator;
  }

  void dispose() {
    textController?.dispose();
  }

  void resetForm() {
    textControllerValidator = _textControllerValidator;
    textController?.text = "";
    uploadedLocalFile = FFUploadedFile(
      name: null,
      bytes: Uint8List.fromList([]),
      height: null,
      width: null,
      blurHash: null,
    );
  }

  String? geolocValidator(String value) {
    if (value!.isEmpty) {
      return 'Ce champ est requis';
    } else {
      return null; // Return null if the input is valid
    }
  }
}
  /// Action blocks are added here.

  /// Additional helper methods are added here.

