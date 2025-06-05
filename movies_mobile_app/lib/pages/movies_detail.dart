import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart'; // For date and time formatting

class MovieDetailPage extends StatefulWidget {
  final String title;
  final String genre;
  final String imageUrl;
  final String synopsis;
  final String source;
  final String length;

  const MovieDetailPage({
    required this.title,
    required this.genre,
    required this.imageUrl,
    required this.synopsis,
    required this.source,
    required this.length,
    Key? key,
  }) : super(key: key);

  @override
  _MovieDetailPageState createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  DateTime selectedDate = DateTime.now();
  String selectedTimeSlot = '10:00 AM - 12:00 PM'; // Default time slot

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to format the date in "Sun, 1st Dec 2024" style
  String formatDate(DateTime date) {
    String suffix = 'th';
    int day = date.day;

    if (day == 1 || day == 21 || day == 31) suffix = 'st';
    if (day == 2 || day == 22) suffix = 'nd';
    if (day == 3 || day == 23) suffix = 'rd';

    return DateFormat('EEE, d').format(date) + suffix + DateFormat(' MMM yyyy').format(date); // Add year here
  }

  // Function to check if schedule already exists
  Future<bool> isScheduleExists(String date, String timeSlot) async {
    final snapshot = await _firestore
        .collection('patcharaphorn_schedule')
        .where('date', isEqualTo: date)
        .where('timeSlot', isEqualTo: timeSlot)
        .get();

    return snapshot.docs.isNotEmpty;
  }

  // Function to add schedule to Firestore
  Future<void> addSchedule(String date, String timeSlot) async {
    final user = _auth.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please log in to book a schedule.')),
      );
      return;
    }

    final scheduleData = {
      'date': date,
      'timeSlot': timeSlot,
      'title': widget.title,
      'imageUrl': widget.imageUrl,
      'email': user.email,
    };

    await _firestore.collection('patcharaphorn_schedule').add(scheduleData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 218, 243, 255),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Movie Details Card
 Card(
  elevation: 8, // Increased elevation for more depth
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start, // Align items at the top
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12), // Rounded corners for the image
          child: widget.imageUrl.isNotEmpty
              ? Image.network(
                  widget.imageUrl,
                  width: 120, // Increased width
                  height: 160, // Increased height
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 120), // Increased icon size for fallback
                )
              : const Icon(Icons.image_not_supported, size: 120), // Icon fallback
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: const TextStyle(
                  fontSize: 22, // Increased font size for title
                  fontWeight: FontWeight.bold,
                  color: Colors.black87, // Dark color for better contrast
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Genre: ${widget.genre}",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 4),
              Text(
                "Length: ${widget.length}",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 4),
              Text(
                "Source: ${widget.source}",
                style: const TextStyle(fontSize: 14, color: Colors.blueGrey),
              ),
              const SizedBox(height: 12),
              Text(
                "Synopsis:",
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                widget.synopsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey,
                ),
                maxLines: 3, // Limit to 3 lines
                overflow: TextOverflow.ellipsis, // Ellipsis if text is too long
              ),
            ],
          ),
        ),
      ],
    ),
  ),
),

            const SizedBox(height: 20),

            // Date Picker
            Text('Choose Date:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2024),
                  lastDate: DateTime(2025),
                );
                if (pickedDate != null) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(formatDate(selectedDate), style: const TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 20),

            // Time Slot Dropdown
            Text('Choose Time Slot:', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedTimeSlot,
              items: [
                '06:00 AM - 08:00 AM',
                '10:00 AM - 12:00 PM',
                '02:00 PM - 04:00 PM',
                '06:00 PM - 08:00 PM',
                '08:00 PM - 10:00 PM'
              ].map((slot) {
                return DropdownMenuItem<String>(
                  value: slot,
                  child: Text(slot, style: const TextStyle(fontSize: 14)),
                );
              }).toList(),
              onChanged: (newSlot) {
                setState(() {
                  selectedTimeSlot = newSlot!;
                });
              },
            ),
            const SizedBox(height: 20),

            // Book Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                elevation: 6,
              ),
              onPressed: () async {
                bool scheduleExists = await isScheduleExists(formatDate(selectedDate), selectedTimeSlot);

                if (scheduleExists) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('This schedule already exists. Please choose another time.'), backgroundColor: Colors.red),);
                } else {
                  await addSchedule(formatDate(selectedDate), selectedTimeSlot);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Your watch time for ${widget.title} has been booked!'), backgroundColor: Colors.green),
                  );
                }
              },
              child: const Text('Book for Watching', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            ),
          ],
        ),
      ),
    );
  }
}
