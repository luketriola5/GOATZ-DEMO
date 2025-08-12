
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_repository.dart';
import '../models/athlete.dart';
import '../widgets/goatz_flip_card.dart';

class MatchupPage extends StatefulWidget {
  const MatchupPage({super.key});

  @override
  State<MatchupPage> createState() => _MatchupPageState();
}

class _MatchupPageState extends State<MatchupPage> {
  String mode = 'goat'; // or 'favorite'
  Athlete? a;
  Athlete? b;
  List<Athlete> all = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<DataRepository>();
    final list = await repo.fetchAll();
    setState(() {
      all = list;
    });
    _pickTwo();
  }

  void _pickTwo() {
    if (all.length < 2) return;
    final rng = Random();
    a = all[rng.nextInt(all.length)];
    do { b = all[rng.nextInt(all.length)]; } while (b!.id == a!.id);
    setState(() {});
  }

  void _vote(bool rightWins) {
    // Demo: simply re-pick; in real app call recordVote(mode)
    _pickTwo();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        children: [
          Row(
            children: [
              const Text('Mode', style: TextStyle(color: Colors.white70)),
              const SizedBox(width: 12),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'goat', label: Text('GOAT')),
                  ButtonSegment(value: 'favorite', label: Text('FAVORITE')),
                ],
                selected: {mode},
                onSelectionChanged: (s){ setState(()=> mode = s.first); },
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (a != null && b != null)
            Expanded(
              child: Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Opacity(
                      opacity: 0.9,
                      child: GoatzFlipCard(
                        name: b!.name, sport: b!.sport, imageUrl: b!.imageUrl, bio: b!.bio, accolades: b!.accolades, stats: b!.stats,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Dismissible(
                      key: ValueKey(a!.id + Random().nextInt(99999).toString()),
                      direction: DismissDirection.horizontal,
                      onDismissed: (dir) => _vote(dir == DismissDirection.endToStart ? false : true),
                      background: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(color: const Color(0xFFFFD200).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.centerLeft,
                        child: const Padding(
                          padding: EdgeInsets.only(left: 24.0),
                          child: Icon(Icons.thumb_up, color: Color(0xFFFFD200), size: 40),
                        ),
                      ),
                      secondaryBackground: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(color: const Color(0xFF7C3AED).withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        alignment: Alignment.centerRight,
                        child: const Padding(
                          padding: EdgeInsets.only(right: 24.0),
                          child: Icon(Icons.favorite, color: Color(0xFF7C3AED), size: 40),
                        ),
                      ),
                      child: GoatzFlipCard(
                        name: a!.name, sport: a!.sport, imageUrl: a!.imageUrl, bio: a!.bio, accolades: a!.accolades, stats: a!.stats,
                      ),
                    ),
                  ),
                ],
              ),
            )
          else
            const Expanded(child: Center(child: CircularProgressIndicator())),
        ],
      ),
    );
  }
}
