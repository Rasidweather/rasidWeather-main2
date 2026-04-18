import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/widgets/header_widget.dart';
import '../../../../common/widgets/loader_widget.dart';
import '../../../../core/widgets/back_button.dart';
import '../../data/models/city_model.dart';
import '../cubit/cities_cubit.dart';

/// A screen that allows users to search for and add cities to their list.
/// This screen provides a search functionality with real-time results and
/// the ability to add selected cities to the user's saved list.
class CitySearchScreen extends StatelessWidget {
  const CitySearchScreen({super.key});

  /// Handles the action when a user taps the add button for a city.
  /// Adds the selected city to the saved list and updates the UI.
  ///
  /// [context] The build context
  /// [geoname] The city data to be added
  Future<void> handleAddTap(BuildContext context, CityModel geoname) async {
    await context
        .read<CitiesCubit>()
        .addCity(geoname)
        .then((value) => Navigator.of(context).pop());
    await context.read<CitiesCubit>().getCitiesList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[200],
        leading: const AdaptiveBackButton(),
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: HeaderWidget(
          title: 'cities.search_title'.tr(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(height: 20.h),
              // Search input field with rounded corners
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: TextField(
                  onChanged: context.read<CitiesCubit>().onChangedText,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.text,
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
              const SizedBox(height: 25),
              // Search results list with different states handling
              Expanded(
                child: BlocConsumer<CitiesCubit, CitiesState>(
                  listener: (BuildContext context, CitiesState state) {},
                  builder: (BuildContext context, CitiesState state) {
                    // Initial state - show search prompt
                    if (state is CitiesInitial) {
                      return Center(
                        child: Text('cities.search_title'.tr()),
                      );
                    }
                    // Loading state
                    if (state.isLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    // Success state - show search results
                    if (state is SearchCitiesSuccess) {
                      // Check if we have results
                      if (state.searchResults == null ||
                          state.searchResults!.isEmpty) {
                        return Center(
                          child: Text('cities.no_results_found'.tr()),
                        );
                      }

                      return ListView.builder(
                          itemCount: state.searchResults!.length,
                          itemBuilder: (BuildContext context, int index) {
                            final CityModel city = state.searchResults![index];

                            // City list item with flag, name, and add button
                            return ListTile(
                              leading: CircleAvatar(
                                foregroundImage: AssetImage(
                                  'assets/flags/${city.countryCode?.toLowerCase() ?? 'unknown'}.png',
                                ),
                                child: city.countryCode == null
                                    ? const Text('?')
                                    : null,
                              ),
                              title: Text(
                                city.name ?? 'No name',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700),
                              ),
                              subtitle: Text(
                                '${city.countryName ?? 'Unknown'} ${city.countryCode != null ? ', ${city.countryCode}' : ''}',
                              ),
                              trailing: IconButton(
                                icon: Icon(
                                  Icons.add,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  handleAddTap(context, city);
                                },
                              ),
                            );
                          });
                    }
                    // Error state
                    if (state.error != null) {
                      return Center(
                        child: Text(state.error!),
                      );
                    }
                    return Container();
                  },
                ),
              ),
              // Loading indicator at the bottom
              if (context.watch<CitiesCubit>().state.isLoading)
                const Center(
                  child: LoaderWidget(),
                ),
            ]),
      ),
    );
  }
}
