
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/data_repository.dart';
import '../models/athlete.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Athlete>>(
      future: context.read<DataRepository>().fetchAll(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: CircularProgressIndicator());
        final all = snap.data!;
        return ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text('My GOATZ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...all.take(5).map((a)=> ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(a.imageUrl, width: 48, height: 48, fit: BoxFit.cover)),
              title: Text(a.name),
              subtitle: Text(a.sport),
              trailing: const Text('1500', style: TextStyle(color: Color(0xFFFFD200), fontWeight: FontWeight.w600)),
            )),
            const SizedBox(height: 16),
            const Text('My Favorites', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            ...all.skip(3).take(5).map((a)=> ListTile(
              leading: ClipRRect(borderRadius: BorderRadius.circular(8), child: Image.network(a.imageUrl, width: 48, height: 48, fit: BoxFit.cover)),
              title: Text(a.name),
              subtitle: Text(a.sport),
              trailing: const Text('1500', style: TextStyle(color: Color(0xFF7C3AED), fontWeight: FontWeight.w600)),
            )),
          ],
        );
      },
    );
  }
}
