
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_repository.dart';
import '../models/athlete.dart';

class DailyPage extends StatefulWidget {
  const DailyPage({super.key});

  @override
  State<DailyPage> createState() => _DailyPageState();
}

class _DailyPageState extends State<DailyPage> {
  String mode = 'goat';
  Athlete? leftA;
  Athlete? rightA;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = context.read<DataRepository>();
    final all = await repo.fetchAll();
    final ids = await repo.getDailyChallenge();
    setState(() {
      leftA = all.firstWhere((x)=> x.id == ids['a']);
      rightA= all.firstWhere((x)=> x.id == ids['b']);
    });
  }

  int leftVotes = 0;
  int rightVotes = 0;

  void _vote(bool left) {
    setState(() { if (left) leftVotes++; else rightVotes++; });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
        if (leftA == null || rightA == null)
          const Expanded(child: Center(child: CircularProgressIndicator()))
        else
          Expanded(child: Column(children: [
            Row(children: [
              Expanded(child: _MiniCard(a: leftA!)),
              const SizedBox(width: 12),
              Expanded(child: _MiniCard(a: rightA!)),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF222222), foregroundColor: Colors.white),
                onPressed: ()=> _vote(true),
                child: const Text('Pick Left'),
              )),
              const SizedBox(width: 12),
              Expanded(child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFFD200), foregroundColor: Colors.black),
                onPressed: ()=> _vote(false),
                child: const Text('Pick Right'),
              )),
            ]),
            const SizedBox(height: 16),
            const Text('Live Results', style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 6),
            _ResultsBar(left: leftVotes, right: rightVotes),
          ])),
      ]),
    );
  }
}

class _MiniCard extends StatelessWidget {
  final Athlete a;
  const _MiniCard({required this.a});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(color: const Color(0xFF0D0D0D), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1C1C1C))),
      child: Column(children: [
        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(a.imageUrl, width: double.infinity, height: 140, fit: BoxFit.cover)),
        const SizedBox(height: 6),
        Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _ResultsBar extends StatelessWidget {
  final int left; final int right;
  const _ResultsBar({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    final total = (left + right).toDouble();
    final l = total == 0 ? 0 : left / total;
    final r = total == 0 ? 0 : right / total;
    return Column(children: [
      Row(children: [
        const Text('Left', style: TextStyle(color: Colors.white)),
        const Spacer(),
        Text('$left', style: const TextStyle(color: Colors.white)),
      ]),
      Container(
        height: 12,
        decoration: BoxDecoration(color: const Color(0xFF1E1E1E), borderRadius: BorderRadius.circular(6)),
        child: Row(children: [
          Expanded(flex: (l*1000).round(), child: Container(decoration: BoxDecoration(color: const Color(0xFF7C3AED), borderRadius: BorderRadius.circular(6)))),
          Expanded(flex: (r*1000).round(), child: Container(decoration: BoxDecoration(color: const Color(0xFFFFD200), borderRadius: BorderRadius.circular(6)))),
        ]),
      ),
      Row(children: [
        const Text('Right', style: TextStyle(color: Colors.white)),
        const Spacer(),
        Text('$right', style: const TextStyle(color: Colors.white)),
      ]),
    ]);
  }
}
