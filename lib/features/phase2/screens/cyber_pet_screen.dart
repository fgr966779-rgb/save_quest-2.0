import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../data/database.dart';
import '../../../core/providers/providers.dart';

class CyberPetScreen extends ConsumerStatefulWidget {
  const CyberPetScreen({super.key});

  @override
  ConsumerState<CyberPetScreen> createState() => _CyberPetScreenState();
}

class _CyberPetScreenState extends ConsumerState<CyberPetScreen> with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E17),
      appBar: AppBar(
        backgroundColor: Colors.transparent, elevation: 0,
        title: Text('NEON PET', style: GoogleFonts.orbitron(fontWeight: FontWeight.w900, letterSpacing: 4, color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<List<CyberPet>>(
        future: db.select(db.cyberPets).get(),
        builder: (context, snap) {
          final pets = snap.data ?? [];
          if (pets.isEmpty) {
            return Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00FFCC), padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                onPressed: () async {
                  await db.into(db.cyberPets).insert(CyberPetsCompanion.insert(
                    userId: 1,
                    petType: 'NeonCat',
                    name: 'Neko',
                    adoptedAt: DateTime.now(),
                  ));
                  setState(() {}); // refresh
                },
                child: Text('АДОПТУВАТИ ПЕТА', style: GoogleFonts.orbitron(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            );
          }

          final pet = pets.first;
          return Column(
            children: [
              const SizedBox(height: 40),
              // Dialogue Bubble
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 40),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20), bottomLeft: Radius.circular(20)),
                  border: Border.all(color: Colors.white24),
                ),
                child: Text('Мяу! Продовжуй заощаджувати, мені потрібна енергія!', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 14)),
              ),
              const SizedBox(height: 40),
              // Pet Display
              AnimatedBuilder(
                animation: _pulseCtrl,
                builder: (context, child) {
                  return Container(
                    width: 200, height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFF1A1F2E),
                      border: Border.all(color: const Color(0xFF00FFCC).withValues(alpha: 0.5), width: 4),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF00FFCC).withValues(alpha: 0.2 + (_pulseCtrl.value * 0.3)), blurRadius: 40 + (_pulseCtrl.value * 20), spreadRadius: 10),
                      ],
                    ),
                    child: const Icon(Icons.pets, size: 80, color: Color(0xFF00FFCC)),
                  );
                },
              ),
              const SizedBox(height: 32),
              Text(pet.name, style: GoogleFonts.orbitron(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
              Text('Стадія: \$1', style: GoogleFonts.shareTechMono(color: const Color(0xFF00FFCC), fontSize: 14)),
              const SizedBox(height: 40),
              
              // Stats
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(children: [
                  _StatBar(label: 'ЗДОРОВ\'Я', value: pet.health, color: Colors.green),
                  const SizedBox(height: 16),
                  _StatBar(label: 'ЩАСТЯ', value: pet.happiness, color: Colors.cyan),
                ]),
              ),
              const Spacer(),
              // Actions
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _ActionButton(icon: Icons.back_hand, label: 'ГЛАДИТИ', color: Colors.purpleAccent, onTap: () {}),
                    _ActionButton(icon: Icons.chat, label: 'ГОВОРИТИ', color: Colors.cyan, onTap: () {}),
                    _ActionButton(icon: Icons.restaurant, label: 'ГОДУВАТИ', color: Colors.amber, onTap: () {}),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _StatBar extends StatelessWidget {
  final String label;
  final int value;
  final Color color;
  const _StatBar({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 80, child: Text(label, style: GoogleFonts.orbitron(color: Colors.white54, fontSize: 10, fontWeight: FontWeight.bold))),
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(value: value / 100, backgroundColor: Colors.white12, valueColor: AlwaysStoppedAnimation<Color>(color), minHeight: 8),
        ),
      ),
      const SizedBox(width: 12),
      Text('$value%', style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12)),
    ]);
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: 0.2), border: Border.all(color: color.withValues(alpha: 0.5))),
          child: Icon(icon, color: color, size: 28),
        ),
      ),
      const SizedBox(height: 8),
      Text(label, style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.bold)),
    ]);
  }
}
