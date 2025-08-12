
import 'dart:math';
import 'package:flutter/material.dart';

class GoatzFlipCard extends StatefulWidget {
  final String name;
  final String sport;
  final String imageUrl;
  final String bio;
  final List<String> accolades;
  final String stats;

  const GoatzFlipCard({
    super.key,
    required this.name,
    required this.sport,
    required this.imageUrl,
    required this.bio,
    required this.accolades,
    this.stats = '',
  });

  @override
  State<GoatzFlipCard> createState() => _GoatzFlipCardState();
}

class _GoatzFlipCardState extends State<GoatzFlipCard> {
  bool flipped = false;

  @override
  Widget build(BuildContext context) {
    final front = _Front(name: widget.name, sport: widget.sport, imageUrl: widget.imageUrl);
    final back  = _Back(name: widget.name, sport: widget.sport, bio: widget.bio, accolades: widget.accolades, stats: widget.stats);
    return GestureDetector(
      onTap: () => setState(()=> flipped = !flipped),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        transitionBuilder: (child, anim) {
          final angle = Tween(begin: pi, end: 0.0).animate(anim);
          return AnimatedBuilder(
            animation: angle,
            child: child,
            builder: (_, child) {
              final isUnder = (ValueKey(flipped) != child!.key);
              final value = isUnder ? min(angle.value, pi/2) : angle.value;
              return Transform(
                transform: Matrix4.rotationY(value),
                alignment: Alignment.center,
                child: child,
              );
            },
          );
        },
        child: flipped
          ? Container(key: const ValueKey(true), child: back)
          : Container(key: const ValueKey(false), child: front),
      ),
    );
  }
}

class _Front extends StatelessWidget {
  final String name; final String sport; final String imageUrl;
  const _Front({required this.name, required this.sport, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: DecorationImage(image: NetworkImage(imageUrl), fit: BoxFit.cover),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16)],
      ),
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Color(0xAA000000), Color(0x00000000)]),
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(16),
        alignment: Alignment.bottomLeft,
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
          const SizedBox(height: 4),
          Text(sport, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        ]),
      ),
    );
  }
}

class _Back extends StatelessWidget {
  final String name; final String sport; final String bio; final List<String> accolades; final String stats;
  const _Back({required this.name, required this.sport, required this.bio, required this.accolades, required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity, height: 420,
      decoration: BoxDecoration(
        color: const Color(0xFF0D0D0D),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black54, blurRadius: 16)],
        border: Border.all(color: const Color(0xFFFFD200), width: 1.4),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white)),
        const SizedBox(height: 4),
        Text(sport, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 12),
        Text(bio, style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(height: 12),
        const Text("Accolades", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
        const SizedBox(height: 6),
        Expanded(
          child: ListView(
            children: [
              ...accolades.map((a)=> Row(crossAxisAlignment: CrossAxisAlignment.start, children:[
                const Text("• ", style: TextStyle(color: Colors.white70)),
                Expanded(child: Text(a, style: const TextStyle(color: Colors.white70)))
              ])).toList(),
              if (stats.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                const Text("Career Stats", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                const SizedBox(height: 4),
                Text(stats, style: const TextStyle(color: Colors.white70)),
              ]
            ],
          ),
        ),
      ]),
    );
  }
}
