import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../HELPERS/db_class.dart';

part 'checkbox_event.dart';
part 'checkbox_state.dart';

//DbHelper dbHelper = new DbHelper("assets/csv/boxes.csv");

class CheckboxBloc extends Bloc<CheckboxEvent, CheckboxState> {
  CheckboxBloc(checkboxInitial) : super(CheckboxInitial()) {
    on<CheckEvent>((event, emit) async {
      try {
        emit(CheckboxLoading());
        DbHelper dbHelper = new DbHelper();
        bool res = await dbHelper.checkBoxExistance(event.boxBarcode);
        if (res) {
          emit(CheckboxSucess(event.boxBarcode));
        } else {
          emit(CheckboxContinue(event.boxBarcode));
        }
      } catch (e) {
        emit(CheckboxError(e.toString()));
      }
    });
  }
}

Future<String> getData(barcode) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var url = Uri.parse("${prefs.get('IP')}/PHPServer/barcode_search.php");
  var request = http.Request('POST', url);
  print(url);
  request.bodyFields = {
    "keyword": barcode,
  };
  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();
  dynamic data = await response.stream.bytesToString();
  Map<String, dynamic> jsonData = jsonDecode(data);

  if (jsonData.containsValue("success")) {
    return "success";
  } else if (jsonData.containsValue("no matching")) {
    return "no matching";
  } else if (jsonData.containsValue("error")) {
    throw new Exception(jsonData['error']);
  }
  return "";
  // Parse the JSON response into a Map
}
