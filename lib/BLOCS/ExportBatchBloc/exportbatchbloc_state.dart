part of 'exportbatchbloc_bloc.dart';

abstract class ExportbatchblocState extends Equatable {
  const ExportbatchblocState();

  @override
  List<Object> get props => [];
}

class ExportbatchblocInitial extends ExportbatchblocState {}

class ExportbatchblocLoading extends ExportbatchblocState {}

class ExportbatchblocFinished extends ExportbatchblocState {}

class ExportbatchblocError extends ExportbatchblocState {
  final String errorMsg;

  ExportbatchblocError(this.errorMsg);

  @override
  List<Object> get props => [errorMsg];
}
