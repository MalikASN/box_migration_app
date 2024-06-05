import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:bloc/bloc.dart';
import 'package:box_migration_app/BLOCS/SaveImageBloc/save_image_bloc_event.dart';
import 'package:box_migration_app/BLOCS/SaveImageBloc/save_image_bloc_state.dart';
import 'package:box_migration_app/BLOCS/searchBloc/searchbloc_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../../HELPERS/db_class.dart';

//DbHelper dbHelper = new DbHelper("assets/csv/boxes.csv");

class SaveImageBlocBloc extends Bloc<SaveImage, SaveImageState> {
  SaveImageBlocBloc(SaveImageInitial saveImageInitial)
      : super(SaveImageInitial()) {
    on<SaveimageEvent>((event, emit) async {
      try {
        emit(SaveImageLoading());
        DbHelper dbHelper = DbHelper("assets/csv/boxes.csv");
        final Directory fixedDir = await getApplicationDocumentsDirectory();

        Directory targetDir = Directory("${fixedDir.path}/boxImgs");

        final file =
            File('${targetDir.path}/${event.barcode}_${event.geolocalisation}');

        Uint8List listInt = await compressImg(event.file.bytes!);
        await file.writeAsBytes(listInt);
        await dbHelper.inserRow(event.barcode, event.geolocalisation);

        emit(SaveImageSuccess());
      } catch (e) {
        emit(SaveImageError(e.toString()));
      }
    });
  }
}

Future<Uint8List> compressImg(Uint8List list) async {
  var result = await FlutterImageCompress.compressWithList(list, quality: 50);
  return result;
}
