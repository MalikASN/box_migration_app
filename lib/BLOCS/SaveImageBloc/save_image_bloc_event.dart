import 'dart:convert';

import 'package:equatable/equatable.dart';

class SaveImage extends Equatable {
  const SaveImage();

  @override
  List<Object> get props => [];
}

class SaveimageEvent extends SaveImage {
  final String barcode;
  final String geolocalisation;
  final String description;

  SaveimageEvent(this.barcode, this.geolocalisation, this.description);
}
