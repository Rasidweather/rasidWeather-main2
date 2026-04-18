import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../data/model/base/api_response.dart';
import '../../data/model/config_model.dart';
import '../../data/repository/splash_repo.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(this.splashRepo) : super(SplashInitial());
  bool maintenanceMode = false;

  final SplashRepo splashRepo;

  ConfigModel? _configModel;
  ConfigModel? get configModel => _configModel;

   void afterSplash()  {
      Future<void>.delayed(const Duration(milliseconds: 500)).then((void value)async {
      final bool introPageDone = splashRepo.getIntroPageDone();
      
      final String? savedLanguage = splashRepo.getSavedLanguage();
      
      bool languageSelectionDone = splashRepo.getLanguageSelectionDone();
      if (savedLanguage != null && savedLanguage.isNotEmpty && !languageSelectionDone) {
        await splashRepo.setLanguageSelectionDone();
        languageSelectionDone = true;
      } else if (!languageSelectionDone) {
        await _initializeDeviceLanguage();
      }
      
      final ApiResponse apiResponse = await splashRepo.getConfig();
      if(apiResponse.response?.statusCode == 200) {
        _configModel = ConfigModel.fromJson(apiResponse.response?.data!['body'] as Map<String, dynamic>);
      }

      emit(SplashDone(
        isIntroPageDone: introPageDone,
        isLanguageSelectionDone: languageSelectionDone,
      ));
    });
   }
   
   Future<void> _initializeDeviceLanguage() async {
     final String deviceLocale = _getDeviceLanguage();
     await splashRepo.saveLanguage(deviceLocale);
   }
   
   String _getDeviceLanguage() {
     final String deviceLocale = WidgetsBinding.instance.window.locale.languageCode;
     
     if (deviceLocale == 'ar') {
       return 'ar';
     } else {
       return 'en';
     }
   }

  Future<void> setIntroPageDone() async {
    final bool done = await splashRepo.setIntroPageDone();
    emit(IntroDone(isIntroPageDone: done));
  }
  
  Future<void> setLanguageSelectionDone() async {
    final bool done = await splashRepo.setLanguageSelectionDone();
    emit(LanguageSelectionDone(isLanguageSelectionDone: done));
  }
}
