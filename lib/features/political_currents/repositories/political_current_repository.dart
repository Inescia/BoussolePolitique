import '../../../data/political_currents/currents_data.dart';
import '../models/political_current.dart';

class PoliticalCurrentRepository {
  PoliticalCurrentRepository({List<PoliticalCurrent>? currents})
      : _currents = List.unmodifiable(currents ?? loadPoliticalCurrents());

  final List<PoliticalCurrent> _currents;

  List<PoliticalCurrent> getAll() => _currents;

  PoliticalCurrent? getById(String id) {
    for (final c in _currents) {
      if (c.id == id) return c;
    }
    return null;
  }

  List<PoliticalCurrent> search(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return _currents;
    return _currents
        .where(
          (c) =>
              c.name.toLowerCase().contains(q) ||
              c.shortDescription.toLowerCase().contains(q) ||
              c.family.toLowerCase().contains(q),
        )
        .toList();
  }
}
