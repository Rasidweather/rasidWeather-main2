part of 'splash_cubit.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => <Object>[];
}

class SplashDone extends SplashState {
  const SplashDone({
    required this.isIntroPageDone,
    required this.isLanguageSelectionDone,
  });
  final bool isIntroPageDone;
  final bool isLanguageSelectionDone;
  @override
  List<Object> get props => <Object>[isIntroPageDone, isLanguageSelectionDone];
}

class IntroDone extends SplashState {
  const IntroDone({required this.isIntroPageDone});
  final bool isIntroPageDone;
  @override
  List<Object> get props => <Object>[isIntroPageDone];
}

class LanguageSelectionDone extends SplashState {
  const LanguageSelectionDone({required this.isLanguageSelectionDone});
  final bool isLanguageSelectionDone;
  @override
  List<Object> get props => <Object>[isLanguageSelectionDone];
}

class SplashError extends SplashState {
  const SplashError(this.message);
  final String message;
  @override
  List<Object> get props => <Object>[message];
}
