import 'package:flutter/material.dart';
import 'package:mileage_calculator/providers/auth_provider.dart';
import 'package:mileage_calculator/providers/theme_provider.dart';
import 'package:mileage_calculator/screens/app/history_tracking_screen.dart';
import 'package:mileage_calculator/screens/app/mileage_counter_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    MileageCounterScreen(),
    HistoryTrackingScreen(),
  ];

  late AuthProvider authProvider;

  @override
  void initState() {
    super.initState();
    authProvider = Provider.of<AuthProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);

    bool isDark =
        themeProvider.themeMode == ThemeMode.dark ||
        (themeProvider.themeMode == ThemeMode.system &&
            brightness == Brightness.dark);

    return Scaffold(
      appBar: AppBar(title: const Text('Mileage Calculator')),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              accountName: const Text("John Doe"),
              accountEmail: const Text("johndoe@example.com"),
              currentAccountPicture: const CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person, size: 40, color: Colors.grey),
              ),
            ),
            SwitchListTile(
              secondary: Icon(isDark ? Icons.dark_mode : Icons.light_mode),
              title: Text(isDark ? 'Dark Mode' : 'Light Mode'),
              value: isDark,
              onChanged: (value) {
                themeProvider.toggleTheme(value);
                setState(() {}); // rebuild to reflect theme change
              },
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () async {
                await authProvider.signOut();
                if (!mounted) return;
                Navigator.of(context).pushReplacementNamed("/signin");
              },
            ),
          ],
        ),
      ),

      body: IndexedStack(index: _currentIndex, children: _pages),

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.calculate), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
