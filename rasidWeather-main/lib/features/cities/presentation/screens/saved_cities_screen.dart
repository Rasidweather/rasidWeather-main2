import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/header_widget.dart';
import '../../../../core/constants/country_code_list.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../views/base/index.dart';
import '../../../weather/presentation/cubit/weather_cubit.dart';
import '../../data/models/city_model.dart';
import '../cubit/cities_cubit.dart';
import 'add_city_search.dart';

/// A screen that displays and manages the user's saved cities.
/// Provides functionality to view, select, and delete saved cities,
/// as well as add new cities and get the current GPS location.
class SavedCitiesScreen extends StatelessWidget {
  const SavedCitiesScreen({super.key, this.isFirstTime = false});

  final bool isFirstTime;

  /// Handles the deletion of a city from the saved list
  /// Shows a confirmation dialog before deletion
  /// 
  /// [city] The city to be deleted
  /// [index] The index of the city in the list
  Future<void> handleDeleteTap(BuildContext context, CityModel city, List<CityModel> cities) async {
    final bool? result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => Center(
        child: AlertDialog(
          title: Text('cities.delete_city_title'.tr()),
          content: Text(
            'cities.delete_city_message'.tr(args: <String>[city.name!]),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.no'.tr()),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text('common.yes'.tr()),
            ),
          ],
        ),
      ),
    );
    if (result!) {
      if (cities.length > 1) {
        /// if delete the selected city  ==>  select the first city in the list
        Future<void>.delayed(Duration.zero, () async {
          final CitiesCubit citiesCubit = context.read<CitiesCubit>();
          if (city.isSelected!) {
            await citiesCubit.deleteCity(city.locationId!);
            await citiesCubit.getCitiesList();
            await citiesCubit.selectCity(cities[0]);
          } else {
            await citiesCubit.deleteCity(city.locationId!);
            await citiesCubit.getCitiesList();
          }
        });
      }
    }
  }

  /// Navigates to the city search screen with a slide-up animation
  /// 
  /// [context] The build context for navigation
  static Future<void> handleNavigatePress(BuildContext context) async {
    await Navigator.of(context).push(
      PageRouteBuilder<void>(
          transitionDuration: const Duration(milliseconds: 10),
          pageBuilder: (_, Animation<double> animation1, Animation<double> animation2) {
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.0, 1.0), end: Offset.zero).animate(animation1),
              child: const CitySearchScreen(),
            );
          }),
    );
  }

  /// Handles the selection of a city from the saved list
  /// Updates the selected city and fetches its weather data
  /// 
  /// [city] The city to be selected and viewed
  Future<void> handleNavigateViewCity(BuildContext context, CityModel city, bool isFirstTime) async {
    final CitiesCubit citiesCubit = context.read<CitiesCubit>();
    // Get the WeatherCubit before navigation
    final WeatherCubit weatherCubit = context.read<WeatherCubit>();
    
    await citiesCubit.selectCity(city);
    await citiesCubit.getSelectedCityState();
        
    // Navigate after all the data operations are complete
    RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);
    
    // Fetch weather data before navigation
    await weatherCubit.getWeatherData(city, refresh: true);
  }

  Widget _buildCitiesList(BuildContext context, CitiesState state, List<CityModel> cities) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return cities.isEmpty
        ? Center(
            child: Text('cities.no_cities'.tr()),
          ) 
        : ListView.builder(
            padding: const EdgeInsets.only(bottom: 10),
            physics: const NeverScrollableScrollPhysics(),
            itemCount: cities.length,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              final CityModel city = cities[index];
              return CityItem(
                city: city,
                length: cities.length,
                deleteFunction: () => handleDeleteTap(context, city, cities),
                onTapFunction: () => handleNavigateViewCity(context, city, isFirstTime),
              );
            });
  }

  @override
  Widget build(BuildContext context) {
    // Initial load of cities
    context.read<CitiesCubit>().getCitiesList();
    return PopScope(
      // Update selected city state when navigating back
      onPopInvokedWithResult: (bool v,Object? o) async {
        await context.read<CitiesCubit>().getSelectedCityState();
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Colors.grey[300],
          leading: AdaptiveBackButton(
              onPressed: () async {
                await context.read<CitiesCubit>().getSelectedCityState();
                Navigator.pop(context);
              }),
          actions: <Widget>[
            // GPS location button
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: GestureDetector(
                onTap: () => context.read<CitiesCubit>().getGPSCity(),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Icon(Icons.my_location, color: Colors.grey[800]),
                ),
              ),
            ),
          ],
          centerTitle: true,
          title:  HeaderWidget(title: 'cities.title'.tr()),
        ),
        body: AppUiOverlayStyle(
          systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: SingleChildScrollView(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                // Instructions text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'cities.subtitle'.tr(),
                    style: TextStyle(fontWeight: FontWeight.w400, color: const Color(0xff3D3C3C), fontSize: 16.sp),
                  ),
                ),
                const SizedBox(height: 10),
                // Search city button (non-editable TextField)
                GestureDetector(
                  onTap: () => handleNavigatePress(context),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: TextField(
                      enabled: false,
                      decoration: InputDecoration(
                        focusedBorder: InputBorder.none,
                        border: InputBorder.none,
                        filled: true,
                        hintText: 'cities.search_placeholder'.tr(),
                        fillColor: Colors.grey[300],
                        prefixIcon: const SizedBox(width: 5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                // Cities list with state management
                BlocConsumer<CitiesCubit, CitiesState>(
                  listener: (BuildContext context, CitiesState state) {
                    if (state is CitiesSuccess) {
                      context.read<CitiesCubit>().getCitiesList();
                    }
                    if (state.error != null) {
                      showSnackBar(context, state.error!, color: Colors.red);
                    }
                  },
                  builder: (BuildContext context, CitiesState state) {
                    final List<CityModel> cities = state is CitiesListSuccess ? state.cities! : <CityModel>[];
                    return _buildCitiesList(context, state, cities);
                  },
                ),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}

/// A widget that represents a single city item in the saved cities list
/// Displays city information and provides delete and selection functionality
class CityItem extends StatelessWidget {
  const CityItem({
    super.key,
    required this.city,
    required this.length,
    required this.deleteFunction,
    required this.onTapFunction,
  });

  /// The city model containing city information
  final CityModel city;
  
  /// Total number of saved cities
  final int length;
  
  /// Callback function for delete action
  final VoidCallback deleteFunction;
  
  /// Callback function for when the city item is tapped
  final VoidCallback onTapFunction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: city.isSelected! ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 5,
              spreadRadius: 1,
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: ListTile(
              onTap: onTapFunction,
              title: Text(
                city.name!,
                style: Theme.of(context).textTheme.displaySmall!.copyWith(
                  fontWeight: FontWeight.w300,
                  fontSize: 20
                )
              ),
              subtitle: Text(
                convertCodeToCountryName(city.countryCode!).toString(),
                style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 12)
              ),
              leading: CircleAvatar(
                foregroundImage: AssetImage('assets/flags/${city.countryCode!.toLowerCase()}.png')
              ),
              trailing: length != 1 && !city.isSelected!
                ? IconButton(
                    onPressed: deleteFunction,
                    icon: Icon(Icons.close, color: Theme.of(context).primaryColor)
                  )
                : const SizedBox(),
            ),
          ),
        ),
      ),
    );
  }
}
