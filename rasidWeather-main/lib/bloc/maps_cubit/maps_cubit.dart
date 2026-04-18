import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../../data/model/base/api_response.dart';
import '../../data/repository/maps_repo.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  MapsCubit(this.mapsRepo) : super(MapsInitial());

  final MapsRepo mapsRepo;

  Future<void> getRainViewerMaps() async {
    emit(MapsLoading());
    final ApiResponse apiResponse = await mapsRepo.getRainViewerMaps();
    if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
    } else {
      emit(MapsError(apiResponse.error.toString()));
    }
  }
}
