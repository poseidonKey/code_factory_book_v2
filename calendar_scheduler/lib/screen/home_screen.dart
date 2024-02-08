import 'package:calendar_scheduler/component/main_calendar.dart';
import 'package:calendar_scheduler/component/schedule_bottom_sheet.dart';
import 'package:calendar_scheduler/component/schedule_card.dart';
import 'package:calendar_scheduler/component/today_banner.dart';
import 'package:calendar_scheduler/const/colors.dart';
import 'package:calendar_scheduler/model/schedule_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
            MainCalendar(
              onDaySelected: (selectedDate, focusedDate) =>
                  onDaySelected(selectedDate, focusedDate, context),
              selectedDate: selectedDate,
            ),
            const SizedBox(
              height: 8,
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('schedule')
                    .where(
                      'date',
                      isEqualTo:
                          '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  return TodayBanner(
                    selectedDate: selectedDate,
                    count: snapshot.data?.docs.length ?? 0,
                  );
                }),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('schedule')
                      .where(
                        'date',
                        isEqualTo:
                            '${selectedDate.year}${selectedDate.month.toString().padLeft(2, '0')}${selectedDate.day.toString().padLeft(2, '0')}',
                      )
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(
                        child: Text('일정 정보를 가져오지 못했다'),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Container();
                    }
                    final schedules = snapshot.data!.docs
                        .map((QueryDocumentSnapshot e) =>
                            ScheduleModel.fromJson(
                                json: (e.data() as Map<String, dynamic>)))
                        .toList();
                    print(schedules.length);
                    return ListView.separated(
                      itemCount: schedules.length,
                      itemBuilder: ((context, index) {
                        final schedule = schedules[index];
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 8, right: 8),
                          child: Dismissible(
                            key: ObjectKey(schedule.id),
                            direction: DismissDirection.startToEnd,
                            onDismissed: (direction) {
                              FirebaseFirestore.instance
                                  .collection('schedule')
                                  .doc(schedule.id)
                                  .delete();
                            },
                            child: Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8,
                                left: 8,
                                right: 8,
                              ),
                              child: ScheduleCard(
                                  startTime: schedule.startTime,
                                  endTime: schedule.endTime,
                                  content: schedule.content),
                            ),
                          ),
                        );
                      }),
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        width: 8,
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: PRIMARY_COLOR,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isDismissible: true,
            builder: (_) => ScheduleBottomSheet(
              selectedDate: selectedDate,
            ),
            isScrollControlled: true,
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void onDaySelected(
    DateTime selectedDate,
    DateTime focusedDate,
    BuildContext context,
  ) {
    setState(() {
      // print(selectedDate);
      this.selectedDate = selectedDate;
    });
  }
}
