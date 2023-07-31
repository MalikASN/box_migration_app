import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'save_image_bloc_event.dart';
part 'save_image_bloc_state.dart';

class SaveImageBlocBloc extends Bloc<SaveImageBlocEvent, SaveImageBlocState> {
  SaveImageBlocBloc() : super(SaveImageBlocInitial()) {
    on<SaveImageBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
