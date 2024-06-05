import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:box_migration_app/BLOCS/ExportBatchBloc/exportbatchbloc_bloc.dart';
import 'package:box_migration_app/BLOCS/checkBoxBloc/bloc/checkbox_bloc.dart';
import 'package:box_migration_app/HELPERS/db_class.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
//import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../BLOCS/SaveImageBloc/save_image_bloc_bloc.dart';
import '../BLOCS/SaveImageBloc/save_image_bloc_event.dart';
import '../BLOCS/SaveImageBloc/save_image_bloc_state.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import '/flutter_flow/upload_data.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'barcode_scanner.dart';
import 'upload_image_modal_model.dart';
export 'upload_image_modal_model.dart';

class UploadImageModalWidget extends StatefulWidget {
  @override
  _UploadImageModalWidgetState createState() => _UploadImageModalWidgetState();
}

class _UploadImageModalWidgetState extends State<UploadImageModalWidget> {
  late UploadImageModalModel _model;
  String isSaved = "none";
  bool isLoading = false;
  bool isboxCheckerror = false;
  double modalHeight = 700;
  String containerContent = "";
  bool isBoxExisting = false;
  int doneBoxes = 0;
  int progression = 0;
  int batchSize = 200;
  final TextEditingController geolocController = TextEditingController();

  final _barcodeScanner = BarcodeScanner();

  bool isTransferred = false;

  String exportMsg = "Transferer";
  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  Future<int> getNumOfImgs(String dir) async {
    final Directory fixedDir = await getApplicationDocumentsDirectory();

    Directory targetDir = Directory("${fixedDir.path}/$dir");
    int numOfImgsInside = await targetDir.list(recursive: false).length;
    return numOfImgsInside;
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => UploadImageModalModel());
    _model.textController ??= TextEditingController();
    _barcodeScanner.initializeCamera();

    _initializeState(); // Just call the method directly, no need to store the future
  }

  void _initializeState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String bs = prefs.get("batchSize").toString();
    if (bs.isNotEmpty) {
      setState(() {
        batchSize = int.parse(bs);
      });
    }
    getNumOfImgs("boxImgs");
  }

  Future<void> takePicture() async {
    final selectedMedia = await selectMedia(
      multiImage: false,
    );

    if (selectedMedia != null &&
        selectedMedia
            .every((m) => validateFileFormat(m.storagePath, context))) {
      _model.isDataUploading = true;
      var selectedUploadedFiles = <FFUploadedFile>[];

      try {
        selectedUploadedFiles = selectedMedia
            .map((m) => FFUploadedFile(
                  name: m.filePath,
                  bytes: m.bytes,
                  height: m.dimensions?.height,
                  width: m.dimensions?.width,
                  blurHash: m.blurHash,
                ))
            .toList();
      } finally {
        _model.isDataUploading = false;
      }

      if (selectedUploadedFiles.isNotEmpty) {
        setState(() {
          _model.uploadedLocalFile = selectedUploadedFiles.first;
        });
      }
    }
  }

  @override
  void dispose() {
    _model.maybeDispose();
    _barcodeScanner.dispose();
    super.dispose();
  }

  Future<String> _onScanButtonPressed() async {
    final barcode = await _barcodeScanner.scanBarcode();
    return barcode;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(0.0),
          bottomRight: Radius.circular(0.0),
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      child: Container(
        width: double.infinity,
        height: modalHeight,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0.0),
            bottomRight: Radius.circular(0.0),
            topLeft: Radius.circular(16.0),
            topRight: Radius.circular(16.0),
          ),
        ),
        child: isTransferred
            ? Center(
                child: Container(
                child: Column(
                  children: [
                    BlocListener<ExportbatchblocBloc, ExportbatchblocState>(
                      listener: (context, state) {
                        if (state is ExportbatchblocLoading) {
                          setState(() {
                            isLoading = true;
                          });
                        }

                        if (state is ExportbatchblocFinished) {
                          setState(() {
                            isLoading = false;
                            isTransferred = false;
                            progression = 0;
                            modalHeight = 700;
                            doneBoxes = 0;
                          });
                          // getNumOfImgs("ImgsBatch");
                        }
                        if (state is ExportbatchblocError) {
                          setState(() {
                            isLoading = false;
                            exportMsg = state.errorMsg.toString();
                          });
                        }
                      },
                      child: Container(),
                    ),
                    Padding(
                      padding:
                          EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 0.0, 0.0),
                      child: Text(
                        'Transferez votre lot',
                        textAlign: TextAlign.start,
                        style: FlutterFlowTheme.of(context).headlineMedium,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 50),
                      child: ListTile(
                        title: Text(
                          "Lot en cours",
                          style: TextStyle(
                            fontSize: 20, // You can adjust the font size here
                            fontWeight: FontWeight
                                .w500, // You can adjust the font weight here
                          ),
                        ),
                        subtitle: Text(
                          "$doneBoxes/$batchSize",
                          style: TextStyle(
                            fontSize: 18, // You can adjust the font size here
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: AlignmentDirectional(0.0, 200.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          FFButtonWidget(
                            onPressed: () async {
                              if (isLoading) {
                                return;
                              }
                              if (exportMsg != "Transferer") {
                                return;
                              }
                              if (isTransferred) {
                                // savingLogic

                                context
                                    .read<ExportbatchblocBloc>()
                                    .add(ExportEvent());
                              }
                            },
                            text: isLoading
                                ? "Patientez..."
                                : isTransferred
                                    ? exportMsg
                                    : "Enregister",
                            showLoadingIndicator: isLoading,
                            options: FFButtonOptions(
                              width: 366.0,
                              height: 50.0,
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              iconPadding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 0.0, 0.0, 0.0),
                              color: !isTransferred
                                  ? FlutterFlowTheme.of(context).primary
                                  : exportMsg.toString() == "Transferer"
                                      ? FlutterFlowTheme.of(context).success
                                      : FlutterFlowTheme.of(context).error,
                              textStyle: FlutterFlowTheme.of(context)
                                  .titleMedium
                                  .override(
                                    fontFamily: 'Readex Pro',
                                    color: Colors.white,
                                  ),
                              elevation: 3.0,
                              borderSide: BorderSide(
                                color: Colors.transparent,
                                width: 1.0,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ))
            : Form(
                key: _model.formKey,
                autovalidateMode: AutovalidateMode.always,
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      maxHeight: 500), // Change the value as needed
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        BlocListener<ExportbatchblocBloc, ExportbatchblocState>(
                          listener: (context, state) {
                            if (state is ExportbatchblocLoading) {
                              setState(() {
                                isLoading = true;
                              });
                            }

                            if (state is ExportbatchblocFinished) {
                              setState(() {
                                isLoading = false;
                                isTransferred = false;
                                progression = 0;
                                modalHeight = 700;
                                doneBoxes = 0;
                              });
                            }
                            if (state is ExportbatchblocError) {
                              setState(() {
                                isLoading = false;
                                exportMsg = state.errorMsg.toString();
                              });
                            }
                          },
                          child: Container(),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                  0.0, 12.0, 0.0, 0.0),
                              child: Container(
                                width: 50.0,
                                height: 4.0,
                                decoration: BoxDecoration(
                                  color: FlutterFlowTheme.of(context).alternate,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                              ),
                            ),
                          ],
                        ),
                        ListTile(
                          title: Text(
                            "Lot en cours",
                            style: TextStyle(
                              fontSize: 20, // You can adjust the font size here
                              fontWeight: FontWeight
                                  .w500, // You can adjust the font weight here
                            ),
                          ),
                          subtitle: Text(
                            "$doneBoxes/$batchSize",
                            style: TextStyle(
                              fontSize: 18, // You can adjust the font size here
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.send_and_archive_outlined,
                                color: Colors.white),
                            onPressed: () => {
                              if (doneBoxes > 0)
                                {
                                  context
                                      .read<ExportbatchblocBloc>()
                                      .add(ExportEvent())
                                }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                              16.0, 12.0, 0.0, 0.0),
                          child: Text(
                            'Enregistrer une boite',
                            textAlign: TextAlign.start,
                            style: FlutterFlowTheme.of(context).headlineMedium,
                          ),
                        ),
                        isSaved.compareTo("saved") == 0
                            ? Material(
                                color: Colors.transparent,
                                elevation: 3,
                                child: SizedBox(
                                    width: 400,
                                    height: 60,
                                    child: Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: FlutterFlowTheme.of(context)
                                              .secondary,
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                      child: Text(
                                        containerContent,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: 'Readex Pro',
                                            fontSize: 16),
                                      ),
                                    )),
                              )
                            : isSaved.compareTo("notsaved") == 0
                                ? Material(
                                    color: Colors.transparent,
                                    elevation: 3,
                                    child: SizedBox(
                                        width: 400,
                                        height: 60,
                                        child: Container(
                                          margin: EdgeInsets.all(10),
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color:
                                                  FlutterFlowTheme.of(context)
                                                      .error,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: Text(
                                            containerContent,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontFamily: 'Readex Pro',
                                                fontSize: 16),
                                          ),
                                        )),
                                  )
                                : Container(),
                        Align(
                          alignment: AlignmentDirectional(0.0, 0.0),
                          child: Padding(
                            padding: EdgeInsetsDirectional.fromSTEB(
                                10.0, 10.0, 10.0, 10.0),
                            child: Container(
                              width: double.infinity,
                              height: 211.0,
                              decoration: BoxDecoration(
                                color: FlutterFlowTheme.of(context)
                                    .secondaryBackground,
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4.0,
                                    color: Color(0x33000000),
                                    offset: Offset(0.0, 2.0),
                                  )
                                ],
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      splashColor: Colors.transparent,
                                      focusColor: Colors.transparent,
                                      hoverColor: Colors.transparent,
                                      highlightColor: Colors.transparent,
                                      onTap: () async {
                                        takePicture();
                                      },
                                      child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                          child: _model.uploadedLocalFile.bytes!
                                                  .isNotEmpty
                                              ? Image.memory(
                                                  _model
                                                      .uploadedLocalFile.bytes!,
                                                  width: 300.0,
                                                  height: 200.0,
                                                  fit: BoxFit.cover,
                                                )
                                              : Icon(Icons.add_a_photo,
                                                  size: 40)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 200.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 10.0), // Add padding for spacing
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  // Wrap the TextFormField with Expanded
                                  child: TextFormField(
                                    readOnly: true,
                                    controller: _model.textController,
                                    onChanged: (_) => EasyDebounce.debounce(
                                      '_model.textController',
                                      Duration(milliseconds: 2000),
                                      () => setState(() {}),
                                    ),
                                    autofocus: true,
                                    obscureText: false,
                                    decoration: InputDecoration(
                                      labelText: 'entrez code-barres...',
                                      labelStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      hintStyle: FlutterFlowTheme.of(context)
                                          .labelMedium,
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .alternate,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .primary,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      errorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      focusedErrorBorder: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                          color: FlutterFlowTheme.of(context)
                                              .error,
                                          width: 2.0,
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(8.0),
                                      ),
                                      suffixIcon: _model
                                              .textController!.text.isNotEmpty
                                          ? InkWell(
                                              onTap: () async {
                                                _model.textController?.clear();
                                                setState(() {});
                                              },
                                              child: Icon(
                                                Icons.clear,
                                                size: 22,
                                              ),
                                            )
                                          : null,
                                    ),
                                    style:
                                        FlutterFlowTheme.of(context).bodyMedium,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Ce champ est requis';
                                      }
                                      if (!RegExp('^[A-Z]+-[0-9]{6}\$')
                                              .hasMatch(val) &&
                                          !RegExp("^[A-Z]+[0-9]{5}\$")
                                              .hasMatch(val)) {
                                        return 'format invalide';
                                      }
                                      if (isBoxExisting) {
                                        return "Boite déja inserée";
                                      }
                                      if (isboxCheckerror) {
                                        return "impossible de verifier le code-barres";
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                IconButton(
                                  color: FlutterFlowTheme.of(context).primary,
                                  onPressed: () => {
                                    _onScanButtonPressed().then((val) => {
                                          context
                                              .read<CheckboxBloc>()
                                              .add(CheckEvent(boxBarcode: val))
                                        }),
                                  },
                                  icon: Icon(Icons.scanner),
                                ),
                              ],
                            ),
                          ),
                        ),
                        BlocListener<CheckboxBloc, CheckboxState>(
                            listener: (context, state) {
                              if (state is CheckboxSucess) {
                                setState(() {
                                  _model.textController.text = state.barcode;
                                  isBoxExisting = true;
                                  isboxCheckerror = false;
                                });
                              }
                              if (state is CheckboxError) {
                                setState(() {
                                  isboxCheckerror = true;
                                  isBoxExisting = false;
                                });
                              }
                              if (state is CheckboxContinue) {
                                _model.textController.text = state.barcode;
                                isBoxExisting = false;
                                isboxCheckerror = false;
                              }
                            },
                            child: Container()),
                        Align(
                          alignment: AlignmentDirectional(0.0, 200.0),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: 20.0,
                                horizontal: 10.0), // Add padding for spacing
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  // Wrap the TextFormField with Expanded
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      readOnly: true,
                                      controller: geolocController,
                                      onChanged: (_) => EasyDebounce.debounce(
                                        'geolocController',
                                        Duration(milliseconds: 2000),
                                        () => setState(() {}),
                                      ),
                                      autofocus: true,
                                      obscureText: false,
                                      decoration: InputDecoration(
                                        labelText:
                                            'entrez la geolocalisation...',
                                        labelStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        hintStyle: FlutterFlowTheme.of(context)
                                            .labelMedium,
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .alternate,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .primary,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        focusedErrorBorder:
                                            UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            color: FlutterFlowTheme.of(context)
                                                .error,
                                            width: 2.0,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        suffixIcon:
                                            geolocController.text.isNotEmpty
                                                ? InkWell(
                                                    onTap: () async {
                                                      geolocController?.clear();
                                                      setState(() {});
                                                    },
                                                    child: Icon(
                                                      Icons.clear,
                                                      size: 22,
                                                    ),
                                                  )
                                                : null,
                                      ),
                                      style: FlutterFlowTheme.of(context)
                                          .bodyMedium,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'Ce champ est requis';
                                        }
                                        if (value.length < 12) {
                                          return 'geolocalisation invalide';
                                        }
                                        /*if (!RegExp(
                                                '^[A-Z]+-[A-Z][1-9]+-[A-Z][1-9]+-[A-Z]+[1-9]+-[A-Z][1-9]+-[A-Z][1-9]+\$')
                                            .hasMatch(value)) {
                                          return "format invalide";
                                        }*/
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                IconButton(
                                  color: FlutterFlowTheme.of(context).primary,
                                  onPressed: () => {
                                    _onScanButtonPressed()
                                        .then((val) => setState(() {
                                              geolocController.text = val;
                                            })),
                                  },
                                  icon: Icon(Icons.scanner),
                                ),
                                BlocListener<SaveImageBlocBloc, SaveImageState>(
                                    listener: (context, state) async {
                                      if (state is SaveImageSuccess) {
                                        int numboxes =
                                            await getNumOfImgs("boxImgs");

                                        if (numboxes == batchSize) {
                                          setState(() {
                                            modalHeight = 250;
                                            isTransferred = true;
                                          });
                                        } else {
                                          takePicture();
                                        }

                                        setState(() {
                                          doneBoxes = numboxes;
                                          isLoading = false;
                                          containerContent = "La boîte " +
                                              _model.textController.text +
                                              " a été enregistrée.";
                                          modalHeight = 700.0;
                                          isSaved = "saved";
                                          _model.textController?.clear();
                                          _model.uploadedLocalFile =
                                              FFUploadedFile(
                                            name: null,
                                            bytes: Uint8List.fromList([]),
                                            height: null,
                                            width: null,
                                            blurHash: null,
                                          );
                                        });

                                        const bannerDuration =
                                            Duration(milliseconds: 3000);
                                        Timer(bannerDuration, () {
                                          setState(() {
                                            containerContent = "";
                                            isSaved = "none";
                                          });
                                        });
                                      }

                                      if (state is SaveImageError) {
                                        isLoading = false;
                                        isSaved = "notsaved";
                                        containerContent =
                                            state.errorMessage.toString();
                                      }
                                    },
                                    child: Container()),
                              ],
                            ),
                          ),
                        ),
                        Align(
                          alignment: AlignmentDirectional(0.0, 200.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              FFButtonWidget(
                                onPressed: () async {
                                  if (isLoading) {
                                    return;
                                  }
                                  if (isTransferred) {
                                    // savingLogic
                                    context
                                        .read<ExportbatchblocBloc>()
                                        .add(ExportEvent());
                                  } else {
                                    if (_model.formKey.currentState!
                                        .validate()) {
                                      setState(() {
                                        isLoading = true;
                                      });

                                      context.read<SaveImageBlocBloc>().add(
                                          SaveimageEvent(
                                              _model.textController.text,
                                              geolocController.text,
                                              _model.uploadedLocalFile));
                                    }

                                    if (_model.formKey.currentState == null ||
                                        !_model.formKey.currentState!
                                            .validate()) {
                                      return;
                                    }
                                  }
                                },
                                text: isLoading && isTransferred
                                    ? "$progression%"
                                    : isLoading && !isTransferred
                                        ? "patientez..."
                                        : isTransferred
                                            ? exportMsg
                                            : "Enregister",
                                showLoadingIndicator: isLoading,
                                options: FFButtonOptions(
                                  width: 366.0,
                                  height: 50.0,
                                  padding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  iconPadding: EdgeInsetsDirectional.fromSTEB(
                                      0.0, 0.0, 0.0, 0.0),
                                  color: !isTransferred
                                      ? FlutterFlowTheme.of(context).primary
                                      : exportMsg.toString() == "Transferer"
                                          ? FlutterFlowTheme.of(context)
                                              .alternate
                                          : FlutterFlowTheme.of(context).error,
                                  textStyle: FlutterFlowTheme.of(context)
                                      .titleMedium
                                      .override(
                                        fontFamily: 'Readex Pro',
                                        color: Colors.white,
                                      ),
                                  elevation: 3.0,
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
