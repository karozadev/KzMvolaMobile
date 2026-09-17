class FeeTier {
  final int min;
  final int max;
  final int fee;

  const FeeTier({required this.min, required this.max, required this.fee});
}

class FeeGrid {
  final String id;
  final List<FeeTier> tiers;

  const FeeGrid({required this.id, required this.tiers});
}
