part of 'checkbox_bloc.dart';

abstract class CheckboxState extends Equatable {
  const CheckboxState();

  @override
  List<Object> get props => [];
}

class CheckboxInitial extends CheckboxState {}

class CheckboxLoading extends CheckboxState {}

class CheckboxSucess extends CheckboxState {
  final String barcode;

  CheckboxSucess(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class CheckboxContinue extends CheckboxState {
  final String barcode;

  CheckboxContinue(this.barcode);

  @override
  List<Object> get props => [barcode];
}

class CheckboxError extends CheckboxState {
  final String errorMessage;

  CheckboxError(this.errorMessage);

  @override
  List<Object> get props => [errorMessage];
}
