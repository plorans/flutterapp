class TournamentStat {
  final int? torneo;
  final String jugador;
  final String geekTag;
  final int puntos;
  final int omw;

  TournamentStat({
    required this.torneo,
    required this.jugador,
    required this.geekTag,
    required this.puntos,
    required this.omw,
  });

  factory TournamentStat.fromJson(Map<String, dynamic> json) {
    return TournamentStat(
      torneo: json['torneo'] != null
          ? int.tryParse(json['torneo'].toString())
          : null,
      jugador: json['jugador'] ?? '',
      geekTag: json['geek_tag'] ?? '',
      puntos: int.parse(json['puntos'].toString()),
      omw: int.parse(json['omw'].toString()),
    );
  }
}
