
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_repository.dart';
import '../models/athlete.dart';

class LeaderboardPage extends StatefulWidget {
  const LeaderboardPage({super.key});

  @override
  State<LeaderboardPage> createState() => _LeaderboardPageState();
}

class _LeaderboardPageState extends State<LeaderboardPage> {
  String mode = 'goat';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          Expanded(
            child: FutureBuilder<List<Athlete>>(
              future: context.read<DataRepository>().fetchAll(),
              builder: (context, snap) {
                if (!snap.hasData) return const Center(child: CircularProgressIndicator());
                final all = snap.data!;
                return ListView.separated(
                  itemCount: all.length,
                  separatorBuilder: (_, __)=> const SizedBox(height: 8),
                  itemBuilder: (_, i){
                    final a = all[i];
                    return Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(color: const Color(0xFF0D0D0D), borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFF1C1C1C))),
                      child: Row(children: [
                        ClipRRect(borderRadius: BorderRadius.circular(12), child: Image.network(a.imageUrl, width: 56, height: 56, fit: BoxFit.cover)),
                        const SizedBox(width: 12),
                        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(a.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                          Text(a.sport, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                        ]),
                        const Spacer(),
                        Column(crossAxisAlignment: CrossAxisAlignment.end, children: const [
                          Text('Demo Rating', style: TextStyle(fontSize: 10, color: Colors.white54)),
                          Text('1500', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFFFFD200))),
                        ])
                      ]),
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
