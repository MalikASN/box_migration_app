part of 'checkbox_bloc.dart';

abstract class CheckboxEvent extends Equatable {
  const CheckboxEvent();

  @override
  List<Object> get props => [];
}

class CheckEvent extends CheckboxEvent {
  final String boxBarcode;
  CheckEvent({required this.boxBarcode});
}
