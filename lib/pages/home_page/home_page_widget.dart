import 'package:flutter_bloc/flutter_bloc.dart';

import '../../BLOCS/searchBloc/searchbloc_bloc.dart';
import '../../BLOCS/searchBloc/searchbloc_event.dart';
import '../../BLOCS/searchBloc/searchbloc_state.dart';
import '/components/upload_image_modal_widget.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

class HomePageWidget extends StatefulWidget {
  const HomePageWidget({Key? key}) : super(key: key);

  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  TextEditingController? textsearch;
  late HomePageModel _model;
  late UploadImageModalModel _uploadModel;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());
    textsearch = TextEditingController();

    // Add a post-frame callback to show the modal after the widget is built
    /* WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showModal();
    });*/
  }

  @override
  void dispose() {
    _model.dispose();
    textsearch?.dispose();
    super.dispose();
  }

  void _showModal() async {
    await showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      enableDrag: false,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
          child: Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: UploadImageModalWidget(),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(_model.unfocusNode),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).primary,
          automaticallyImplyLeading: false,
          title: Text(
            'Migration App Z6',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  color: Colors.white,
                  fontSize: 22.0,
                ),
          ),
          actions: [
            IconButton(
                onPressed: () => {context.go("/loginPage")},
                icon: Icon(Icons.logout, color: Colors.white))
          ],
          centerTitle: false,
          elevation: 2.0,
        ),
        body: SafeArea(
          top: true,
          child: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: FlutterFlowTheme.of(context).secondaryBackground,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(0.0, 20.0, 0.0, 0.0),
                  child: Container(
                    width: 400.0,
                    height: 100.0,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 30.0),
                          // Add padding for spacing
                          child: Container(
                            child: Material(
                              borderRadius: BorderRadius.circular(10),
                              elevation: 4, // Set the elevation here
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding: EdgeInsets.only(left: 10),
                                      child: TextFormField(
                                        controller: textsearch,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          labelText: "  rechercher une boite",
                                        ),
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            return "Ce champ est requis";
                                          }
                                          return null; // Return null if the input is valid
                                        },
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => {
                                      context
                                          .read<SearchBloc>()
                                          .add(SearchBox(textsearch.text))
                                    },
                                    icon: Icon(
                                      Icons.search,
                                      color:
                                          FlutterFlowTheme.of(context).primary,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<SearchBloc, SearchBlocState>(
                  builder: (context, state) {
                    if (state is SearchBlocLoading) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: FlutterFlowTheme.of(context).primary));
                    }
                    if (state is SearchBlocSuccess) {
                      return Expanded(
                        child: ListView.builder(
                          itemExtent: 80,
                          padding: EdgeInsets.all(10),
                          shrinkWrap: true,
                          itemCount: state.boxes
                              .length, // Set this to the actual number of items you want to display
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text("${state.boxes[index].barcode}"),
                              subtitle: Text(
                                  state.boxes[index].description.toString()),
                              leading: Image.asset(
                                'assets/images/group-box.png',
                              ),
                              trailing: Text(state.boxes[index].geolocation
                                  .toString()), // Replace with your item text
                              // Add any other ListTile properties you need here
                            );
                          },
                        ),
                      );
                    }
                    if (state is SearchBlocError) {
                      return Center(
                          child: Text(
                              "Impossible de récupérer le résultat de la recherche."));
                    }
                    return Container();
                  },
                ),
                Align(
                  alignment: AlignmentDirectional(1.0, 1.0),
                  child: Padding(
                    padding:
                        EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 10.0, 10.0),
                    child: FlutterFlowIconButton(
                      borderColor: FlutterFlowTheme.of(context).primary,
                      borderRadius: 20.0,
                      borderWidth: 1.0,
                      buttonSize: 60.0,
                      fillColor: FlutterFlowTheme.of(context).primary,
                      icon: Icon(
                        Icons.document_scanner,
                        color: Colors.white,
                        size: 24.0,
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                          enableDrag: false,
                          context: context,
                          builder: (context) {
                            return GestureDetector(
                              onTap: () => FocusScope.of(context)
                                  .requestFocus(_model.unfocusNode),
                              child: Padding(
                                padding: MediaQuery.viewInsetsOf(context),
                                child: UploadImageModalWidget(),
                              ),
                            );
                          },
                        ).then((value) => setState(() {}));
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
