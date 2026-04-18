part of 'profile_cubit.dart';

@immutable
abstract class ProfileState extends Equatable {
  @override
  List<Object?> get props => <Object?>[];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  ProfileSuccess(this.profile);
  final UserModel profile;
  
  @override
  List<Object?> get props => <Object?>[profile];
}

class ProfileError extends ProfileState {
  ProfileError(this.error);
  final String error;
  
  @override
  List<Object?> get props => <Object?>[error];
}
