import 'dart:convert';
import 'dart:io';

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
        DbHelper dbHelper = DbHelper();
        await dbHelper.inserRow(
            event.barcode, event.geolocalisation, event.description);

        emit(SaveImageSuccess());
      } catch (e) {
        emit(SaveImageError(e.toString()));
      }
    });
  }
}
