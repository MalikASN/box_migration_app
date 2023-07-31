import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'download_images_bloc_event.dart';
part 'download_images_bloc_state.dart';

class DownloadImagesBlocBloc
    extends Bloc<DownloadImagesBlocEvent, DownloadImagesBlocState> {
  DownloadImagesBlocBloc() : super(DownloadImagesBlocInitial()) {
    on<DownloadImagesBlocEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
