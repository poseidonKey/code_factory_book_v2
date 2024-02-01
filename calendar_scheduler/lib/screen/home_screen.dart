import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.utc(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material App Bar'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // TableCalendar(
            //   focusedDay: DateTime.now(),
            //   firstDay: DateTime(1800, 1, 1),
            //   lastDay: DateTime(3000, 1, 1),
            // ),
            MainCalendar(
              onDaySelected: onDaySelected,
              selectedDate: selectedDate,
            ),
          ],
        ),
      ),
    );
  }

  void onDaySelected(DateTime selectedDate, DateTime focusedDate) {
    setState(() {
      this.selectedDate = selectedDate;
    });
  }
}
