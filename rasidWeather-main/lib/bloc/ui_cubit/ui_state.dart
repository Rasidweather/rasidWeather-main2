part of 'ui_cubit.dart';

abstract class UiState extends Equatable {
  const UiState();
  
  @override
  bool get stringify => true;
}

class UiInitial extends UiState {
  const UiInitial();
  
  @override
  List<Object> get props => const <Object>[];
}

class UiThemeChanged extends UiState {
  const UiThemeChanged(this.colorModel);
  
  final Appearance colorModel;

  @override
  List<Object> get props => <Object>[colorModel];
  
  UiThemeChanged copyWith({
    Appearance? colorModel,
  }) {
    return UiThemeChanged(
      colorModel ?? this.colorModel,
    );
  }
}
