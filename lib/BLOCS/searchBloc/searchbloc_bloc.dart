import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'searchbloc_event.dart';
part 'searchbloc_state.dart';

class SearchblocBloc extends Bloc<SearchblocEvent, SearchblocState> {
  SearchblocBloc() : super(SearchblocInitial());

  @override
  Stream<SearchblocState> mapEventToState(
    SearchblocEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
