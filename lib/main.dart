import 'package:flutter/material.dart';
import 'ElectionInformationPage.dart';
import 'VoterRegistrationPage.dart';
import 'TopicsPage.dart';
import 'PollLocationFinderPage.dart';
import 'BallotInfoPage.dart';
import 'splash_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'voteSmarter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  final List<Widget> _pages = [
    ElectionInformationPage(),
    VoterRegistrationPage(),
    BallotInfoPage(),
    TopicsPage(),
    PollLocationFinderPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onMenuItemSelected(String value) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuPage(title: value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'voteSmarter ☑️',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xff2c3afa),
          ),
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: _onMenuItemSelected,
            itemBuilder: (BuildContext context) {
              return {'Login/Signup', 'Voting Guides', 'Help'}
                  .map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.how_to_vote),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.ballot),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.quiz),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.location_on),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color(0xff2c3afa),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      extendBody: true,
    );
  }
}

class MenuPage extends StatelessWidget {
  final String title;

  MenuPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Text(
          title,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
