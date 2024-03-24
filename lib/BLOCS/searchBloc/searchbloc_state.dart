import 'package:equatable/equatable.dart';

import 'boxModel.dart';

class SearchBlocState extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchBlocInitial extends SearchBlocState {}

class SearchBlocLoading extends SearchBlocState {}

class SearchBlocError extends SearchBlocState {
  SearchBlocError(this.errorMessage);
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

class SearchBlocSuccess extends SearchBlocState {
  final List<Box> boxes;

  SearchBlocSuccess(this.boxes);
  @override
  List<Object> get props => [boxes];
}
