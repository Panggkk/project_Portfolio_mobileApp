import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:patcharaphorn_final_app/firebase_options.dart';
import 'package:patcharaphorn_final_app/pages/movies_detail.dart';
import 'package:patcharaphorn_final_app/pages/movies_list.dart';
import 'package:patcharaphorn_final_app/pages/schedule_list.dart';
import 'package:patcharaphorn_final_app/pages/signin_page.dart';
import 'package:patcharaphorn_final_app/pages/signup_page.dart';
import 'package:patcharaphorn_final_app/pages/profile_page.dart'; // Import the profile page

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies & Series Planner',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      // Define initialRoute and routes
      initialRoute: '/sign_in', // Default start page
      routes: {
        '/': (context) => const MainPage(), // Main page
        '/movies_list': (context) => const MovieListPage(), // Movies list
        '/movie_detail': (context) => const MovieDetailPage(title: '', genre: '', imageUrl: '', synopsis: '', source: '', length: '',), // Movie details
        '/schedule_list': (context) => const ScheduleListPage(), // Schedule list
        '/sign_in': (context) => const SignInPage(), // Sign-in page
        '/sign_up': (context) => const SignUpPage(), // Sign-up page
        '/profile': (context) => const ProfilePage(), // Profile page
      },
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const MovieListPage(),
    const ScheduleListPage(),
    const ProfilePage(), // Add ProfilePage to the list
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      _showProfilePage(); // Navigate to ProfilePage
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  Future<void> _showProfilePage() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      // Navigate to profile page if user is authenticated
      Navigator.pushNamed(context, '/profile');
    } else {
      // Handle if user is not authenticated (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please sign in to view profile'),backgroundColor: Colors.orange), 
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _selectedIndex < _pages.length
          ? _pages[_selectedIndex]
          : const SizedBox(), // Show the current page or empty for logout
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.blue, // Color for selected icon
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.movie),
            label: 'Movies List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Schedule List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Change to profile icon
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
