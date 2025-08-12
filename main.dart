
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/matchup_page.dart';
import 'pages/leaderboard_page.dart';
import 'pages/profile_page.dart';
import 'pages/daily_page.dart';
import 'services/data_repository.dart';
import 'models/athlete.dart';

const bool kDemoMode = true; // set to false when wiring Firebase

void main() {
  runApp(const GoatzApp());
}

class GoatzApp extends StatelessWidget {
  const GoatzApp({super.key});

  @override
  Widget build(BuildContext context) {
    final demoData = _demoAthletes();
    return MultiProvider(
      providers: [
        Provider<DataRepository>(create: (_) => DemoRepository(demoData)),
      ],
      child: MaterialApp(
        title: 'GOATZ Demo',
        theme: ThemeData(
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          colorScheme: const ColorScheme.dark(primary: Color(0xFFFFD200)),
          useMaterial3: true,
          fontFamily: 'Poppins',
        ),
        home: const _Home(),
      ),
    );
  }
}

class _Home extends StatefulWidget {
  const _Home({super.key});
  @override
  State<_Home> createState() => _HomeState();
}

class _HomeState extends State<_Home> {
  int idx = 0;
  @override
  Widget build(BuildContext context) {
    final pages = [const MatchupPage(), const LeaderboardPage(), const DailyPage(), const ProfilePage()];
    return Scaffold(
      appBar: AppBar(title: const Text('GOATZ')),
      body: pages[idx],
      bottomNavigationBar: NavigationBar(
        selectedIndex: idx,
        onDestinationSelected: (i)=> setState(()=> idx = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.sports), label: 'Matchups'),
          NavigationDestination(icon: Icon(Icons.leaderboard), label: 'Leaders'),
          NavigationDestination(icon: Icon(Icons.calendar_today), label: 'Daily'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}

// Simple demo dataset (8 athletes) with public placeholder images
List<Athlete> _demoAthletes() => [
  Athlete(
    id: 'michael_jordan',
    name: 'Michael Jordan',
    sport: 'Basketball',
    imageUrl: 'https://picsum.photos/seed/mj/600/800',
    bio: '6× NBA champion, global icon.',
    accolades: ['6× NBA Champion','5× MVP','14× All-Star'],
    stats: 'PPG: 30.1, RPG: 6.2, APG: 5.3',
  ),
  Athlete(
    id: 'lebron_james',
    name: 'LeBron James',
    sport: 'Basketball',
    imageUrl: 'https://picsum.photos/seed/lebron/600/800',
    bio: 'All-time scorer, elite playmaker.',
    accolades: ['4× NBA Champion','4× MVP','20× All-Star'],
    stats: 'PPG: 27.1, RPG: 7.5, APG: 7.4',
  ),
  Athlete(
    id: 'tom_brady',
    name: 'Tom Brady',
    sport: 'Football',
    imageUrl: 'https://picsum.photos/seed/brady/600/800',
    bio: '7× Super Bowl champion QB.',
    accolades: ['7× SB Champ','3× MVP','5× SB MVP'],
    stats: 'TD: 649, Yds: 89k',
  ),
  Athlete(
    id: 'serena_williams',
    name: 'Serena Williams',
    sport: 'Tennis',
    imageUrl: 'https://picsum.photos/seed/serena/600/800',
    bio: '23 Grand Slams in Open Era.',
    accolades: ['23× Grand Slam Singles','4× Olympic Gold'],
    stats: 'Singles titles: 73',
  ),
  Athlete(
    id: 'usain_bolt',
    name: 'Usain Bolt',
    sport: 'Track & Field',
    imageUrl: 'https://picsum.photos/seed/bolt/600/800',
    bio: 'Fastest man ever.',
    accolades: ['8× Olympic Gold','WR 100m/200m'],
    stats: '100m: 9.58, 200m: 19.19',
  ),
  Athlete(
    id: 'tiger_woods',
    name: 'Tiger Woods',
    sport: 'Golf',
    imageUrl: 'https://picsum.photos/seed/tiger/600/800',
    bio: '15 majors, cultural icon.',
    accolades: ['15× Major Titles','82 PGA Tour wins'],
    stats: 'Majors: 15, PGA: 82',
  ),
  Athlete(
    id: 'lionel_messi',
    name: 'Lionel Messi',
    sport: 'Soccer',
    imageUrl: 'https://picsum.photos/seed/messi/600/800',
    bio: 'World Cup 2022, 8× Ballon d’Or.',
    accolades: ['World Cup 2022','8× Ballon d’Or'],
    stats: 'Goals: 800+ (pro)',
  ),
  Athlete(
    id: 'cristiano_ronaldo',
    name: 'Cristiano Ronaldo',
    sport: 'Soccer',
    imageUrl: 'https://picsum.photos/seed/ronaldo/600/800',
    bio: 'Scoring records across Europe.',
    accolades: ['Euro 2016','5× UCL','5× Ballon d’Or'],
    stats: 'Goals: 850+ (pro)',
  ),
];
