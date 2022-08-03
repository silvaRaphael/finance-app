class BillsModel {
  final String name;
  final DateTime date;
  final double value;
  final int type;
  final bool entry;
  const BillsModel({
    required this.name,
    required this.date,
    required this.value,
    required this.type,
    required this.entry,
  });
}
