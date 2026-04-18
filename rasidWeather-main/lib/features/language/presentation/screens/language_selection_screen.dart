import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../bloc/splash_cubit/splash_cubit.dart';
import '../../../../helper/router_helper.dart';
import '../../../cities/presentation/cubit/cities_cubit.dart';
import '../../cubit/language_cubit.dart';

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() => _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> with SingleTickerProviderStateMixin {
  String _selectedLanguage = '';
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = context.read<LanguageCubit>().getCurrentLanguage();
    
    // Initialize animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          // Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[
                  Colors.white,
                  Color(0xFFF5F5F5),
                ],
              ),
            ),
          ),
          
          // Content
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(height: 40.h),
                
                // App Logo
                Container(
                  width: 120.w,
                  height: 120.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.1),
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 15,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.cloud,
                    size: 70.sp,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                
                SizedBox(height: 30.h),
                
                // Welcome Text
                Text(
                  'language.welcome'.tr(),
                  style: TextStyle(
                    fontSize: 28.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                
                SizedBox(height: 10.h),
                
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: Text(
                    'language.please_select'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                SizedBox(height: 60.h),
                
                // Language Options
                _buildLanguageOption(
                  context,
                  'language.arabic'.tr(),
                  'ar',
                  'Arabic',
                ),
                
                SizedBox(height: 20.h),
                
                _buildLanguageOption(
                  context,
                  'language.english'.tr(),
                  'en',
                  'English',
                ),
                
                const Spacer(),
                
                // Continue Button
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 20.h),
                  child: ElevatedButton(
                    onPressed: _navigateToNextScreen,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 15.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      minimumSize: Size(double.infinity, 55.h),
                      elevation: 2,
                    ),
                    child: Text(
                      'language.continue'.tr(),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
    BuildContext context,
    String languageName,
    String languageCode,
    String languageDescription,
  ) {
    final bool isSelected = _selectedLanguage == languageCode;

    return GestureDetector(
      onTap: () => _selectLanguage(context, languageCode),
      onTapDown: (_) => _animationController.forward(),
      onTapUp: (_) => _animationController.reverse(),
      onTapCancel: () => _animationController.reverse(),
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (BuildContext context, Widget? child) {
          return Transform.scale(
            scale: isSelected ? _scaleAnimation.value : 1.0,
            child: child,
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 30.w),
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          decoration: BoxDecoration(
            color: isSelected 
                ? Theme.of(context).primaryColor.withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(15.r),
            border: Border.all(
              color: isSelected 
                  ? Theme.of(context).primaryColor
                  : Colors.grey.withOpacity(0.3),
              width: isSelected ? 2 : 1,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              // Language code icon
              Container(
                width: 50.w,
                height: 50.h,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).primaryColor
                      : Colors.grey.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    languageCode.toUpperCase(),
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 15.w),
              // Language name and description
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    languageName,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    languageDescription,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              // Check icon
              if (isSelected)
                Container(
                  width: 30.w,
                  height: 30.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectLanguage(BuildContext context, String languageCode) async {
    // Store references to cubits before any async operations
    final LanguageCubit languageCubit = context.read<LanguageCubit>();
    final SplashCubit splashCubit = context.read<SplashCubit>();
    
    // Check if widget is still mounted before updating state
    if (!mounted) {
      return;
    }
    
    setState(() {
      _selectedLanguage = languageCode;
    });
    
    // Save language selection using the stored reference
    await languageCubit.changeLanguage(context, languageCode);
    
    // Check if widget is still mounted before continuing
    if (!mounted) {
      return;
    }
    
    // Mark language selection as completed using the stored reference
    await splashCubit.setLanguageSelectionDone();
  }
  
  void _navigateToNextScreen() {
    // Pre-load city data
    context.read<CitiesCubit>().getSelectedCityState();
    
    // Navigate to dashboard
    RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);
  }
}
