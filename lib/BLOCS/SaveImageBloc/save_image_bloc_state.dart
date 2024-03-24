import 'package:equatable/equatable.dart';

class SaveImageState extends Equatable {
  @override
  List<Object> get props => [];
}

class SaveImageInitial extends SaveImageState {}

class SaveImageLoading extends SaveImageState {}

class SaveImageError extends SaveImageState {
  SaveImageError(this.errorMessage);
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

class SaveImageSuccess extends SaveImageState {}
