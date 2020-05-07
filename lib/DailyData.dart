class DailyData {
  DailyData(
      this.date, this.confirmed, this.active, this.recovered, this.deaths);
  final DateTime date;
  final double confirmed;
  final double active;
  final double recovered;
  final double deaths;
}
