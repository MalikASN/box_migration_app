import 'dart:io';

import 'package:box_migration_app/BLOCS/ExportBatchBloc/exportbatchbloc_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:path_provider/path_provider.dart';
import 'BLOCS/SaveImageBloc/save_image_bloc_bloc.dart';
import 'BLOCS/SaveImageBloc/save_image_bloc_state.dart';
import 'BLOCS/authBloc/authbloc_bloc.dart';
import 'BLOCS/authBloc/authbloc_state.dart';
import 'BLOCS/checkBoxBloc/bloc/checkbox_bloc.dart';
import 'BLOCS/searchBloc/searchbloc_bloc.dart';
import 'BLOCS/searchBloc/searchbloc_state.dart';
import 'flutter_flow/flutter_flow_theme.dart';
import 'flutter_flow/flutter_flow_util.dart';
import 'flutter_flow/internationalization.dart';
import 'flutter_flow/nav/nav.dart';
import 'index.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import "HELPERS/db_class.dart";
import 'package:shared_preferences/shared_preferences.dart';

Future<String> createFolderInAppDocDir(String folderName) async {
  //Get this App Document Directory

  final Directory _appDocDir = await getApplicationDocumentsDirectory();

  //App Document Directory + folder name

  final Directory _appDocDirFolder =
      Directory('${_appDocDir.path}/$folderName/');

  if (await _appDocDirFolder.exists()) {
    //if folder already exists return path

    return _appDocDirFolder.path;
  } else {
    //if folder not exists create folder and then return its path

    final Directory _appDocDirNewFolder =
        await _appDocDirFolder.create(recursive: true);

    return _appDocDirNewFolder.path;
  }
}

void main() async {
  // Initialize SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  DbHelper dbHelper = new DbHelper();
  dbHelper.initDatabase();
  // Check if batchNumber is empty and set default value if necessary
  if (prefs.getString("batchNumber")?.isEmpty ?? true) {
    prefs.setString('batchNumber', "Z6_1");
  }

  if (prefs.getString("IP")?.isEmpty ?? true) {
    prefs.setString('IP', "http://192.165.1.35");
  }
  // Initialize dotenv and FlutterFlowTheme
  await dotenv.load(fileName: "assets/.env");
  await FlutterFlowTheme.initialize();

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Run the application
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>()!;
}

class _MyAppState extends State<MyApp> {
  Locale? _locale;
  ThemeMode _themeMode = FlutterFlowTheme.themeMode;

  late AppStateNotifier _appStateNotifier;
  late GoRouter _router;

  @override
  void initState() {
    super.initState();
    _appStateNotifier = AppStateNotifier.instance;
    _router = createRouter(_appStateNotifier);
  }

  void setLocale(String language) {
    setState(() => _locale = createLocale(language));
  }

  void setThemeMode(ThemeMode mode) => setState(() {
        _themeMode = mode;
        FlutterFlowTheme.saveThemeMode(mode);
      });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AuthBloc(AuthblocInitial())),
          BlocProvider(
              create: (context) => SaveImageBlocBloc(SaveImageInitial())),
          BlocProvider(create: (context) => SearchBloc(SearchBlocInitial())),
          BlocProvider(create: (context) => CheckboxBloc(CheckboxInitial())),
          BlocProvider(
              create: (context) =>
                  ExportbatchblocBloc(ExportbatchblocInitial())),
        ],
        child: MaterialApp.router(
          title: 'BoxMigrationApp',
          localizationsDelegates: [
            FFLocalizationsDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          locale: _locale,
          supportedLocales: const [Locale('en', '')],
          theme: ThemeData(brightness: Brightness.light),
          darkTheme: ThemeData(brightness: Brightness.dark),
          themeMode: _themeMode,
          routerConfig: _router,
        ));
  }
}
