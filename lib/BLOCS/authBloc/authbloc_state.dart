import 'package:equatable/equatable.dart';

class AuthblocState extends Equatable {
  @override
  List<Object> get props => [];
}

class AuthblocInitial extends AuthblocState {}

class AuthblocLoadingState extends AuthblocState {}

class AuthblocErrorState extends AuthblocState {
  AuthblocErrorState(this.errorMessage);
  final String errorMessage;
  @override
  List<Object> get props => [errorMessage];
}

class AuthblocSuccessState extends AuthblocState {}
