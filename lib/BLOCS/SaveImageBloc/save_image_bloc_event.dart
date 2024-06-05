import 'dart:convert';

import 'package:box_migration_app/flutter_flow/flutter_flow_util.dart';
import 'package:equatable/equatable.dart';

class SaveImage extends Equatable {
  const SaveImage();

  @override
  List<Object> get props => [];
}

class SaveimageEvent extends SaveImage {
  final String barcode;
  final String geolocalisation;
  final FFUploadedFile file;

  SaveimageEvent(this.barcode, this.geolocalisation, this.file);
}
