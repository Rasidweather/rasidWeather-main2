import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubit/weather_cubit.dart';
import 'charts_screen.dart';

/// A container widget that manages the state and data flow for the charts screen.
/// It handles loading states, errors, and successful data fetching using BLoC pattern.
class ChartsPage extends StatelessWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) {
        return previous.days?.length != current.days?.length;
      },
      listener: (BuildContext context, WeatherState state) {
        // Show error message if chart loading fails
        // if (state is ChartError) {
        //   showSnackBar(context, state.message, color: Colors.red);
        // }
      },
      builder: (BuildContext context, WeatherState state) {
        if (state.days != null) {
          // Use a key that changes when the number of days changes
          // This forces a complete rebuild of the ChartsScreen
          return ChartsScreen(
            key: ValueKey<int>(state.days!.length),
            days: state.days!,
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      }
    );
  }
}
