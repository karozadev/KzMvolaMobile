import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'history_entry.dart';

const _historyKey = 'kzmvola.history.v1';

/// Persiste l'historique des calculs localement sur l'appareil (aucun serveur,
/// aucun compte). Le jeu de données reste petit (liste simple, pas de
/// requêtes complexes), donc une clé JSON dans `shared_preferences` suffit.
class HistoryRepository {
  Future<List<HistoryEntry>> loadAll() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_historyKey);
    if (raw == null || raw.isEmpty) return [];
    final decoded = jsonDecode(raw) as List;
    return decoded
        .map((item) => HistoryEntry.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveAll(List<HistoryEntry> entries) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(entries.map((e) => e.toJson()).toList());
    await prefs.setString(_historyKey, encoded);
  }
}
