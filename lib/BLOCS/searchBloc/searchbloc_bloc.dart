import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:bloc/bloc.dart';
import 'package:box_migration_app/BLOCS/searchBloc/searchbloc_event.dart';
import 'package:box_migration_app/BLOCS/searchBloc/searchbloc_state.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../authBloc/authbloc_state.dart';
import 'boxModel.dart';

class SearchBloc extends Bloc<SearchEvent, SearchBlocState> {
  SearchBloc(SearchBlocInitial searchBlocInitial) : super(SearchBlocInitial()) {
    on<SearchBox>((event, emit) async {
      try {
        if (event.searchContent.isEmpty) {
          emit(SearchBlocInitial());
        } else {
          emit(SearchBlocLoading());

          var response = await getData(event.searchContent);
          emit(SearchBlocSuccess(response));
        }
      } catch (e) {
        emit(SearchBlocError(e.toString()));
      }
    });
  }
}

Future<List<Box>> getData(searchContent) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
  var url = Uri.parse(
      "${prefs.get('IP')}/PHPServer/search_box.php"); // Url of the website where we get the data from.
  print(url);
  var request = http.Request('POST', url); // Now set our  request to POST
  request.bodyFields = {
    "keyword": searchContent,
  };
  request.headers.addAll(headers);
  http.StreamedResponse response = await request.send(); // Send request.

  try {
    if (response.statusCode == 200) {
      print("yesss");
      String jsonResponse = await response.stream.bytesToString();

      List<dynamic> data = jsonDecode(jsonResponse);

      List<Box> boxes = data.map<Box>((item) => Box.fromJson(item)).toList();
      return boxes;
    }
  } catch (e) {
    print("npp");
    print(e.toString());
  }
  return [];
}
