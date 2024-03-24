import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:box_migration_app/HELPERS/db_class.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'exportbatchbloc_event.dart';
part 'exportbatchbloc_state.dart';

class ExportbatchblocBloc
    extends Bloc<ExportbatchblocEvent, ExportbatchblocState> {
  ExportbatchblocBloc(ExportbatchblocInitial exportbatchblocInitial)
      : super(ExportbatchblocInitial()) {
    on<ExportEvent>((event, emit) async {
      emit(ExportbatchblocLoading());
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        DbHelper dbHelper = new DbHelper();
        List<Map<String, dynamic>> boxes = (await dbHelper.getAllBoxes());
        print(boxes);
        var headers = {'Content-Type': 'application/json'};
        var url = Uri.parse("${prefs.get('IP')}/PHPServer/box_saveZ6.php");
        var request = http.Request('POST', url);
        // Prepare the data as a POST request body

        request.body = jsonEncode(boxes);

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          emit(ExportbatchblocFinished());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          if (prefs.getString("batchNumber").toString().isNotEmpty) {
            int num = int.parse(prefs
                    .getString("batchNumber")!
                    .substring(prefs.getString("batchNumber")!.length - 1)) +
                1;
            String newBatch = "Z6_" + num.toString();

            prefs.setString('batchNumber', newBatch);
          }
        } else {
          throw Exception("HTTP Request Error: ${response.statusCode}");
        }
      } catch (e) {
        emit(ExportbatchblocError(e.toString()));
      }
    });
  }
}
