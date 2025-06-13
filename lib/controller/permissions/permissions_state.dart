part of 'permissions_cubit.dart';

sealed class PermissionsState extends Equatable {
  const PermissionsState();
}

final class PermissionsInitial extends PermissionsState {
  @override
  List<Object> get props => [];
}

final class MapLockLoadingState extends PermissionsState {
  @override
  List<Object> get props => [];
}

final class MapLockSuccessState extends PermissionsState {
  final bool isMapEnabled;
  final String? message;

  const MapLockSuccessState({required this.isMapEnabled, this.message});

  @override
  List<Object> get props => [isMapEnabled, message ?? ''];
}

final class MapLockErrorState extends PermissionsState {
  final String error;

  const MapLockErrorState({required this.error});

  @override
  List<Object> get props => [error];
}

final class MapLockUpdateSuccessState extends PermissionsState {
  final bool isMapEnabled;

  const MapLockUpdateSuccessState({required this.isMapEnabled});

  @override
  List<Object> get props => [isMapEnabled];
}
