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
        Map<String, String> imgMap = await getDirImgs("boxImgs");
        var headers = {'Content-Type': 'application/json'};
        SharedPreferences prefs = await SharedPreferences.getInstance();
        var url = Uri.parse("${prefs.get('IP')}/PHPServer/box_save2.php");
        var request = http.Request('POST', url);
        // Prepare the data as a POST request body

        request.body = jsonEncode(imgMap);

        request.headers.addAll(headers);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          await emptyDir("boxImgs");
          emit(ExportbatchblocFinished());
        } else {
          throw Exception("HTTP Request Error: ${response.statusCode}");
        }
      } catch (e) {
        emit(ExportbatchblocError(e.toString()));
      }
    });
  }
}

Future<Map<String, String>> getDirImgs(String givenDir) async {
  Directory fixedDir = await getApplicationDocumentsDirectory();
  Directory dir = Directory("${fixedDir.path}/$givenDir");

  Map<String, String> imageMap = {};

  await for (var imgFile in dir.list()) {
    if (imgFile is File) {
      List<int> imgBytes = await imgFile.readAsBytes();
      String base64Img = base64Encode(imgBytes);
      imageMap[imgFile.uri.pathSegments.last] = base64Img;
    }
  }

  return imageMap;
}

bool _isImage(FileSystemEntity entity) {
  final List<String> imageExtensions = [
    '.jpg',
    '.jpeg',
    '.png',
    '.gif',
    '.bmp'
  ];
  return imageExtensions.contains(entity.uri.pathSegments.last.toLowerCase());
}

Future<void> emptyDir(String dirname) async {
  final Directory fixeddir = await getApplicationDocumentsDirectory();
  Directory targetDir = Directory("${fixeddir.path}/$dirname");

  if (await targetDir.exists()) {
    await for (var entity in targetDir.list()) {
      if (entity is File) {
        await entity.delete();
      } else if (entity is Directory) {
        await entity.delete(recursive: true);
      }
    }
  }
}
