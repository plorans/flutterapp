import 'package:flutter/material.dart';
import '../models/tournament_stat.dart';
import '../services/tournament_service.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

class AppColors {
  static const black = Color(0xFF0E0E0E);
  static const blackSoft = Color(0xFF161616);
  static const blackCard = Color(0xFF1F1F1F);

  static const orange = Color(0xFFFF8A00);
  static const orangeSoft = Color(0xFFFFA74A);

  static const white = Colors.white;
  static const whiteMuted = Color(0xFFBDBDBD);
}

class DarkDropdown<T> extends StatelessWidget {
  final T value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const DarkDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48, // 👈 EXACT same height as before
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppColors.blackCard,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppColors.orange.withOpacity(0.6),
          width: 1.2,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<T>(
          value: value,
          items: items,
          onChanged: onChanged,
          isExpanded: true,

          // 👇 THIS is the key difference
          dropdownStyleData: DropdownStyleData(
            offset: const Offset(-4, -4), // pushes menu DOWN
            decoration: BoxDecoration(
              color: AppColors.blackCard,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppColors.orange.withOpacity(0.6),
                width: 1.2,
              ),
            ),
          ),

          buttonStyleData: const ButtonStyleData(
            padding: EdgeInsets.zero, // keeps same internal spacing
            height: 48,
          ),

          iconStyleData: const IconStyleData(
            icon: Icon(Icons.expand_more),
            iconEnabledColor: AppColors.orange,
            iconSize: 24,
          ),

          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14, // matches original
          ),
        ),
      ),
    );
  }
}

class TournamentStatsScreen extends StatefulWidget {
  final String tipo;

  const TournamentStatsScreen({super.key, required this.tipo});

  @override
  State<TournamentStatsScreen> createState() => _TournamentStatsScreenState();
}

class _TournamentStatsScreenState extends State<TournamentStatsScreen> {
  String selectedTcg = 'onepiece';
  late String selectedTipo;
  int selectedTorneo = 1;
  late String selectedMes;

  bool loading = false;
  List<TournamentStat> stats = [];

  final List<int> torneoOptions = [1, 2];

  @override
  void initState() {
    super.initState();
    selectedTipo = widget.tipo;

    final now = DateTime.now();
    selectedMes = '${now.year}-${now.month.toString().padLeft(2, '0')}';

    loadStats();
  }

  Future<void> loadStats() async {
    setState(() => loading = true);

    try {
      stats = await ApiService.fetchTournamentStats(
        tcg: selectedTcg,
        mes: selectedMes,
        tipo: selectedTipo,
      );
    } catch (_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Error loading stats')));
    }

    setState(() => loading = false);
  }

  List<String> getLastMonths(int count) {
    final now = DateTime.now();
    return List.generate(count, (i) {
      final d = DateTime(now.year, now.month - i, 1);
      return '${d.year}-${d.month.toString().padLeft(2, '0')}';
    });
  }

  @override
  Widget build(BuildContext context) {
    final months = getLastMonths(12);

    if (!months.contains(selectedMes)) {
      selectedMes = months.first;
    }

    return Scaffold(
      backgroundColor: AppColors.black,
      appBar: AppBar(
        backgroundColor: AppColors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.orange),
        title: Text(
          selectedTipo == 'global' ? 'RANKING GLOBAL' : 'TORNEOS MENSUALES',
          style: const TextStyle(
            color: AppColors.white,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.4,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DarkDropdown<String>(
                        value: selectedTcg,
                        items: const [
                          DropdownMenuItem(
                            value: 'onepiece',
                            child: Text('One Piece'),
                          ),
                          DropdownMenuItem(
                            value: 'magic',
                            child: Text('Magic the Gathering'),
                          ),
                          DropdownMenuItem(
                            value: 'dragonball',
                            child: Text('Dragon Ball'),
                          ),
                          DropdownMenuItem(
                            value: 'riftbound',
                            child: Text('Riftbound'),
                          ),
                          DropdownMenuItem(
                            value: 'digimon',
                            child: Text('Digimon'),
                          ),
                          DropdownMenuItem(
                            value: 'pokemon',
                            child: Text('Pokemon'),
                          ),
                          DropdownMenuItem(
                            value: 'lorcana',
                            child: Text('Lorcana'),
                          ),
                          DropdownMenuItem(
                            value: 'starwars',
                            child: Text('Star Wars'),
                          ),
                          DropdownMenuItem(
                            value: 'gundam',
                            child: Text('Gundam'),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => selectedTcg = v!);
                          loadStats();
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DarkDropdown<String>(
                        value: selectedTipo,
                        items: const [
                          DropdownMenuItem(
                            value: 'torneos',
                            child: Text('Torneos'),
                          ),
                          DropdownMenuItem(
                            value: 'global',
                            child: Text('Global'),
                          ),
                        ],
                        onChanged: (v) {
                          setState(() => selectedTipo = v!);
                          loadStats();
                        },
                      ),
                    ),
                  ],
                ),

                if (selectedTipo == 'torneos') ...[
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DarkDropdown<String>(
                          value: selectedMes,
                          items: months
                              .map(
                                (m) =>
                                    DropdownMenuItem(value: m, child: Text(m)),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() => selectedMes = v!);
                            loadStats();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DarkDropdown<int>(
                          value: selectedTorneo,
                          items: torneoOptions
                              .map(
                                (t) => DropdownMenuItem(
                                  value: t,
                                  child: Text('Torneo $t'),
                                ),
                              )
                              .toList(),
                          onChanged: (v) {
                            setState(() => selectedTorneo = v!);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),

          const Divider(color: AppColors.blackSoft),

          Expanded(
            child: loading
                ? const Center(
                    child: CircularProgressIndicator(color: AppColors.orange),
                  )
                : _leaderboard(),
          ),
        ],
      ),
    );
  }

  Widget _leaderboard() {
    final filteredStats = selectedTipo == 'torneos'
        ? stats.where((s) => s.torneo == selectedTorneo).toList()
        : stats;

    if (filteredStats.isEmpty) {
      return const Center(
        child: Text('No data', style: TextStyle(color: AppColors.whiteMuted)),
      );
    }

    return ListView.builder(
      itemCount: filteredStats.length,
      itemBuilder: (context, index) {
        final s = filteredStats[index];
        final isTop3 = index < 3;

        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.blackCard,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isTop3 ? AppColors.orange : AppColors.blackSoft,
              width: 1.2,
            ),
            boxShadow: [
              if (isTop3)
                BoxShadow(
                  color: AppColors.orange.withOpacity(0.35),
                  blurRadius: 12,
                ),
            ],
          ),
          child: Row(
            children: [
              Text(
                '#${index + 1}',
                style: TextStyle(
                  color: isTop3 ? AppColors.orange : AppColors.whiteMuted,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  '${s.jugador} ${s.geekTag}',
                  style: const TextStyle(
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${s.puntos} PTS',
                    style: const TextStyle(
                      color: AppColors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'OMW ${s.omw}%',
                    style: const TextStyle(
                      color: AppColors.whiteMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
