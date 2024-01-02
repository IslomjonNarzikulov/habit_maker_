import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class MyHeatMap extends StatelessWidget {
  const MyHeatMap({super.key});

  @override
  Widget build(BuildContext context) {
    return
       HeatMap(
        datasets: {
          DateTime(2021, 1, 23): 12,
          DateTime(2021, 1, 14): 23,
          DateTime(2021, 1, 24): 25,
          DateTime(2021, 1, 26): 26,
          DateTime(2021, 1, 28): 28,
        },
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 750)),
        colorMode: ColorMode.color,
        showText: false,
        scrollable: true,
        colorsets: const {
          1: Color.fromARGB(250, 140, 196, 144),
          2: Color.fromARGB(250, 96, 206, 106),
          3: Color.fromARGB(250, 105, 222, 124),
          4: Color.fromARGB(250, 27, 140, 42),
          5: Color.fromARGB(250, 13, 110, 29),

        },
        onClick: (value) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
        },
      );
  }
}
