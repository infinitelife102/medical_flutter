
import 'package:bloc/bloc.dart';
import 'package:dr_ai/data/source/firebase/firebase_service.dart';
import 'package:equatable/equatable.dart';

part 'permissions_state.dart';

class PermissionsCubit extends Cubit<PermissionsState> {
  PermissionsCubit() : super(PermissionsInitial());

  Future<void> checkMapLockStatus() async {
    emit(MapLockLoadingState());
    try {
      List res = await FirebaseService.checkMapLockStatus();
      emit(MapLockSuccessState(isMapEnabled: res[0], message: res[1]));
    } catch (error) {
      emit(MapLockErrorState(error: error.toString()));
    }
  }
}
