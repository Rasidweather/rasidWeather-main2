import 'package:equatable/equatable.dart';

abstract class BaseState extends Equatable {

  const BaseState({
    this.refresh = false,
    this.isLoading = false,
    this.error,
  });
  final bool isLoading;
  final bool refresh;
  final String? error;

  BaseState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
  });

  @override
  List<Object?> get props => <Object?>[isLoading, refresh,error];
}
