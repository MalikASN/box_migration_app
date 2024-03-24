import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object> get props => [];
}

class SearchBox extends SearchEvent {
  final String searchContent;

  SearchBox(this.searchContent);
}
