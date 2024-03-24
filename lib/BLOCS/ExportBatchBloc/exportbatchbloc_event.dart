part of 'exportbatchbloc_bloc.dart';

abstract class ExportbatchblocEvent extends Equatable {
  const ExportbatchblocEvent();

  @override
  List<Object> get props => [];
}

class ExportEvent extends ExportbatchblocEvent {}
