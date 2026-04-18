import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../cubit/language_cubit.dart';


class LanguageDropdown extends StatelessWidget {
  const LanguageDropdown({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageCubit, LanguageState>(
      buildWhen: (LanguageState previous, LanguageState current) => previous.locale != current.locale,
      builder: (BuildContext context, LanguageState state) {
        return PopupMenuButton<String>(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          offset: const Offset(0, 40),
          icon: Text(
            state.locale.languageCode == 'ar' ? 'العربية' : 'English',
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            PopupMenuItem<String>(
              value: 'ar',
              child: Row(
                children: <Widget>[
                  Text(
                    'عربي',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (state.locale.languageCode == 'ar')
                    Icon(
                      Icons.check,
                      size: 18.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
            PopupMenuItem<String>(
              value: 'en',
              child: Row(
                children: <Widget>[
                  Text(
                    'English',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  if (state.locale.languageCode == 'en')
                    Icon(
                      Icons.check,
                      size: 18.sp,
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            ),
          ],
          onSelected: (String langCode) {
            context.read<LanguageCubit>().changeLanguage(context, langCode);
          },
        );
      },
    );
  }
}
