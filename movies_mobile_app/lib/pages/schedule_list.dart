import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:patcharaphorn_final_app/components/schedule_card.dart';


class ScheduleListPage extends StatefulWidget {
  const ScheduleListPage({Key? key}) : super(key: key);

  @override
  _ScheduleListPageState createState() => _ScheduleListPageState();
}

class _ScheduleListPageState extends State<ScheduleListPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  List<QueryDocumentSnapshot> schedules = [];

  @override
  void initState() {
    super.initState();
    fetchSchedules();
  }

  Future<void> fetchSchedules() async {
    final user = _auth.currentUser;
    if (user == null) return;

    final snapshot = await _firestore
        .collection('patcharaphorn_schedule')
        .where('email', isEqualTo: user.email)
        .get();

    setState(() {
      schedules = snapshot.docs;
    });
  }

  Future<void> deleteSchedule(String id) async {
    await _firestore.collection('patcharaphorn_schedule').doc(id).delete();
    fetchSchedules(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scheduled Movies/Series')),
      body: schedules.isEmpty
          ? const Center(child: Text('No schedules found.'))
          : ListView.builder(
              itemCount: schedules.length,
              itemBuilder: (context, index) {
                final schedule = schedules[index];
                return ScheduleCard(
                  title: schedule['title'],
                  imageUrl: schedule['imageUrl'],
                  date: schedule['date'],
                  timeSlot: schedule['timeSlot'],
                  onDelete: () => deleteSchedule(schedule.id),
                );
              },
            ),
    );
  }
}
