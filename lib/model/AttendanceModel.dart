class AttendanceDetails {
  final int id;

  final DateTime out;
  final DateTime din;
  final DateTime date;

  final String status;

  AttendanceDetails({
    required this.id,
    required this.date,
    required this.out,
    required this.din,
    required this.status,
  });
}
